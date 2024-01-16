import time
from typing import Any

import socketio

from bladecreate.logging import Logger
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)


class Worker:
    def __init__(
        self,
        url: str = f"http://localhost:{settings.server.port}/",
        socketio_path: str = "api/socket.io",
        task_limit: int = -1,
    ):
        self.url = url
        self.socketio_path = socketio_path
        self.namespace = "/worker"
        self.task_limit = task_limit
        self.task_count = 0
        self.closing = False

    def send(self, data: Any):
        self.sio.emit(event="worker_event", data=data, namespace=self.namespace)

    def init_worker(self):
        pass

    def fetch_and_run_task(self):
        pass

    def run(self):
        logger.info("Worker is starting")

        self.sio = socketio.Client()
        for _ in range(10):
            try:
                self.sio.connect(
                    url=self.url,
                    socketio_path=self.socketio_path,
                    namespaces=self.namespace,
                    transports=["websocket"],
                )
            except Exception:
                time.sleep(1)
            else:
                break
        logger.info("Worker is connected")
        self.send("Worker is connected")

        self.init_worker()
        logger.info("Worker is initialized")
        self.send("Worker is initialized")

        while not self.closing:
            self.task_count += 1
            if self.task_limit > 0 and self.task_count >= self.task_limit:
                self.closing = True
            self.fetch_and_run_task()
            time.sleep(0.1)

        self.send("Worker is exiting")
        logger.info("Worker is exiting")
        time.sleep(1)  # Sleep for one second and hope all messages are sent.
        self.sio.disconnect()
        logger.info("Worker is exited")
