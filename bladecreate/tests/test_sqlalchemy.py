import uuid

import pytest  # noqa: F401

import bladecreate.db.sqlalchemy as sql
from bladecreate import schemas


def test_generation(db, user_id):
    params1 = schemas.GenerationParams(
        prompt="this is a prompt 1",
        negative_prompt="this is a negative prompt 1",
    )
    params2 = schemas.GenerationParams(
        prompt="this is a prompt 2",
        negative_prompt="this is a negative prompt 2",
    )
    image_uuids = [uuid.uuid4(), uuid.uuid4()]

    while True:
        top = sql.pop_most_recent_generation_task(db)
        if top is None:
            break
        top_updated = sql.update_generation_succeeded(db, top.uuid, image_uuids)
        assert top_updated is not None

    g1 = sql.create_generation(db, user_id, schemas.GenerationCreate(params=params1))
    g2 = sql.create_generation(db, user_id, schemas.GenerationCreate(params=params2))
    g_get = sql.get_generation(db, user_id, g1.uuid)
    assert g1 == g_get
    g_get = sql.get_generation(db, user_id, g2.uuid)
    assert g2 == g_get

    g1_task = sql.pop_most_recent_generation_task(db)
    g_get = sql.get_generation(db, user_id, g1_task.uuid)
    assert g1.create_time == g_get.create_time
    assert g1.update_time != g_get.update_time
    assert g_get.status == "STARTED"

    g1_task_updated = sql.update_generation_succeeded(db, g1_task.uuid, image_uuids)
    g_get = sql.get_generation(db, user_id, g1_task_updated.uuid)
    assert g1_task_updated == g_get
    assert g_get.status == "SUCCEEDED"
