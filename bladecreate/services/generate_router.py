# coding=utf-8
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException

import bladecreate.db.sqlalchemy as sql
from bladecreate.dependencies import get_db, get_osm
from bladecreate.logging import Logger
from bladecreate.object_storages.osm import ObjectStorageManager
from bladecreate.schemas import Generation, GenerationCreate

logger = Logger.get_logger(__name__)


router = APIRouter(
    prefix="/api",
    dependencies=[
        Depends(get_db),
        Depends(get_osm),
    ],
)


@router.get(
    "/generations/{user_id}/{generation_uuid}",
    response_model=Generation,
)
async def get_generation(
    user_id: str,
    generation_uuid: UUID,
    db: sql.Session = Depends(get_db),
):
    # Step 1: get the entity from the DB if the task ends
    res = sql.get_generation(db, user_id, generation_uuid)
    if res is None:
        raise HTTPException(status_code=404, detail="Generation not found")

    return res


@router.post(
    "/generations/{user_id}",
    response_model=Generation,
)
async def create_generation(
    user_id: str,
    body: GenerationCreate,
    db: sql.Session = Depends(get_db),
    osm: ObjectStorageManager = Depends(get_osm),
):
    logger.debug(f"Creating generation request: {body.model_dump_json(indent=2)}")

    g = sql.create_generation(db, user_id, body)
    return g
