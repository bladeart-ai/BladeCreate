# coding=utf-8
import concurrent.futures
import datetime
import multiprocessing
import time
import uuid

import pytest  # noqa: F401
from pydantic import TypeAdapter
from websockets.sync.client import connect

import bladecreate.db.sqlalchemy as sql
from bladecreate.logging import Logger
from bladecreate.schemas import (
    ClusterEvent,
    ClusterSnapshot,
    Generation,
    GenerationCreate,
    GenerationParams,
    Worker,
)
from bladecreate.services.generate_worker import GenerateWorkerRunner, init_model
from bladecreate.services.worker import WorkerRunner
from bladecreate.settings import settings, uvicorn_logging

logger = Logger.get_logger(__name__)


def compare_cluster_events(source: list[ClusterEvent], expected: list[ClusterEvent]):
    assert len(source) == len(expected)

    for ix in range(len(source)):
        s, e = source[ix], expected[ix]

        if s.generation_updates is not None and e.generation_updates is not None:
            assert s.generation_updates.keys() == e.generation_updates.keys()
            assert [g.status for g in s.generation_updates.values()] == [
                g.status for g in e.generation_updates.values()
            ]
            assert [len(g.image_uuids) for g in s.generation_updates.values()] == [
                len(g.image_uuids) for g in e.generation_updates.values()
            ]
        elif s.generation_updates is not None and e.generation_updates is None:
            assert False
        elif s.generation_updates is None and e.generation_updates is not None:
            assert False

        if s.screenshot is not None and e.screenshot is not None:
            assert [w.status for w in s.screenshot.workers] == [
                w.status for w in e.screenshot.workers
            ]
            assert [j.status for j in s.screenshot.active_jobs] == [
                j.status for j in e.screenshot.active_jobs
            ]
            assert [len(j.image_uuids) for j in s.screenshot.active_jobs] == [
                len(j.image_uuids) for j in e.screenshot.active_jobs
            ]
        elif s.screenshot is not None and e.screenshot is None:
            assert False
        elif s.screenshot is None and e.screenshot is not None:
            assert False

        if s.workerUpdate is not None and e.workerUpdate is not None:
            assert s.workerUpdate.status == e.workerUpdate.status
        if s.workerUpdate is not None and e.workerUpdate is None:
            assert False
        if s.workerUpdate is None and e.workerUpdate is not None:
            assert False


def clearup_db(db: sql.SessionLocal):
    # Consume all sstarted task until empty
    while True:
        g = sql.pop_most_recent_generation_task(db)
        if g is None:
            break
        else:
            g.status = "SUCCEEDED"
            sql.update_generation(db, g)
            time.sleep(0.1)

    # Wait until all workers are inactive
    while True:
        s = sql.get_cluster_snapshot(db)
        if len(s.workers) == 0:
            break
        else:
            time.sleep(5)


def run_server():
    import uvicorn

    from bladecreate.app import app

    uvicorn.run(
        app,
        host=settings.server.host,
        port=settings.server.port,
        log_config=uvicorn_logging,
    )


def run_worker_runner():
    w = WorkerRunner(task_limit=5)
    w.run()


def run_generate_worker():
    w = GenerateWorkerRunner(task_limit=5)
    w.run()


def run_test_client(expected: list[ClusterEvent]):
    logger = Logger.get_logger("client")

    received = []
    with connect("ws://localhost:8080/ws") as websocket:
        while True:
            data = websocket.recv()
            data_obj = TypeAdapter(ClusterEvent).validate_json(data)
            logger.info(f"Received: {data_obj}")
            received.append(data_obj)
            if data_obj.workerUpdate is not None and data_obj.workerUpdate.status == "EXITING":
                break

    try:
        compare_cluster_events(received, expected)
    except Exception as e:
        logger.error(e)
        raise e
    finally:
        for e in received:
            logger.info(f"All received: {e}")


