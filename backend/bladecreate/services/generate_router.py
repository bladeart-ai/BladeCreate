# coding=utf-8
import logging
from typing import Annotated, Optional
from uuid import UUID

from fastapi import (
    APIRouter,
    Depends,
    HTTPException,
    Query,
    WebSocket,
    WebSocketDisconnect,
)

import bladecreate.db.sqlalchemy as sql
from bladecreate.dependencies import AppDependencies
from bladecreate.logging import Logger
from bladecreate.schemas import (
    ClusterEvent,
    Generation,
    GenerationCreate,
    GenerationTask,
    GenerationTaskUpdate,
    Worker,
)

logger = Logger.get_logger(__name__)


# Disable Worker heartbeat logging
class EndpointFilter(logging.Filter):
    def filter(self, record: logging.LogRecord) -> bool:
        return record.getMessage().find("/workers") == -1 or record.levelname != "INFO"


logging.getLogger("uvicorn.access").addFilter(EndpointFilter())

router = APIRouter(dependencies=[Depends(AppDependencies)])


@router.websocket("/ws")
async def subscribe_all_events(
    ws: WebSocket,
    dep: AppDependencies = Depends(AppDependencies),
):
    await ws.accept()
    try:
        while True:
            dep.add_ws(ws)
            await ws.send_json(
                ClusterEvent(screenshot=sql.get_cluster_snapshot(dep.db)).model_dump(mode="json")
            )
            await ws.receive_json()
    except WebSocketDisconnect:
        dep.remove_ws(ws)


@router.get(
    "/generations/{user_id}",
    response_model=list[Generation],
)
async def get_generations(
    user_id: str,
    generation_uuids: Annotated[list[UUID], Query()] = [],
    active_only: Annotated[bool, Query()] = False,
    dep: AppDependencies = Depends(AppDependencies),
):
    res = sql.get_generations(dep.db, user_id, generation_uuids, active_only)
    if len(res) != len(generation_uuids):
        raise HTTPException(status_code=404, detail="Generation not found")

    return res


@router.post(
    "/generations/{user_id}",
    response_model=Generation,
)
async def create_generation(
    user_id: str,
    body: GenerationCreate,
    dep: AppDependencies = Depends(AppDependencies),
):
    logger.debug(f"Creating generation request: {body.model_dump_json(indent=2)}")

    g = sql.create_generation(dep.db, user_id, body)
    return g


@router.post("/workers/{worker_uuid}/pop_generation_task", response_model=Optional[GenerationTask])
async def pop_generation_task(
    worker_uuid: UUID,
    dep: AppDependencies = Depends(AppDependencies),
):
    return sql.pop_most_recent_generation_task(dep.db)


@router.put("/generations/{generation_uuid}")
async def update_generation(
    generation_uuid: UUID,
    body: GenerationTaskUpdate,
    dep: AppDependencies = Depends(AppDependencies),
):
    g = sql.update_generation(dep.db, body)
    if g is None:
        raise HTTPException(status_code=404, detail="Generation not found")

    await dep.dispatch_event(ClusterEvent(generationUpdate=body))


@router.put("/workers/{worker_uuid}")
async def upsert_worker(
    worker_uuid: UUID,
    body: Worker,
    dep: AppDependencies = Depends(AppDependencies),
):
    g = sql.upsert_worker(dep.db, worker_uuid, body.status)
    if g is None:
        raise HTTPException(status_code=404, detail="Generation not found")

    await dep.dispatch_event(ClusterEvent(workerUpdate=body))


@router.get("/cluster", response_model=ClusterEvent)
async def get_cluster_snapshot(
    dep: AppDependencies = Depends(AppDependencies),
):
    return ClusterEvent(screenshot=sql.get_cluster_snapshot(dep.db))
