from dynaconf import Dynaconf

settings = Dynaconf(environments=True)

# Database
SQLITE_DATABASE = "sqlite"
POSTGRES_DATABASE = "postgres"
DATABASE = settings["database"]
if DATABASE == SQLITE_DATABASE:
    SQLALCHEMY_DATABASE_URL = f"sqlite:///{settings[SQLITE_DATABASE]['path']}"
elif DATABASE == POSTGRES_DATABASE:
    postgres = settings[POSTGRES_DATABASE]
    SQLALCHEMY_DATABASE_URL = f"postgresql://{postgres['user']}:{postgres['password']}@{postgres['host']}/{postgres['database']}"
else:
    raise Exception(f"Unknown database: {settings['database']}")

# Object Storage
FILE_OBJECT_STORAGE = "file_storage"
S3_OBJECT_STORAGE = "s3"
OBJECT_STORAGE = settings["object_storage"]
if OBJECT_STORAGE == FILE_OBJECT_STORAGE:
    FILE_OBJECT_STORAGE_DIR = settings[FILE_OBJECT_STORAGE]["base_path"]
elif OBJECT_STORAGE == S3_OBJECT_STORAGE:
    S3_BUCKET = settings[S3_OBJECT_STORAGE]["bucket"]
else:
    raise Exception(f"Unknown object storage: {settings['object_storage']}")

# Storage Paths
DATASET_PATH_FORMAT = "datasets/user-{user_id}/default/"
SAMPLE_SET_PATH_FORMAT = "sample_sets/user-{user_id}/{task_id}/"
PRETRAIN_MODEL_PATH_FORMAT = "models/pretrain/{pretrain_model_id}"
OUTPUT_MODEL_PATH_FORMAT = "models/user-{user_id}/{task_id}/"
IMAGE_PATH_FORMAT = "images/{user_id}/{project_uuid}/{image_uuid}"

# GPU platform
CUDA = "cuda"
MAC = "mac"
if settings["gpu_platform"] in [CUDA, MAC]:
    GPU_PLATFORM = settings["gpu_platform"]
else:
    raise Exception(f"Unknown gpu platform: {settings['gpu_platform']}")

# APIs
CRUD = "crud"
GENERATE = "generate"
APIS = settings["apis"]
