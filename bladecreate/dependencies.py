import logging

import bladecreate.sqlalchemy as sql
from bladecreate.config import (
    CUDA,
    FILE_OBJECT_STORAGE,
    GPU_PLATFORM,
    MAC,
    OBJECT_STORAGE,
)
from bladecreate.logging_setup import logging_setup

logging_setup()
logger = logging.getLogger(__name__)
logger.info("logger is configured!")


def get_db():
    db = sql.SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_osm():
    if OBJECT_STORAGE == FILE_OBJECT_STORAGE:
        from bladecreate.file_osm import FileObjectStorageManager

        osm = FileObjectStorageManager()
    else:
        raise Exception("Unknown storage", OBJECT_STORAGE)

    try:
        yield osm
    finally:
        pass


def get_sdxl():
    if GPU_PLATFORM == CUDA:
        from bladecreate.models.cuda_sd import CUDASDXL

        sdxl = CUDASDXL.instance()
    elif GPU_PLATFORM == MAC:
        from bladecreate.models.mac_sd import MacSDXL

        sdxl = MacSDXL.instance()
    else:
        raise Exception(f"GPU platform {GPU_PLATFORM} is not supported")

    return sdxl
