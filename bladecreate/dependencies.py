import bladecreate.sqlalchemy as sql
from bladecreate.logging import Logger
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)


def get_db():
    db = sql.SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_osm():
    if settings.is_file_storage:
        from bladecreate.file_osm import FileObjectStorageManager

        osm = FileObjectStorageManager()
    else:
        raise Exception("Unknown storage", settings.remote_object_storage.model_dump_json(indent=2))

    try:
        yield osm
    finally:
        pass


def get_sdxl():
    if settings.gpu_platform is None:
        return None

    elif settings.gpu_platform.is_cuda:
        from bladecreate.models.cuda_sd import CUDASDXL

        sdxl = CUDASDXL.instance()

    elif settings.gpu_platform.is_mac:
        from bladecreate.models.mac_sd import MacSDXL

        sdxl = MacSDXL.instance()

    else:
        raise Exception(f"GPU platform {settings.gpu_platform} is not supported")

    return sdxl
