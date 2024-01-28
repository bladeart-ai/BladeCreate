import time
import uuid
from datetime import datetime, timedelta

import httpx

from bladecreate.db import sqlalchemy as sql
from bladecreate.dependencies import AppDependencies
from bladecreate.logging import Logger
from bladecreate.object_storages.osm import ObjectStorageManager
from bladecreate.schemas import Worker
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)


class WorkerRunner:
    def __init__(
        self,
        url: str = f"http://localhost:{settings.server.port}",
        task_limit: int = -1,
    ):
        self.url = url
        self.task_limit = task_limit
        self.task_count = 0
        self.worker_model = Worker(
            uuid=uuid.uuid4(),
            create_time=datetime.utcnow(),
            update_time=datetime.utcnow(),
            status="starting",
        )
        self.closing = False

    def send_worker_status_heartbeat(self, force: bool = False):
        until = self.last_worker_status_heartbeat + timedelta(seconds=15)
        if force or datetime.utcnow() >= until:
            self.last_worker_status_heartbeat = datetime.utcnow()
            r = httpx.put(
                self.url + f"/workers/{self.worker_model.uuid}",
                json=self.worker_model.model_dump(mode="json"),
            )
            if r.status_code == 200:
                return
            else:
                raise Exception(
                    "Unexpected response of send_worker_status_heartbeat from API server"
                )

    def update_status(self, status: str):
        logger.info(f"Worker status: {status}")
        self.worker_model.status = status
        self.last_worker_status_heartbeat = datetime.utcnow()
        r = httpx.put(
            self.url + f"/workers/{self.worker_model.uuid}",
            json=self.worker_model.model_dump(mode="json"),
        )
        if r.status_code == 200:
            return
        else:
            raise Exception("Unexpected response of update_status from API server", r.content)

    def init_worker(self):
        pass

    def handle_fetch_and_run_task(self, db: sql.SessionLocal, osm: ObjectStorageManager):
        pass

    def fetch_and_run_task(self):
        dep = AppDependencies()
        self.handle_fetch_and_run_task(dep.db, dep.osm)

    def run(self):
        self.update_status("starting")
        self.init_worker()
        self.update_status("initialized")

        while not self.closing:
            try:
                self.send_worker_status_heartbeat()
                self.fetch_and_run_task()
                self.send_worker_status_heartbeat()
                time.sleep(0.1)

                self.task_count += 1
                if self.task_limit > 0 and self.task_count >= self.task_limit:
                    self.closing = True

            except Exception as e:
                logger.exception(e)
                time.sleep(5)
                continue

        self.update_status("exiting")
        logger.info("Worker status: exited")
