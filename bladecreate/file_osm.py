import os
import shutil
from typing import Set

from bladecreate.config import FILE_OBJECT_STORAGE_DIR
from bladecreate.osm import ObjectStorageManager


class FileObjectStorageManager(ObjectStorageManager):
    def key_to_storage_path(self, key):
        return os.path.join(FILE_OBJECT_STORAGE_DIR, key)

    def storage_path_to_key(self, path):
        return os.path.relpath(path, FILE_OBJECT_STORAGE_DIR)

    def _create_dirs_if_not_exists(self, path):
        os.makedirs(os.path.dirname(path), exist_ok=True)

    def list_objects(self, dir_key) -> Set[str]:
        if not dir_key.endswith("/"):
            raise Exception("Wrong directory key")

        res = set()
        for dirpath, dirs, filenames in os.walk(
            self.key_to_storage_path(dir_key)
        ):
            for dir in dirs:
                parent_rel_path = self.storage_path_to_key(dirpath)
                key = os.path.join(parent_rel_path, dir) + "/"
                if len(os.listdir(self.key_to_storage_path(key))) == 0:
                    continue
                res.add(key)
            for filename in filenames:
                parent_rel_path = self.storage_path_to_key(dirpath)
                key = os.path.join(parent_rel_path, filename)
                res.add(key)
        return res

    def download_object(self, key, local_path, if_exist_ignore=True) -> None:
        src_path = self.key_to_storage_path(key)

        if not os.path.exists(src_path):
            raise Exception("key does not exist")

        if not os.path.isfile(src_path):
            self._create_dirs_if_not_exists(local_path)
            return

        self._create_dirs_if_not_exists(local_path)
        if os.path.exists(local_path):
            if if_exist_ignore:
                print(
                    "Skipping downloading",
                    key,
                    "to",
                    local_path,
                    "because it already exists",
                )
                return
            else:
                os.remove(local_path)

        shutil.copy(src_path, local_path)

    def delete_objects_in_folder(self, key):
        if not key.endswith("/"):
            raise Exception("Key is not a folder.")

        objs = self.list_objects(key)
        print(f"Deleting {len(objs)} files in {key}")
        if len(objs) == 0:
            return

        for k in objs:
            dst_path = self.key_to_storage_path(k)

            if not os.path.exists(dst_path):
                raise Exception("key does not exist", k)

            if os.path.isfile(dst_path):
                os.remove(dst_path)
            else:
                shutil.rmtree(dst_path)

    def upload_object_from_bytes(self, file_key, bytes):
        print(f"Uploading bytes to {file_key}")
        dst_path = self.key_to_storage_path(file_key)
        self._create_dirs_if_not_exists(dst_path)
        with open(dst_path, "xb") as f:
            f.write(bytes)

    def upload_object_from_text(self, file_key, text: str):
        print(f"Uploading text to {file_key}")
        dst_path = self.key_to_storage_path(file_key)
        self._create_dirs_if_not_exists(dst_path)
        with open(dst_path, "x") as f:
            f.write(text)

    def upload_object_from_file(self, local_path, key):
        dst_path = self.key_to_storage_path(key)
        self._create_dirs_if_not_exists(dst_path)
        if os.path.exists(dst_path):
            raise Exception("key exists")
        shutil.copy(local_path, dst_path)

    def generate_download_url(self, key):
        with open(self.key_to_storage_path(key), "r") as f:
            return f.read()
