# coding=utf-8
import pytest
from fastapi.testclient import TestClient

from bladecreate.app import app
from bladecreate.tests.utils import compare_layer_with_input


@pytest.fixture
def client() -> TestClient:
    return TestClient(app)


def test_generation(client: TestClient, user_id: str):
    # create project
    new_project = {"name": "new test project for generation"}
    resp = client.post(f"/api/projects/{user_id}", json=new_project)
    assert resp.status_code == 200
    project_uuid = resp.json()

    # generate without specified layer
    new_generation_input = {
        "params": {
            "prompt": "haha",
            "negative_prompt": "hehe",
            "output_number": 3,
            "h_w_ratio": "1:1",
            "seed": 123456,
        }
    }
    resp = client.post(
        f"/api/projects/{user_id}/{project_uuid}/generate",
        json=new_generation_input,
    )
    assert resp.status_code == 200
    generate_resp = resp.json()
    new_layer = generate_resp["new_layer"]
    assert generate_resp["params"] == new_generation_input["params"]

    # validate layer is associated with generation
    resp = client.get(f"/api/projects/{user_id}/{project_uuid}")
    assert resp.status_code == 200
    project_layers = resp.json()
    compare_layer_with_input(project_layers["layers"][new_layer["uuid"]], new_layer)

    # generate with specified layer
    new_generation_input = {
        "params": {
            "prompt": "haha2",
            "negative_prompt": "hehe2",
            "output_number": 30,
            "h_w_ratio": "16:9",
            "seed": 12345678,
        },
        "output_layer_uuid": new_layer["uuid"],
    }
    resp = client.post(
        f"/api/projects/{user_id}/{project_uuid}/generate",
        json=new_generation_input,
    )
    assert resp.status_code == 200
    generate_resp = resp.json()
    assert generate_resp["new_layer"] is None
    assert generate_resp["params"] == new_generation_input["generation_params"]

    # validate generation
    resp = client.get(f"api/projects/{user_id}/{project_uuid}/generations/{generate_resp['uuid']}")
    assert resp.status_code == 200
    assert generate_resp == resp.json()

    # validate layer is associated with generation
    resp = client.get(f"/api/projects/{user_id}/{project_uuid}")
    assert resp.status_code == 200
    project_layers = resp.json()
    new_layer["generation_uuid"] = generate_resp["uuid"]
    compare_layer_with_input(project_layers["layers"][new_layer["uuid"]], new_layer)
