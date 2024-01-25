import uuid
from typing import Optional
from uuid import UUID

from pydantic import TypeAdapter
from sqlalchemy import and_, create_engine, select
from sqlalchemy.orm import Session, sessionmaker

from bladecreate import schemas
from bladecreate.db.db_schemas import Base, Generation, Project
from bladecreate.logging import Logger
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)

logger.info(f"DB Connecting: {settings.sqlalchemy_url()}")
connect_args = (
    {"check_same_thread": False} if settings.sqlalchemy_url().startswith("sqlite") else {}
)
engine = create_engine(settings.sqlalchemy_url(), connect_args=connect_args)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base.metadata.create_all(bind=engine)


def select_projects(db: Session, user_id: str, uuids: list[UUID]) -> list[schemas.Project]:
    if len(uuids) > 0:
        db_obj = db.scalars(
            select(Project).where(
                and_(
                    Project.user_id == user_id,
                    Project.uuid.in_(uuids),
                )
            )
        ).all()
    else:
        db_obj = db.scalars(select(Project).where(Project.user_id == user_id)).all()
    return TypeAdapter(list[schemas.Project]).validate_python(db_obj)


def create_project(db: Session, user_id: str, body: schemas.ProjectCreate) -> schemas.Project:
    if not body.uuid:
        body.uuid = uuid.uuid4()

    db_obj = Project(
        uuid=body.uuid,
        user_id=user_id,
        name=body.name,
        data=schemas.ProjectData().model_dump(),
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(schemas.Project).validate_python(db_obj)


def update_project(
    db: Session,
    user_id: str,
    project_uuid: UUID,
    req: schemas.ProjectUpdate,
) -> schemas.Project:
    db_obj = db.scalars(
        select(Project).where(
            and_(
                Project.user_id == user_id,
                Project.uuid == project_uuid,
            )
        )
    ).first()
    if db_obj is None:
        return None

    if req.name:
        db_obj.name = req.name
    if req.data:
        db_obj.data = req.data

    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(schemas.Project).validate_python(db_obj)


def get_generations(
    db: Session, user_id: str, generation_uuids: list[str]
) -> list[schemas.Generation]:
    if len(generation_uuids) > 0:
        uuid_objs = [UUID(item) for item in generation_uuids]
        db_obj = db.scalars(
            select(Generation).where(
                and_(
                    Generation.user_id == user_id,
                    Generation.uuid.in_(uuid_objs),
                )
            )
        ).all()
    else:
        db_obj = db.scalars(select(Generation).where(Generation.user_id == user_id)).all()
    return TypeAdapter(list[schemas.Generation]).validate_python(db_obj)


def pop_most_recent_generation_task(
    db: Session,
) -> schemas.GenerationTask:
    # TODO: revisit if locking here is implement correctly for concurrency
    db_obj = db.scalars(
        select(Generation)
        .with_for_update(nowait=True)
        .where(Generation.status == "CREATED")
        .order_by(Generation.create_time.asc())
    ).first()
    if db_obj is None:
        return None

    db_obj.status = "STARTED"
    db.commit()
    db.refresh(db_obj)

    return TypeAdapter(schemas.GenerationTask).validate_python(db_obj)


def create_generation(
    db: Session,
    user_id: str,
    req: schemas.GenerationCreate,
) -> Optional[schemas.Generation]:
    db_obj = Generation(
        uuid=req.uuid,
        user_id=user_id,
        status="CREATED",
        params=req.params.model_dump(),
        image_uuids=[],
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(schemas.Generation).validate_python(db_obj)


def update_generation_succeeded(
    db: Session,
    g_uuid: UUID,
    image_uuids: list[UUID],
) -> schemas.Generation:
    db_obj = db.scalars(select(Generation).where(Generation.uuid == g_uuid)).first()
    if db_obj is None:
        return None

    db_obj.status = "SUCCEEDED"
    db_obj.image_uuids = [item.__str__() for item in image_uuids]

    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(schemas.Generation).validate_python(db_obj)
