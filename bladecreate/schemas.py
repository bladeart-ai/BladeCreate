from datetime import datetime
from enum import Enum
from typing import Any, Optional
from uuid import UUID

from pydantic import BaseModel, ConfigDict


class ImagesData(BaseModel):
    data: dict[UUID, str]


class ImagesURLOrData(BaseModel):
    urls: dict[UUID, str]
    data: dict[UUID, str]


class HWRatioEnum(str, Enum):
    val1 = "1:1"
    val2 = "4:3"
    val3 = "16:9"


class GenerationParams(BaseModel):
    prompt: str
    negative_prompt: Optional[str] = ""
    h_w_ratio: Optional[HWRatioEnum] = "4:3"
    output_number: Optional[int] = 1
    seeds: Optional[list[int]] = None


class GenerationBase(BaseModel):
    params: GenerationParams


class Generation(GenerationBase):
    model_config = ConfigDict(from_attributes=True)

    uuid: UUID
    create_time: datetime
    update_time: datetime
    status: str

    image_uuids: list[UUID]


class GenerationCreate(GenerationBase):
    uuid: Optional[UUID] = None


class GenerationTask(Generation):
    user_id: str


class GenerationDone(Generation):
    images: Optional[ImagesURLOrData] = None


class Layer(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    uuid: UUID

    name: Optional[str] = None
    x: Optional[float] = None
    y: Optional[float] = None
    width: Optional[float] = None
    height: Optional[float] = None
    rotation: Optional[float] = None

    image_uuid: Optional[UUID] = None
    generations: list[Generation] = []


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
