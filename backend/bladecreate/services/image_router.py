# coding=utf-8
from typing import Annotated

from fastapi import APIRouter, Depends, Query

from bladecreate.dependencies import AppDependencies
from bladecreate.logging import Logger
from bladecreate.schemas import ImagesData, ImagesURLOrData
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)


router = APIRouter(dependencies=[Depends(AppDependencies)])


@router.get("/images/{user_id}", response_model=ImagesURLOrData)
async def get_image_data_or_url(
    user_id: str,
    image_uuids: Annotated[list[str], Query()] = [],
    dep: AppDependencies = Depends(AppDependencies),
):
    data = {}
    urls = {}
    for image_uuid in image_uuids:
        url = dep.osm.generate_download_url(
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
    dep: AppDependencies = Depends(AppDependencies),
):
    for image_uuid in images_data.data:
        image_path = settings.storage_paths.images.format(
            user_id=user_id,
            image_uuid=image_uuid,
        )
        dep.osm.upload_object_from_text(file_key=image_path, text=images_data.data[image_uuid])
