import datetime
import uuid
from uuid import UUID

from sqlalchemy import JSON, Boolean, Column, ForeignKey, Integer, String
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import Mapped, mapped_column
from typing_extensions import Annotated

Base = declarative_base()

create_time = Annotated[
    datetime.datetime,
    mapped_column(nullable=False, default=datetime.datetime.utcnow),
]
auto_update_time = Annotated[
    datetime.datetime,
    mapped_column(
        nullable=False,
        default=datetime.datetime.utcnow,
        onupdate=datetime.datetime.utcnow,
    ),
]
manual_update_time = Annotated[
    datetime.datetime,
    mapped_column(
        nullable=False,
        default=datetime.datetime.utcnow,
    ),
]
pickable_dict = Annotated[dict[str, dict], mapped_column(JSON)]
pickable_uuid_list = Annotated[list[UUID], mapped_column(JSON)]


class UserDB(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String(64))
    is_active = Column(Boolean, default=True)


class ProjectDB(Base):
    __tablename__ = "projects"

    uuid: Mapped[UUID] = mapped_column(primary_key=True, index=True, default=uuid.uuid4)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"))

    name: Mapped[str] = mapped_column(String(128))

    create_time: Mapped[create_time]
    update_time: Mapped[auto_update_time]
    data: Mapped[pickable_dict]


class GenerationDB(Base):
    __tablename__ = "generations"

    uuid: Mapped[UUID] = mapped_column(primary_key=True, index=True, default=uuid.uuid4)
    user_id: Mapped[str] = mapped_column(ForeignKey("users.id"), index=True)

    create_time: Mapped[create_time]
    update_time: Mapped[manual_update_time]
    status: Mapped[str] = mapped_column(String(128), index=True)

    params: Mapped[pickable_dict]
    image_uuids: Mapped[pickable_uuid_list]


class WorkerDB(Base):
    __tablename__ = "workers"

    uuid: Mapped[UUID] = mapped_column(primary_key=True, index=True, default=uuid.uuid4)

    create_time: Mapped[create_time]
    update_time: Mapped[auto_update_time]
    heartbeat_time: Mapped[manual_update_time]
    status: Mapped[str] = mapped_column(String(128), index=True)
