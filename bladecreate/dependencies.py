import bladecreate.db.sqlalchemy as sql
from bladecreate.logging import Logger
from bladecreate.object_storages.osm import ObjectStorageManager
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)


def get_db() -> sql.SessionLocal:
    db = sql.SessionLocal()
    try:
        yield db
    finally:
        db.close()


def get_osm() -> ObjectStorageManager:
    if settings.is_file_storage:
        from bladecreate.object_storages.file_osm import FileObjectStorageManager

        osm = FileObjectStorageManager()
    else:
        raise Exception("Unknown storage", settings.remote_object_storage.model_dump_json(indent=2))

    try:
        yield osm
    finally:
        pass
