import os
import uuid

import boto3
import pytest

from bladecreate.data_utils import image_bytes_to_inline_data


@pytest.fixture(autouse=True)
def setup_s3():
    boto3.setup_default_session(profile_name="shiyuan")


@pytest.fixture()
def test_id():
    return uuid.uuid4()


@pytest.fixture
def user_id() -> str:
    return "test_user"


@pytest.fixture()
def test_folder_key(test_id):
    return "tests/{test_id}/".format(test_id=test_id)


@pytest.fixture
def local_folder_path() -> str:
    cur_file_dir = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "fixture_files"
    )
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
