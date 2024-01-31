from datetime import datetime
from typing import Any, Optional
from uuid import UUID

from pydantic import BaseModel, ConfigDict


class ImagesURLOrData(BaseModel):
    urls: dict[UUID, str]
    data: dict[UUID, str]


class ImagesData(BaseModel):
    data: dict[UUID, str]


class GenerationParams(BaseModel):
    prompt: str
    negative_prompt: str = ""
    width: int
    height: int
    output_number: int = 1
    inference_steps: int = 10
    seeds: Optional[list[int]] = None


class GenerationBase(BaseModel):
    params: GenerationParams


class Generation(GenerationBase):
    model_config = ConfigDict(from_attributes=True)

    uuid: UUID
    create_time: datetime
    update_time: datetime
    status: str
    elapsed_secs: Optional[float] = None
    percentage: Optional[float] = None

    image_uuids: list[UUID]


class GenerationCreate(GenerationBase):
    uuid: Optional[UUID] = None


class GenerationTask(Generation):
    user_id: str


class GenerationTaskUpdate(Generation):
    pass


class Layer(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    uuid: UUID

    name: str
    x: Optional[float] = None
    y: Optional[float] = None
    width: Optional[float] = None
    height: Optional[float] = None
    rotation: Optional[float] = None

    image_uuid: Optional[UUID] = None
    generation_uuids: list[UUID] = []


class ProjectData(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    layers_order: list[UUID] = []
    layers: dict[UUID, Layer] = {}


class Project(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    uuid: UUID
    create_time: datetime
    update_time: datetime

    name: str
    data: ProjectData


class ProjectCreate(BaseModel):
    uuid: Optional[UUID] = None

    name: str
    data: dict[str, Any] = {}  # Not typed to make openapi generator not generate duplicate types


class ProjectUpdate(BaseModel):
    name: str = ""
    data: dict[str, Any] = {}  # Not typed to make openapi generator not generate duplicate types


class Worker(BaseModel):
    model_config = ConfigDict(from_attributes=True)
    uuid: UUID
    create_time: datetime
    update_time: datetime
    status: str
    current_job: Optional[UUID] = None


class ClusterSnapshot(BaseModel):
    workers: list[Worker]
    active_jobs: list[Generation]


class ClusterEvent(BaseModel):
    screenshot: Optional[ClusterSnapshot] = None
    worker_update: Optional[Worker] = None
    generation_update: Optional[GenerationTaskUpdate] = None
