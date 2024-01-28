# coding=utf-8
from typing import Annotated
from uuid import UUID

from fastapi import APIRouter, Depends, HTTPException, Query

import bladecreate.db.sqlalchemy as sql
from bladecreate.dependencies import AppDependencies
from bladecreate.logging import Logger
from bladecreate.schemas import Project, ProjectCreate, ProjectUpdate

logger = Logger.get_logger(__name__)


router = APIRouter(dependencies=[Depends(AppDependencies)])


@router.get("/projects/{user_id}", response_model=list[Project])
async def get_projects(
    user_id: str,
    uuids: Annotated[list[UUID], Query()] = [],
    dep: AppDependencies = Depends(AppDependencies),
):
    return sql.select_projects(dep.db, user_id, uuids)


@router.get("/projects/{user_id}/{project_uuid}", response_model=Project)
async def get_project(
    user_id: str,
    project_uuid: UUID,
    dep: AppDependencies = Depends(AppDependencies),
):
    res = sql.select_projects(dep.db, user_id, [project_uuid])
    if len(res) > 0:
        return res[0]
    else:
        raise HTTPException(status_code=404, detail="Project not found")


@router.post("/projects/{user_id}", response_model=Project)
async def create_project(
    user_id: str,
    body: ProjectCreate,
    dep: AppDependencies = Depends(AppDependencies),
):
    return sql.create_project(dep.db, user_id, body)


@router.put("/projects/{user_id}/{project_uuid}", response_model=Project)
async def update_project(
    user_id: str,
    project_uuid: UUID,
    body: ProjectUpdate,
    dep: AppDependencies = Depends(AppDependencies),
):
    res = sql.update_project(dep.db, user_id, project_uuid, body)
    if res is None:
        raise HTTPException(status_code=404, detail="Project not found")
    return res
