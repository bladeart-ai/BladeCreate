import io
import uuid
from typing import Optional

import httpx
from pydantic import TypeAdapter

import bladecreate.db.sqlalchemy as sql
from bladecreate.data_utils import image_bytes_to_inline_data
from bladecreate.logging import Logger
from bladecreate.models.sd import SDXL
from bladecreate.object_storages.osm import ObjectStorageManager
from bladecreate.schemas import Generation, GenerationTask, GenerationTaskUpdate
from bladecreate.services.worker import WorkerRunner
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)


def init_model():
    if settings.gpu_platform is None:
        raise Exception(f"GPU platform {settings.gpu_platform} is not supported")

    elif settings.gpu_platform.is_cuda:
        from bladecreate.models.cuda_sd import CUDASDXL

        return CUDASDXL.instance()

    elif settings.gpu_platform.is_mac:
        from bladecreate.models.mac_sd import MacSDXL

        return MacSDXL.instance()

    else:
        raise Exception(f"GPU platform {settings.gpu_platform} is not supported")


class GenerateWorkerRunner(WorkerRunner):
    def init_worker(self):
        self.sdxl: SDXL = init_model()

    def pop_task(self, db: sql.SessionLocal) -> Optional[GenerationTask]:
        return sql.pop_most_recent_generation_task(db)

    def update_task(self, g: Generation):
        r = httpx.put(
            self.url + f"/generations/{g.uuid}",
            json=TypeAdapter(GenerationTaskUpdate).validate_python(g).model_dump(mode="json"),
        )
        if r.status_code == 200:
            return
        else:
            raise Exception("Unexpected response of update_task from API server", r)

    def handle_fetch_and_run_task(self, db: sql.SessionLocal, osm: ObjectStorageManager):
        sdxl = self.sdxl
        # Step 1: fetch task
        g = self.pop_task(db)
        if g is None:
            self.worker_model.current_job = None
            self.send_worker_status_heartbeat(True)
            return

        logger.debug(f"Started task successfully {g.uuid}: {g.params}")
        self.worker_model.current_job = g.uuid
        self.send_worker_status_heartbeat(True)
        self.update_task(g)

        # Step 2: Initialize generation request
        prompt = g.params.prompt
        negative_prompt = g.params.negative_prompt
        height = g.params.height
        width = g.params.width
        output_number = g.params.output_number
        if g.params.seeds:
            seeds = [
                g.params.seeds[ix] if ix < len(g.params.seeds) else -1
                for ix in range(0, output_number)
            ]
        else:
            seeds = [-1] * output_number

        # Step 2: call generate
        images = sdxl.generate(prompt, negative_prompt, height, width, output_number, seeds)
        image_uuid_to_bytes = {}
        for img in images:
            with io.BytesIO() as bytes_io:
                img.save(bytes_io, format="png")
                image_uuid_to_bytes[uuid.uuid4()] = bytes_io.getvalue()

        # Step 3: upload results
        logger.debug(f"Uploading results {g.uuid}: {g.image_uuids}")
        image_uuid_to_data = {
            k: image_bytes_to_inline_data(image_uuid_to_bytes[k], "png")
            for k in image_uuid_to_bytes
        }
        osm.upload_objects_from_text(
            {
                settings.storage_paths.images.format(
                    user_id=g.user_id,
                    image_uuid=k,
                ): image_uuid_to_data[k]
                for k in image_uuid_to_data
            }
        )

        # Step 4: update generation
        g.status = "SUCCEEDED"
        g.image_uuids = image_uuid_to_data.keys()
        logger.debug(f"Task {g.uuid} is succeeded")
        self.update_task(g)


if __name__ == "__main__":
    w = GenerateWorkerRunner()
    w.run()
