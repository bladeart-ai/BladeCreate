from typing import Optional

from fastapi import WebSocket

from bladecreate.logging import Logger
from bladecreate.schemas import ClusterEvent
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)


class AppDependencies:
    ws: list[WebSocket] = []
    wsLastEvents: dict[WebSocket, Optional[ClusterEvent]] = {}

    def __init__(self) -> None:
        self.init_db()
        self.init_osm()

    def init_db(self):
        import bladecreate.db.sqlalchemy as sql

        self.db = sql.SessionLocal()

    def init_osm(self):
        if settings.is_file_storage:
            from bladecreate.object_storages.file_osm import (
                FileObjectStorageManager,
                ObjectStorageManager,
            )

            self.osm: ObjectStorageManager = FileObjectStorageManager()
        else:
            raise Exception(
                "Unknown storage", settings.remote_object_storage.model_dump_json(indent=2)
            )

    def add_ws(self, ws: WebSocket):
        logger.info(f"client connected: {ws}")
        self.__class__.ws.append(ws)
        self.__class__.wsLastEvents[ws] = None

    def remove_ws(self, ws: WebSocket):
        logger.info(f"client disconnected: {ws}")
        self.__class__.ws.remove(ws)
        self.__class__.wsLastEvents.pop(ws)

    async def dispatch_event(self, event: ClusterEvent):
        for ws in self.__class__.ws:
            last_event = self.__class__.wsLastEvents[ws]
            if (
                last_event is not None
                and last_event.worker_update is not None
                and event.worker_update is not None
                and last_event.worker_update.uuid == event.worker_update.uuid
                and last_event.worker_update.status == event.worker_update.status
                and last_event.worker_update.current_job == event.worker_update.current_job
            ):
                continue

            self.__class__.wsLastEvents[ws] = event
            await ws.send_json(event.model_dump(mode="json"))

    def __del__(self):
        self.db.close()
