from urllib import request

import pytest
from fastapi.testclient import TestClient

from bladecreate.app import app
from bladecreate.tests.utils import compare_layer_with_input


@pytest.fixture
def client() -> TestClient:
    return TestClient(app)


def test_health_check(client: TestClient):
    resp = client.get("/health")
    assert resp.status_code == 200


def test_projects_metadata(
    client: TestClient, user_id: str, local_file_text: str
):
    # get projects metadata
    resp = client.get(f"/api/projects/{user_id}")
    assert resp.status_code == 200
    projects = resp.json()

    # create project
    new_project = {"name": "test_projects_metadata new"}
    resp = client.post(f"/api/projects/{user_id}", json=new_project)
    assert resp.status_code == 200
    project_resp = resp.json()
    resp = client.get(f"/api/projects/{user_id}")
    assert resp.status_code == 200
    new_projects = resp.json()
    assert project_resp in new_projects
    assert len(new_projects) == len(projects) + 1

    # get project metadata
    resp = client.get(f"/api/projects/{user_id}?uuids={project_resp['uuid']}")
    assert resp.status_code == 200
    new_project_get = resp.json()[0]
    assert new_project_get["name"] == new_project["name"]

    # update project metadata
    updated_project = {
        "name": "test_projects_metadata updated",
    }
    resp = client.put(
        f"/api/projects/{user_id}/{project_resp['uuid']}",
        json=updated_project,
    )
    assert resp.status_code == 200

    # get project metadata
    resp = client.get(f"/api/projects/{user_id}?uuids={project_resp['uuid']}")
    assert resp.status_code == 200
    new_project_get = resp.json()[0]
    assert new_project_get["name"] == updated_project["name"]


def test_project_layers(
    client: TestClient, user_id: str, local_file_text: str
):
    # create project
    new_project = {"name": "test_project_layers new"}
    resp = client.post(f"/api/projects/{user_id}", json=new_project)
    assert resp.status_code == 200
    project_get = resp.json()
    project_uuid = project_get["uuid"]

    # get project
    resp = client.get(f"/api/projects/{user_id}/{project_uuid}")
    assert resp.status_code == 200
    project_full_get = resp.json()
    assert project_full_get["name"] == new_project["name"]
    assert project_full_get["layers_order"] == []
    assert project_full_get["layers"] == {}

    # create project layer 1
    layer1_input = {
        "name": "new layer 1",
        "x": 1,
        "rotation": 2,
    }
    layer1_image_data = local_file_text
    resp = client.post(
        f"/api/projects/{user_id}/{project_uuid}/layers",
        json={**layer1_input, "image_data": layer1_image_data},
    )
    assert resp.status_code == 200
    layer1_uuid = resp.json()["uuid"]

    # create project layer 2
    layer2_input = {
        "name": "new layer 2",
        "y": 3,
        "height": 2,
    }
    layer2_image_data = local_file_text
    resp = client.post(
        f"/api/projects/{user_id}/{project_uuid}/layers",
        json={**layer2_input, "image_data": layer2_image_data},
    )
    assert resp.status_code == 200
    layer2_uuid = resp.json()["uuid"]

    # validate project layers
    resp = client.get(f"/api/projects/{user_id}/{project_uuid}")
    assert resp.status_code == 200
    project_layers = resp.json()
    assert project_layers["layers_order"] == [
        layer2_uuid,
        layer1_uuid,
    ]
    compare_layer_with_input(
        project_layers["layers"][layer1_uuid], layer1_input
    )
    compare_layer_with_input(
        project_layers["layers"][layer2_uuid], layer2_input
    )

    # download from layer url and validate image_data
    if project_layers["layers"][layer1_uuid]["image_url"]:
        resp = request.urlopen(
            project_layers["layers"][layer1_uuid]["image_url"]
        )
        data = resp.read().decode()
        assert data == local_file_text
        resp = request.urlopen(
            project_layers["layers"][layer2_uuid]["image_url"]
        )
        data = resp.read().decode()
        assert data == local_file_text
    else:
        assert (
            project_layers["layers"][layer1_uuid]["image_data"]
            == project_layers["layers"][layer2_uuid]["image_data"]
        )

    # update project layers order
    resp = client.put(
        f"/api/projects/{user_id}/{project_uuid}",
        json={"layers_order": [layer1_uuid, layer2_uuid]},
    )
    assert resp.status_code == 200

    # validate project layers
    resp = client.get(f"/api/projects/{user_id}/{project_uuid}")
    assert resp.status_code == 200
    project_layers = resp.json()
    assert project_layers["layers_order"] == [
        layer1_uuid,
        layer2_uuid,
    ]
    compare_layer_with_input(
        project_layers["layers"][layer1_uuid], layer1_input
    )
    compare_layer_with_input(
        project_layers["layers"][layer2_uuid], layer2_input
    )

    # update project layer
    layer1_updated_input = {
        "name": "layer 1 is updated",
        "x": 10,
        "rotation": 20,
    }
    resp = client.put(
        f"/api/projects/{user_id}/{project_uuid}/layers/{layer1_uuid}",
        json=layer1_updated_input,
    )
    assert resp.status_code == 200

    # validate project layers
    resp = client.get(f"/api/projects/{user_id}/{project_uuid}")
    assert resp.status_code == 200
    project_layers = resp.json()
    assert project_layers["layers_order"] == [
        layer1_uuid,
        layer2_uuid,
    ]
    compare_layer_with_input(
        project_layers["layers"][layer1_uuid], layer1_updated_input
    )
    compare_layer_with_input(
        project_layers["layers"][layer2_uuid], layer2_input
    )

    # delete layer
    resp = client.delete(
        f"/api/projects/{user_id}/{project_uuid}/layers/{layer2_uuid}",
    )
    assert resp.status_code == 200

    # validate project layers
    resp = client.get(f"/api/projects/{user_id}/{project_uuid}")
    assert resp.status_code == 200
    project_layers = resp.json()
    assert project_layers["layers_order"] == [layer1_uuid]
    compare_layer_with_input(
        project_layers["layers"][layer1_uuid], layer1_updated_input
    )
