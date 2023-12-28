# coding=utf-8
import io
import logging
import uuid

from fastapi import APIRouter, Depends
from pydantic import TypeAdapter

import bladecreate.sqlalchemy as sql
from bladecreate.config import IMAGE_PATH_FORMAT
from bladecreate.data_utils import image_bytes_to_inline_data
from bladecreate.dependencies import get_db, get_osm, get_sdxl
from bladecreate.logging_setup import logging_setup
from bladecreate.models.sd import SDXL
from bladecreate.osm import ObjectStorageManager
from bladecreate.schemas import (
    UUID,
    GenerationCreate,
    GenerationDone,
    ImagesURLOrData,
)

logging_setup()
logger = logging.getLogger(__name__)
logger.info("logger is configured!")

get_sdxl()


router = APIRouter(
    prefix="/api",
    dependencies=[Depends(get_db), Depends(get_osm), Depends(get_sdxl)],
)


@router.post(
    "/projects/{user_id}/{project_uuid}/generate",
    response_model=GenerationDone,
)
async def generate(
    user_id: str,
    project_uuid: UUID,
    body: GenerationCreate,
    db: sql.Session = Depends(get_db),
    osm: ObjectStorageManager = Depends(get_osm),
    sdxl: SDXL = Depends(get_sdxl),
):
    logger.info("Handling generation request", body.model_dump())

    # Step 0: Reject generation requests
    # TODO: if a generation of the specified layer is in progress, reject
    # TODO: if the generation request are equal to the most recent generation, reject

    # Step 1: Create a generation entity in the DB
    g = sql.create_generation(db, user_id, project_uuid, body)

    # Step 2: Call generation on GPU
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

    images = sdxl.generate(
        prompt, negative_prompt, height, width, output_number, seeds
    )
    image_uuid_to_bytes = {}
    for img in images:
        with io.BytesIO() as bytes_io:
            img.save(bytes_io, format="png")
            image_uuid_to_bytes[uuid.uuid4()] = bytes_io.getvalue()

    # Step 3: upload results
    image_uuid_to_data = {
        k: image_bytes_to_inline_data(image_uuid_to_bytes[k], "png")
        for k in image_uuid_to_bytes
    }
    osm.upload_objects_from_text(
        {
            IMAGE_PATH_FORMAT.format(
                user_id=user_id,
                project_uuid=project_uuid,
                image_uuid=k,
            ): image_uuid_to_data[k]
            for k in image_uuid_to_data
        }
    )

    # Step 4: update generation
    g_image_uuids = image_uuid_to_data.keys()
    updated_g = sql.update_generation_succeeded(db, g, g_image_uuids)

    res = TypeAdapter(GenerationDone).validate_python(updated_g)
    res.images = ImagesURLOrData(urls={}, data=image_uuid_to_data)
    return res
