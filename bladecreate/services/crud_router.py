# coding=utf-8
from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, Query

import bladecreate.db.sqlalchemy as sql
from bladecreate.dependencies import get_db, get_osm
from bladecreate.logging import Logger
from bladecreate.object_storages.osm import ObjectStorageManager
from bladecreate.schemas import (
    UUID,
    ImagesURLOrData,
    Layer,
    LayerCreate,
    LayerUpdate,
    Project,
    ProjectCreate,
    ProjectMetadata,
    ProjectUpdate,
)
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)


router = APIRouter(prefix="/api", dependencies=[Depends(get_db), Depends(get_osm)])


@router.get("/projects/{user_id}/images", response_model=ImagesURLOrData)
async def get_image_data_or_url(
    user_id: str,
    image_uuids: Annotated[list[str], Query()] = [],
    osm: ObjectStorageManager = Depends(get_osm),
):
    data = {}
    urls = {}
    for image_uuid in image_uuids:
        try:
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
        except Exception:
            continue

    return ImagesURLOrData(urls=urls, data=data)


@router.get("/projects/{user_id}", response_model=list[ProjectMetadata])
async def get_projects_metadata(
    user_id: str,
    uuids: Annotated[list[str], Query()] = [],
    db: sql.Session = Depends(get_db),
):
    return sql.select_projects_metadata(db, user_id, uuids)


@router.post("/projects/{user_id}", response_model=ProjectMetadata)
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


@router.get("/projects/{user_id}/{project_uuid}", response_model=Project)
async def get_project(
    user_id: str,
    project_uuid: UUID,
    db: sql.Session = Depends(get_db),
    osm: ObjectStorageManager = Depends(get_osm),
):
    # Step 1: get project and its layers from DB
    project, layers, generations = sql.select_project(db, user_id, project_uuid)
    if project is None:
        raise HTTPException(status_code=404, detail="Project not found")

    # Step 2: create downloading URL for frontend
    project.layers = {}
    project.generations = {}
    image_uuids = []
    for layer in layers:
        project.layers[layer.uuid] = layer
        if layer.image_uuid:
            image_uuids.append(layer.image_uuid)

    for g in generations:
        project.generations[g.uuid] = g
        image_uuids.extend(g.image_uuids)

    project.images = await get_image_data_or_url(user_id, image_uuids, osm)

    return project


@router.post(
    "/projects/{user_id}/{project_uuid}/layers",
    response_model=Layer,
)
async def create_project_layer(
    user_id: str,
    project_uuid: UUID,
    body: LayerCreate,
    db: sql.Session = Depends(get_db),
    osm: ObjectStorageManager = Depends(get_osm),
):
    # Step 1: create project layer entity in the DB
    new_layer = sql.create_project_layer(db, user_id, project_uuid, body)
    if new_layer is None:
        raise HTTPException(status_code=404, detail="Layer cannot be created")

    # Step 2: upload image data
    if body.image_data is not None:
        image_path = settings.storage_paths.images.format(
            user_id=user_id,
            image_uuid=new_layer.uuid,
        )
        osm.upload_object_from_text(
            file_key=image_path,
            text=body.image_data,
        )

    return new_layer


@router.put(
    "/projects/{user_id}/{project_uuid}/layers/{layer_uuid}",
    response_model=Layer,
)
async def update_project_layer(
    user_id: str,
    project_uuid: UUID,
    layer_uuid: UUID,
    body: LayerUpdate,
    db: sql.Session = Depends(get_db),
):
    res = sql.update_project_layer(db, user_id, project_uuid, layer_uuid, body)
    if res is None:
        raise HTTPException(status_code=404, detail="Layer not found")
    return res


@router.delete(
    "/projects/{user_id}/{project_uuid}/layers/{layer_uuid}",
    response_model=UUID,
)
async def delete_layer(
    user_id: str,
    project_uuid: UUID,
    layer_uuid: UUID,
    db: sql.Session = Depends(get_db),
):
    res = sql.delete_layer(db, user_id, project_uuid, layer_uuid)
    if res is None:
        raise HTTPException(status_code=404, detail="Layer not found")
    return res
