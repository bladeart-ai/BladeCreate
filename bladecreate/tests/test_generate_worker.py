# coding=utf-8
import concurrent.futures
import multiprocessing
import time
import uuid

import pytest  # noqa: F401
import socketio

import bladecreate.db.sqlalchemy as sql
from bladecreate.logging import Logger
from bladecreate.schemas import GenerationCreate, GenerationParams
from bladecreate.services.generate_worker import GenerateWorker, init_model
from bladecreate.services.worker import Worker
from bladecreate.settings import settings, uvicorn_logging

logger = Logger.get_logger(__name__)


class TestWorker(Worker):
    def fetch_and_run_task(self):
        logger.info(f"Finished task {self.task_limit}")
        self.send(f"Finished task {self.task_limit}")


def run_server():
    import uvicorn

    from bladecreate.app import app

    uvicorn.run(
        app,
        host=settings.server.host,
        port=settings.server.port,
        log_config=uvicorn_logging,
    )


def run_test_worker():
    w = TestWorker(task_limit=5)
    w.run()


def run_generate_worker():
    w = GenerateWorker(task_limit=5)
    w.run()


def run_test_client(expected):
    logger = Logger.get_logger("client")

    sio = socketio.SimpleClient()
    for _ in range(10):
        try:
            sio.connect(
                url="http://localhost:8080/",
                socketio_path="api/socket.io",
                namespace="/client",
                transports=["websocket"],
            )
        except Exception:
            time.sleep(1)
        else:
            break
    received = []
    while True:
        event, data = sio.receive()
        logger.debug("Client received %s: %s", event, data)
        assert event == "worker_event"
        received.append(data)
        if data == "Worker is exiting":
            break

    sio.disconnect()
    logger.info(f"All client received: {received}")
    assert received == expected


def test_worker():
    expected = [
        "Worker is connected",
        "Worker is initialized",
        "Finished task 4",
        "Finished task 3",
        "Finished task 2",
        "Finished task 1",
        "Finished task 0",
        "Worker is exiting",
    ]

    server_p = multiprocessing.Process(name="Server", target=run_server)
    server_p.start()
    time.sleep(1)

    executor = concurrent.futures.ThreadPoolExecutor(max_workers=1)
    future = executor.submit(run_test_client, expected)

    worker_p = multiprocessing.Process(name="Worker", target=run_test_worker)
    worker_p.start()

    worker_p.join()
    e = future.exception()
    server_p.terminate()

    assert worker_p.exitcode == 0
    assert e is None


def test_init_model():
    init_model()


def test_generate_worker(db: sql.SessionLocal, user_id: str):
    # Consume all sstarted task until empty
    while True:
        g = sql.pop_most_recent_generation_task(db)
        if g is None:
            break

    # Prepare generate task
    g1 = sql.create_generation(
        db,
        user_id,
        GenerationCreate(
            uuid=uuid.uuid4(),
            params=GenerationParams(
                prompt="haha",
                negative_prompt="hehe",
                output_number=3,
                h_w_ratio="1:1",
                seeds=[123456],
            ),
        ),
    )
    g2 = sql.create_generation(
        db,
        user_id,
        GenerationCreate(
            uuid=uuid.uuid4(),
            params=GenerationParams(
                prompt="haha2",
                negative_prompt="hehe2",
                output_number=1,
                h_w_ratio="4:3",
                seeds=[11111],
            ),
        ),
    )
    g_get = sql.get_generation(db, user_id, g1.uuid)
    assert g1 == g_get
    g_get = sql.get_generation(db, user_id, g2.uuid)
    assert g2 == g_get

    expected = [
        "Worker is connected",
        "Worker is initialized",
        f"Task {g1.uuid} is Running",
        f"Task {g1.uuid} is uploading",
        f"Task {g1.uuid} is succeeding",
        f"Task {g1.uuid} is succeeded",
        f"Task {g2.uuid} is Running",
        f"Task {g2.uuid} is uploading",
        f"Task {g2.uuid} is succeeding",
        f"Task {g2.uuid} is succeeded",
        "Worker is exiting",
    ]

    server_p = multiprocessing.Process(name="Server", target=run_server)
    server_p.start()
    time.sleep(1)

    executor = concurrent.futures.ThreadPoolExecutor(max_workers=1)
    future = executor.submit(run_test_client, expected)

    worker_p = multiprocessing.Process(name="Worker", target=run_generate_worker)
    worker_p.start()

    worker_p.join()
    e = future.exception()
    server_p.terminate()

    assert worker_p.exitcode == 0
    assert e is None
