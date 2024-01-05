import os

from bladecreate.file_osm import FileObjectStorageManager


def test_file_osm(
    test_folder_key,
    local_folder_path,
    local_file_bytes,
    local_file_text,
    local_file_path,
    tmp_path,
):
    osm = FileObjectStorageManager()

    # list empty folder
    file_keys = osm.list_objects(test_folder_key)
    assert len(file_keys) == 0

    # upload files
    osm.upload_object_from_file(local_file_path, os.path.join(test_folder_key, "file1"))
    osm.upload_object_from_bytes(os.path.join(test_folder_key, "file2"), local_file_bytes)
    osm.upload_object_from_text(os.path.join(test_folder_key, "file3"), local_file_text)
    osm.upload_objects_from_folder(local_folder_path, os.path.join(test_folder_key, "folder1"))

    # list files
    file_keys = osm.list_objects(test_folder_key)
    assert len(file_keys) == 5

    # download files
    osm.download_object(list(file_keys)[0], os.path.join(tmp_path, "download_1"))
    assert os.path.isfile(os.path.join(tmp_path, "download_1"))
    osm.download_objects_from_folder(test_folder_key, os.path.join(tmp_path, "download_2/"))
    downloaded_files = os.listdir(os.path.join(tmp_path, "download_2/"))
    assert len(downloaded_files) == 4

    # delete files
    osm.delete_objects_in_folder(os.path.join(test_folder_key, "folder1/"))

    # list files
    file_keys = osm.list_objects(test_folder_key)
    assert len(file_keys) == 3
