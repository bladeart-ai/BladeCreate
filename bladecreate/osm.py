import os
from concurrent import futures
from concurrent.futures import ThreadPoolExecutor
from typing import Dict, Set


class ObjectStorageManager:
    def key_to_storage_path(self, key):
        pass

    def storage_path_to_key(self, path):
        pass

    def _create_dirs_if_not_exists(self, path):
        pass

    def list_objects(self, dir_key) -> Set[str]:
        pass

    def download_object(self, key, local_path, if_exist_ignore=True) -> None:
        pass

    def download_objects(
        self, objs: Set[str], key_prefix: str, local_dir_path: str
    ) -> Dict[str, str]:
        res = {}
        with ThreadPoolExecutor(max_workers=4) as executor:
            future_to_key = {}
            for k in objs:
                if not k.startswith(key_prefix):
                    continue

                relative_path = k[len(key_prefix) :]
                local_full_path = os.path.join(local_dir_path, relative_path)

                if k.endswith("/"):
                    self._create_dirs_if_not_exists(local_full_path)
                    continue

                else:
                    res[k] = local_full_path

                    future_to_key[executor.submit(self.download_object, k, local_full_path)] = k

            for future in futures.as_completed(future_to_key):
                exception = future.exception()

                if exception:
                    raise exception
        return res

    def download_objects_from_folder(
        self,
        key: str,
        local_dir_path: str,
    ) -> Dict[str, str]:
        if not key.endswith("/"):
            raise Exception("Key is not a folder.")

        objs = self.list_objects(key)
        print(f"Downloading {len(objs)} files from {key} to {local_dir_path}")
        return self.download_objects(objs, key, local_dir_path)

    def delete_objects_in_folder(self, key):
        pass

    def upload_object_from_bytes(self, file_key, bytes):
        pass

    def upload_object_from_text(self, file_key, text: str):
        pass

    def upload_objects_from_text(self, file_key_to_text):
        print(f"Uploading text of {len(file_key_to_text)} files")

        res = {}
        with ThreadPoolExecutor(max_workers=8) as executor:
            future_to_key = {}
            for key in file_key_to_text:
                future_to_key[
                    executor.submit(
                        self.upload_object_from_text,
                        key,
                        file_key_to_text[key],
                    )
                ] = key

            for future in futures.as_completed(future_to_key):
                exception = future.exception()

                if exception:
                    raise exception
        return res

    def upload_object_from_file(self, local_path, key):
        pass

    def upload_objects_from_folder(self, local_dir: str, key_prefix: str):
        if not os.path.isdir(local_dir):
            raise Exception("Key is not a folder.")

        filenames = [f for f in os.listdir(local_dir) if os.path.isfile(os.path.join(local_dir, f))]

        print(f"Uploading {len(filenames)} files from {local_dir} to {key_prefix}")

        res = {}
        with ThreadPoolExecutor(max_workers=8) as executor:
            future_to_key = {}
            for filename in filenames:
                local_path = os.path.join(local_dir, filename)
                key = os.path.join(key_prefix, filename)
                future_to_key[executor.submit(self.upload_object_from_file, local_path, key)] = key

            for future in futures.as_completed(future_to_key):
                exception = future.exception()

                if exception:
                    raise exception
        return res

    def generate_download_url(self, key):
        pass
