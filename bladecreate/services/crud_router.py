# coding=utf-8
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query

import bladecreate.db.sqlalchemy as sql
from bladecreate.dependencies import get_db, get_osm
from bladecreate.logging import Logger
from bladecreate.object_storages.osm import ObjectStorageManager
from bladecreate.schemas import (
    UUID,
    ImagesData,
    ImagesURLOrData,
    Project,
    ProjectCreate,
    ProjectUpdate,
)
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)


router = APIRouter(prefix="/api", dependencies=[Depends(get_db), Depends(get_osm)])


@router.get("/images/{user_id}", response_model=ImagesURLOrData)
async def get_image_data_or_url(
    user_id: str,
    image_uuids: Annotated[list[str], Query()] = [],
    osm: ObjectStorageManager = Depends(get_osm),
):
    data = {}
    urls = {}
    for image_uuid in image_uuids:
        url = osm.generate_download_url(
            settings.storage_paths.images.format(
                user_id=user_id,
                image_uuid=image_uuid,
            )
        )
        if url.startswith("data"):
            data[image_uuid] = url
        else:
            urls[image_uuid] = url

    return ImagesURLOrData(urls=urls, data=data)


@router.post("/images/{user_id}")
async def upload_images(
    user_id: str,
    images_data: ImagesData,
    osm: ObjectStorageManager = Depends(get_osm),
):
    for image_uuid in images_data.data:
        image_path = settings.storage_paths.images.format(
            user_id=user_id,
            image_uuid=image_uuid,
        )
        osm.upload_object_from_text(file_key=image_path, text=images_data.data[image_uuid])


@router.get("/projects/{user_id}", response_model=list[Project])
async def get_projects(
    user_id: str,
    uuids: Annotated[list[UUID], Query()] = [],
    db: sql.Session = Depends(get_db),
):
    return sql.select_projects(db, user_id, uuids)


@router.get("/projects/{user_id}/{project_uuid}", response_model=Project)
async def get_project(
    user_id: str,
    project_uuid: UUID,
    db: sql.Session = Depends(get_db),
):
    res = sql.select_projects(db, user_id, [project_uuid])
    if len(res) > 0:
        return res[0]
    else:
        raise HTTPException(status_code=404, detail="Project not found")


@router.post("/projects/{user_id}", response_model=Project)
async def create_project(
    user_id: str,
    body: ProjectCreate,
    db: sql.Session = Depends(get_db),
):
    return sql.create_project(db, user_id, body)


@router.put("/projects/{user_id}/{project_uuid}", response_model=Project)
async def update_project(
    user_id: str,
    project_uuid: UUID,
    body: ProjectUpdate,
    db: sql.Session = Depends(get_db),
):
    res = sql.update_project(db, user_id, project_uuid, body)
    if res is None:
        raise HTTPException(status_code=404, detail="Project not found")
    return res
