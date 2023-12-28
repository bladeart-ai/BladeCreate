from datetime import datetime
from enum import Enum
from typing import Optional
from uuid import UUID

from pydantic import BaseModel, ConfigDict


class ProjectMetadataBase(BaseModel):
    pass


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


class LayerBase(BaseModel):
    name: Optional[str] = None
    x: Optional[float] = None
    y: Optional[float] = None
    width: Optional[float] = None
    height: Optional[float] = None
    rotation: Optional[float] = None


class GenerationBase(BaseModel):
    params: GenerationParams


class ProjectMetadata(ProjectMetadataBase):
    model_config = ConfigDict(from_attributes=True)

    uuid: UUID
    name: str
    create_time: datetime
    update_time: datetime


class Generation(GenerationBase):
    model_config = ConfigDict(from_attributes=True)

    uuid: UUID
    create_time: datetime
    update_time: datetime
    status: str

    image_uuids: list[UUID]


class Layer(LayerBase):
    model_config = ConfigDict(from_attributes=True)

    uuid: UUID

    image_uuid: Optional[UUID] = None

    generations: Optional[list[Generation]] = None


class ImagesURLOrData(BaseModel):
    urls: dict[UUID, str]
    data: dict[UUID, str]


class Project(ProjectMetadata):
    model_config = ConfigDict(from_attributes=True)

    layers_order: list[UUID] = []
    layers: dict[UUID, Layer] = {}

    images: Optional[ImagesURLOrData] = None


class ProjectCreate(ProjectMetadataBase):
    uuid: Optional[UUID] = None
    name: Optional[str] = ""


class ProjectUpdate(BaseModel):
    name: Optional[str] = ""
    layers_order: Optional[list[UUID]] = None


class LayerCreate(LayerBase):
    uuid: Optional[UUID] = None
    image_data: Optional[str] = None


class LayerUpdate(LayerBase):
    image_uuid: Optional[UUID] = None


class GenerationCreate(GenerationBase):
    uuid: Optional[UUID] = None
    output_layer_uuid: Optional[UUID] = None


class GenerationDone(Generation):
    images: Optional[ImagesURLOrData] = None
