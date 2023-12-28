import logging
import uuid
from typing import Optional, Tuple
from uuid import UUID

from pydantic import TypeAdapter
from sqlalchemy import and_, create_engine, delete, select
from sqlalchemy.orm import Session, selectinload, sessionmaker

from bladecreate import schemas
from bladecreate.config import SQLALCHEMY_DATABASE_URL
from bladecreate.db_schemas import Base, Generation, Layer, Project
from bladecreate.logging_setup import logging_setup

logging_setup()
logger = logging.getLogger(__name__)
logger.info("logger is configured!")

connect_args = (
    {"check_same_thread": False}
    if SQLALCHEMY_DATABASE_URL.startswith("sqlite")
    else {}
)
engine = create_engine(SQLALCHEMY_DATABASE_URL, connect_args=connect_args)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base.metadata.create_all(bind=engine)


def select_projects_metadata(
    db: Session, user_id: str, uuids: list[str]
) -> list[schemas.ProjectMetadata]:
    if len(uuids) > 0:
        uuid_objs = [UUID(item) for item in uuids]
        db_obj = db.scalars(
            select(Project).where(
                and_(
                    Project.user_id == user_id,
                    Project.uuid.in_(uuid_objs),
                )
            )
        ).all()
    else:
        db_obj = db.scalars(
            select(Project).where(Project.user_id == user_id)
        ).all()
    return TypeAdapter(list[schemas.ProjectMetadata]).validate_python(db_obj)


def create_project(
    db: Session, user_id: str, body: schemas.ProjectCreate
) -> schemas.ProjectMetadata:
    if not body.uuid:
        body.uuid = uuid.uuid4()

    db_obj = Project(
        uuid=body.uuid,
        user_id=user_id,
        name=body.name,
        layers_order=[],
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(schemas.ProjectMetadata).validate_python(db_obj)


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
    if req.layers_order:
        db_obj.layers_order = [item.__str__() for item in req.layers_order]

    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(schemas.Project).validate_python(db_obj)


def select_project(
    db: Session, user_id: str, project_uuid: UUID
) -> Tuple[Optional[schemas.Project], Optional[list[schemas.Layer]]]:
    db_obj = db.scalars(
        select(Project).where(
            and_(
                Project.user_id == user_id,
                Project.uuid == project_uuid,
            )
        )
    ).first()
    if db_obj is None:
        return None, None

    layers = db.scalars(
        select(Layer)
        .options(selectinload(Layer.generations))
        .where(
            and_(
                Layer.user_id == user_id,
                Layer.project_uuid == project_uuid,
            )
        )
    ).all()

    return TypeAdapter(schemas.Project).validate_python(db_obj), TypeAdapter(
        list[schemas.Layer]
    ).validate_python(layers)


def create_project_layer(
    db: Session,
    user_id: str,
    project_uuid: UUID,
    body: schemas.LayerCreate,
) -> Optional[schemas.Layer]:
    if not body.uuid:
        body.uuid = uuid.uuid4()

    db_proj = db.scalars(
        select(Project).where(
            and_(
                Project.user_id == user_id,
                Project.uuid == project_uuid,
            )
        )
    ).first()
    if db_proj is None:
        return None

    db_proj.layers_order = [
        body.uuid.__str__(),
        *db_proj.layers_order,
    ]
    db_layer = Layer(
        uuid=body.uuid,
        user_id=user_id,
        project_uuid=project_uuid,
        name=body.name,
        x=body.x,
        y=body.y,
        width=body.width,
        height=body.height,
        rotation=body.rotation,
        image_uuid=body.uuid,
    )
    db.add(db_layer)

    db.commit()
    db.refresh(db_proj)
    db.refresh(db_layer)
    return TypeAdapter(schemas.Layer).validate_python(db_layer)


def update_project_layer(
    db: Session,
    user_id: str,
    project_uuid: UUID,
    layer_uuid: UUID,
    body: schemas.LayerUpdate,
) -> schemas.Layer:
    db_obj = db.scalars(
        select(Layer).where(
            and_(
                Layer.user_id == user_id,
                Layer.project_uuid == project_uuid,
                Layer.uuid == layer_uuid,
            )
        )
    ).first()
    if db_obj is None:
        return None

    if body.name:
        db_obj.name = body.name
    if body.x:
        db_obj.x = body.x
    if body.y:
        db_obj.y = body.y
    if body.width:
        db_obj.width = body.width
    if body.height:
        db_obj.height = body.height
    if body.rotation:
        db_obj.rotation = body.rotation
    if body.image_uuid:
        db_obj.image_uuid = body.image_uuid

    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(schemas.Layer).validate_python(db_obj)


def delete_layer(
    db: Session, user_id: str, project_uuid: UUID, layer_uuid: UUID
) -> UUID:
    db_proj = db.scalars(
        select(Project).where(
            and_(
                Project.user_id == user_id,
                Project.uuid == project_uuid,
            )
        )
    ).first()
    if db_proj is None:
        return None

    if str(layer_uuid) not in db_proj.layers_order:
        return None
    new_layers_order = db_proj.layers_order.copy()
    new_layers_order.remove(str(layer_uuid))
    db_proj.layers_order = new_layers_order
    db.commit()

    db_obj = db.execute(
        delete(Layer)
        .where(
            and_(
                Layer.user_id == user_id,
                Layer.project_uuid == project_uuid,
                Layer.uuid == layer_uuid,
            )
        )
        .returning(Layer.uuid)
    ).first()
    if db_obj is None:
        return None

    return db_obj[0]


def get_generation(
    db: Session,
    user_id: str,
    project_uuid: UUID,
    generation_uuid: UUID,
) -> schemas.Generation:
    db_obj = db.scalars(
        select(Generation).where(
            and_(
                Generation.user_id == user_id,
                Generation.project_uuid == project_uuid,
                Generation.uuid == generation_uuid,
            )
        )
    ).first()
    if db_obj is None:
        return None

    return TypeAdapter(list[schemas.Generation]).validate_python(db_obj)


def create_generation(
    db: Session,
    user_id: str,
    project_uuid: UUID,
    req: schemas.GenerationCreate,
) -> Optional[schemas.Generation]:
    db_obj = Generation(
        uuid=req.uuid,
        user_id=user_id,
        project_uuid=project_uuid,
        layer_uuid=req.output_layer_uuid,
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
    g: schemas.Generation,
    image_uuids: list[UUID],
) -> schemas.Generation:
    db_obj = db.scalars(
        select(Generation).where(
            and_(
                Generation.uuid == g.uuid,
            )
        )
    ).first()
    if db_obj is None:
        return None

    db_obj.status = "SUCCEEDED"
    db_obj.image_uuids = [item.__str__() for item in image_uuids]

    db.commit()
    db.refresh(db_obj)
    return TypeAdapter(schemas.Generation).validate_python(db_obj)
