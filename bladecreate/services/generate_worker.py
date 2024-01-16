import io
import uuid
from contextlib import contextmanager

import bladecreate.db.sqlalchemy as sql
from bladecreate.data_utils import image_bytes_to_inline_data
from bladecreate.dependencies import get_db, get_osm
from bladecreate.logging import Logger
from bladecreate.models.sd import SDXL
from bladecreate.object_storages.osm import ObjectStorageManager
from bladecreate.services.worker import Worker
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


class GenerateWorker(Worker):
    def init_worker(self):
        self.sdxl: SDXL = init_model()

    def handle_fetch_and_run_task(self, db: sql.SessionLocal, osm: ObjectStorageManager):
        sdxl = self.sdxl
        # Step 1: fetch task
        g = sql.pop_most_recent_generation_task(db)
        if g is None:
            return

        logger.debug(f"Fetched task successfully {g.uuid}: {g.params}")
        self.send(f"Task {g.uuid} is Running")

        # Step 2: Initialize generation request
        HW_LOOKUP = {
            "1:1": {"width": 512, "height": 512},
            "4:3": {"width": 800, "height": 600},
            "16:9": {"width": 1600, "height": 900},
        }
        prompt = g.params.prompt
        negative_prompt = g.params.negative_prompt
        height = HW_LOOKUP[g.params.h_w_ratio]["height"]
        width = HW_LOOKUP[g.params.h_w_ratio]["width"]
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
        self.send(f"Task {g.uuid} is uploading")
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
        logger.debug(f"Updating status to SUCCEEDED {g.uuid}")
        self.send(f"Task {g.uuid} is succeeding")
        sql.update_generation_succeeded(db, g.uuid, image_uuid_to_data.keys())

        logger.debug(f"Task {g.uuid} is succeeded")
        self.send(f"Task {g.uuid} is succeeded")

    def fetch_and_run_task(self):
        with contextmanager(get_db)() as db, contextmanager(get_osm)() as osm:
            self.handle_fetch_and_run_task(db, osm)


if __name__ == "__main__":
    w = GenerateWorker()
    w.run()
