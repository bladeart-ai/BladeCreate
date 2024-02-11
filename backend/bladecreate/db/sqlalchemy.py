import datetime
import uuid
from datetime import timedelta
from typing import Optional
from uuid import UUID

from pydantic import TypeAdapter
from sqlalchemy import and_, create_engine, or_, select
from sqlalchemy.orm import Session, sessionmaker

from bladecreate.db.db_schemas import Base, GenerationDB, ProjectDB, WorkerDB
from bladecreate.logging import Logger
from bladecreate.schemas import (
    ClusterSnapshot,
    Generation,
    GenerationCreate,
    GenerationTask,
    GenerationTaskUpdate,
    Project,
    ProjectCreate,
    ProjectData,
    ProjectUpdate,
    Worker,
)
from bladecreate.settings import settings

logger = Logger.get_logger(__name__)

logger.info(f"DB Connecting: {settings.sqlalchemy_url()}")
connect_args = (
    {"check_same_thread": False} if settings.sqlalchemy_url().startswith("sqlite") else {}
)
engine = create_engine(settings.sqlalchemy_url(), connect_args=connect_args)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base.metadata.create_all(bind=engine)


def select_projects(db: Session, user_id: str, uuids: list[UUID]) -> list[Project]:
    if len(uuids) > 0:
        db_obj = db.scalars(
            select(ProjectDB).where(
                and_(
                    ProjectDB.user_id == user_id,
                    ProjectDB.uuid.in_(uuids),
                )
            )
        ).all()
    else:
        db_obj = db.scalars(select(ProjectDB).where(ProjectDB.user_id == user_id)).all()
    return TypeAdapter(list[Project]).validate_python(db_obj)


def create_project(db: Session, user_id: str, body: ProjectCreate) -> Project:
    if not body.uuid:
        body.uuid = uuid.uuid4()

    db_obj = ProjectDB(
        uuid=body.uuid,
        user_id=user_id,
        name=body.name,
        data=TypeAdapter(ProjectData).validate_python(body.data).model_dump(),
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(Project).validate_python(db_obj)


def update_project(
    db: Session,
    user_id: str,
    project_uuid: UUID,
    req: ProjectUpdate,
) -> Project:
    db_obj = db.scalars(
        select(ProjectDB).where(
            and_(
                ProjectDB.user_id == user_id,
                ProjectDB.uuid == project_uuid,
            )
        )
    ).first()
    if db_obj is None:
        return None

    if req.name is not None:
        db_obj.name = req.name
    if req.data is not None:
        db_obj.data = req.data

    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(Project).validate_python(db_obj)


def delete_project(
    db: Session,
    user_id: str,
    project_uuid: UUID,
) -> Project:
    db_obj = db.scalars(
        select(ProjectDB).where(
            and_(
                ProjectDB.user_id == user_id,
                ProjectDB.uuid == project_uuid,
            )
        )
    ).first()
    if db_obj is None:
        return None

    db.delete(db_obj)
    db.commit()
    return TypeAdapter(Project).validate_python(db_obj)


def get_generations(
    db: Session, user_id: str, generation_uuids: list[UUID], active_only: bool = False
) -> list[Generation]:
    statement = select(GenerationDB)

    if len(user_id) > 0:
        statement = statement.where(GenerationDB.user_id == user_id)

    if len(generation_uuids) > 0:
        statement = statement.where(GenerationDB.uuid.in_(generation_uuids))

    if active_only:
        statement = statement.where(GenerationDB.status.in_(["CREATED", "STARTED"]))

    db_obj = db.scalars(statement).all()
    if db_obj is None:
        return []
    return TypeAdapter(list[Generation]).validate_python(db_obj)


def pop_most_recent_generation_task(
    db: Session,
) -> GenerationTask:
    since = datetime.datetime.utcnow() - timedelta(minutes=1)
    # TODO: revisit if locking here is implement correctly for concurrency
    db_obj = db.scalars(
        select(GenerationDB)
        .with_for_update(nowait=True)
        .where(or_(GenerationDB.status == "CREATED"))
        .order_by(GenerationDB.create_time.asc())
    ).first()
    if db_obj is None:
        return None

    db_obj.status = "STARTED"
    db_obj.update_time = datetime.datetime.utcnow()
    db.commit()
    db.refresh(db_obj)

    return TypeAdapter(GenerationTask).validate_python(db_obj)


def create_generation(
    db: Session,
    user_id: str,
    req: GenerationCreate,
) -> Optional[GenerationDB]:
    db_obj = GenerationDB(
        uuid=req.uuid,
        user_id=user_id,
        status="CREATED",
        params=req.params.model_dump(),
        image_uuids=[],
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(Generation).validate_python(db_obj)


def update_generation(
    db: Session,
    g: GenerationTaskUpdate,
) -> Generation:
    db_obj = db.scalars(select(GenerationDB).where(GenerationDB.uuid == g.uuid)).first()
    if db_obj is None:
        return None

    db_obj.status = g.status
    db_obj.update_time = datetime.datetime.utcnow()
    db_obj.image_uuids = [item.__str__() for item in g.image_uuids]

    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(Generation).validate_python(db_obj)


def upsert_worker(db: Session, worker_uuid: UUID, worker_status: str) -> Worker:
    db_obj = db.scalars(select(WorkerDB).where(WorkerDB.uuid == worker_uuid)).first()
    if db_obj is None:
        db_obj = WorkerDB(
            uuid=worker_uuid, status=worker_status, heartbeat_time=datetime.datetime.utcnow()
        )
        db.add(db_obj)
    else:
        db_obj.status = worker_status
        db_obj.heartbeat_time = datetime.datetime.utcnow()

    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(Worker).validate_python(db_obj)


def get_cluster_snapshot(db: Session) -> ClusterSnapshot:
    since = datetime.datetime.utcnow() - timedelta(minutes=1)
    db_obj = db.scalars(
        select(WorkerDB).where(WorkerDB.status != "exiting").where(WorkerDB.heartbeat_time > since)
    ).all()
    if db_obj is None:
        workers = []
    else:
        workers = TypeAdapter(list[Worker]).validate_python(db_obj)
    logger.info(workers)
    return ClusterSnapshot(workers=workers, active_jobs=get_generations(db, "", [], True))
