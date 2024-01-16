import os
import uuid

import pytest
from fastapi.testclient import TestClient

from bladecreate.data_utils import image_bytes_to_inline_data


@pytest.fixture
def client() -> TestClient:
    from bladecreate.app import app

    # It seems that TestClient.websocket_connect only support synchronous testing.
    # It might hit deadlock inside of the synchronous test function when the application gives
    # control to the asynio event loop.
    # Solution: don't use TestClient and run the client and the fastapi application on two different threads
    return TestClient(app)


@pytest.fixture
def db():
    import bladecreate.db.sqlalchemy as sql

    db = sql.SessionLocal()
    try:
        yield db
    finally:
        db.close()


@pytest.fixture
def test_id():
    return uuid.uuid4()


@pytest.fixture
def user_id() -> str:
    return "test_user"


@pytest.fixture
def project_uuid() -> str:
    return "test_user"


@pytest.fixture
def test_folder_key(test_id):
    return "tests/{test_id}/".format(test_id=test_id)


@pytest.fixture
def local_folder_path() -> str:
    cur_file_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "fixture_files")
    return cur_file_dir


@pytest.fixture
def local_file_bytes(local_folder_path) -> str:
    f = open(os.path.join(local_folder_path, "logo.png"), "rb")
    return f.read()


@pytest.fixture
def local_file_text(local_folder_path) -> str:
    f = open(os.path.join(local_folder_path, "logo.png"), "rb")
    return image_bytes_to_inline_data(f.read())


@pytest.fixture
def local_file_path(local_folder_path) -> str:
    return os.path.join(local_folder_path, "logo.png")
