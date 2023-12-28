import datetime
import uuid
from typing import Optional
from uuid import UUID

from sqlalchemy import JSON, Boolean, Column, ForeignKey, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import Mapped, mapped_column, relationship
from typing_extensions import Annotated

Base = declarative_base()

create_time = Annotated[
    datetime.datetime,
    mapped_column(nullable=False, default=datetime.datetime.utcnow),
]
update_time = Annotated[
    datetime.datetime,
    mapped_column(
        nullable=False,
        default=datetime.datetime.utcnow,
        onupdate=datetime.datetime.utcnow,
    ),
]
empty_uuid = UUID(int=0)
pickable_dict = Annotated[dict[str, dict], mapped_column(JSON)]
pickable_uuid_list = Annotated[list[UUID], mapped_column(JSON)]


class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String(64))
    is_active = Column(Boolean, default=True)


class Project(Base):
    __tablename__ = "projects"

    uuid: Mapped[UUID] = mapped_column(
        primary_key=True, index=True, default=uuid.uuid4
    )
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"))

    name: Mapped[str] = mapped_column(String(128))

    create_time: Mapped[create_time]
    update_time: Mapped[update_time]
    layers_order: Mapped[pickable_uuid_list]


class Layer(Base):
    __tablename__ = "layers"

    uuid: Mapped[UUID] = mapped_column(
        primary_key=True, index=True, default=uuid.uuid4
    )
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"), index=True)
    project_uuid: Mapped[UUID] = mapped_column(
        ForeignKey("projects.uuid"), index=True
    )

    name: Mapped[str] = mapped_column(String(128))
    x: Mapped[Optional[float]]
    y: Mapped[Optional[float]]
    width: Mapped[Optional[float]]
    height: Mapped[Optional[float]]
    rotation: Mapped[Optional[float]]
    image_uuid: Mapped[UUID]

    generations: Mapped[list["Generation"]] = relationship(
        back_populates="layer",
        order_by="desc(Generation.create_time)",
        primaryjoin="Layer.uuid == Generation.layer_uuid",
    )


class Generation(Base):
    __tablename__ = "generations"

    uuid: Mapped[UUID] = mapped_column(
        primary_key=True, index=True, default=uuid.uuid4
    )
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"), index=True)
    project_uuid: Mapped[UUID] = mapped_column(
        ForeignKey("projects.uuid"), index=True
    )
    layer_uuid: Mapped[UUID] = mapped_column(ForeignKey("layers.uuid"))
    layer: Mapped["Layer"] = relationship(back_populates="generations")

    create_time: Mapped[create_time]
    update_time: Mapped[update_time]
    status: Mapped[str] = mapped_column(String(128))

    params: Mapped[pickable_dict]
    image_uuids: Mapped[pickable_uuid_list]