def test_worker(db: sql.SessionLocal):
    clearup_db(db)

    expected = [
        ClusterEvent(
            screenshot=ClusterSnapshot(
                workers=[],
                active_jobs=[],
            )
        ),
        ClusterEvent(
            workerUpdate=Worker(
                uuid=uuid.uuid4(),
                create_time=datetime.datetime.now(),
                update_time=datetime.datetime.now(),
                status="STARTING",
            )
        ),
        ClusterEvent(
            workerUpdate=Worker(
                uuid=uuid.uuid4(),
                create_time=datetime.datetime.now(),
                update_time=datetime.datetime.now(),
                status="INITIALIZED",
            )
        ),
        ClusterEvent(
            workerUpdate=Worker(
                uuid=uuid.uuid4(),
                create_time=datetime.datetime.now(),
                update_time=datetime.datetime.now(),
                status="EXITING",
            )
        ),
    ]

    server_p = multiprocessing.Process(name="Server", target=run_server)
    server_p.start()
    time.sleep(1)

    executor = concurrent.futures.ThreadPoolExecutor(max_workers=1)
    future = executor.submit(run_test_client, expected)
    time.sleep(1)

    worker_p = multiprocessing.Process(name="Worker", target=run_worker_runner)
    worker_p.start()

    worker_p.join()
    res = future.result()
    e = future.exception()
    server_p.terminate()

    assert worker_p.exitcode == 0
    assert res is None
    assert e is None


def test_init_model():
    init_model()


def test_generate_worker(db: sql.SessionLocal, user_id: str):
    clearup_db(db)

    # Prepare generate task
    g1_req = GenerationCreate(
        uuid=uuid.uuid4(),
        params=GenerationParams(
            prompt="haha",
            negative_prompt="hehe",
            output_number=3,
            height=100,
            width=100,
            seeds=[123456],
        ),
    )
    g2_req = GenerationCreate(
        uuid=uuid.uuid4(),
        params=GenerationParams(
            prompt="haha2",
            negative_prompt="hehe2",
            output_number=1,
            height=400,
            width=300,
            seeds=[11111],
        ),
    )
    g1 = sql.create_generation(db, user_id, g1_req)
    g2 = sql.create_generation(db, user_id, g2_req)
    g_get = sql.get_generations(db, user_id, [g1.uuid, g2.uuid], active_only=False)
    assert g1, g2 == g_get

    expected = [
        ClusterEvent(
            screenshot=ClusterSnapshot(
                workers=[],
                active_jobs=[
                    Generation(
                        uuid=g1.uuid,
                        params=g1_req.params,
                        create_time=datetime.datetime.now(),
                        update_time=datetime.datetime.now(),
                        status="CREATED",
                        image_uuids=[],
                    ),
                    Generation(
                        uuid=g2.uuid,
                        params=g2_req.params,
                        create_time=datetime.datetime.now(),
                        update_time=datetime.datetime.now(),
                        status="CREATED",
                        image_uuids=[],
                    ),
                ],
            )
        ),
        ClusterEvent(
            workerUpdate=Worker(
                uuid=uuid.uuid4(),
                create_time=datetime.datetime.now(),
                update_time=datetime.datetime.now(),
                status="STARTING",
            )
        ),
        ClusterEvent(
            workerUpdate=Worker(
                uuid=uuid.uuid4(),
                create_time=datetime.datetime.now(),
                update_time=datetime.datetime.now(),
                status="INITIALIZED",
            )
        ),
        ClusterEvent(generationUpdate=g1),
        ClusterEvent(generationUpdate=Generation(**g1, status="SUCCEEDED")),
        ClusterEvent(generationUpdate=g2),
        ClusterEvent(generationUpdate=Generation(**g2, status="SUCCEEDED")),
        ClusterEvent(
            workerUpdate=Worker(
                uuid=uuid.uuid4(),
                create_time=datetime.datetime.now(),
                update_time=datetime.datetime.now(),
                status="EXITING",
            )
        ),
    ]

    server_p = multiprocessing.Process(name="Server", target=run_server)
    server_p.start()
    time.sleep(1)

    executor = concurrent.futures.ThreadPoolExecutor(max_workers=1)
    future = executor.submit(run_test_client, expected)

    worker_p = multiprocessing.Process(name="Worker", target=run_generate_worker)
    worker_p.start()

    worker_p.join()
    res = future.result()
    e = future.exception()
    server_p.terminate()

    assert worker_p.exitcode == 0
    assert res is None
    assert e is None
