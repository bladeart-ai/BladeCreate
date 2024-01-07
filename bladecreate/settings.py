from enum import Enum
from typing import Optional, Union

from pydantic import BaseModel, Field, FilePath, NewPath
from pydantic_settings import BaseSettings, SettingsConfigDict


class EnvEnum(str, Enum):
    dev = "dev"
    prod = "prod"


class Logging(BaseModel):
    level: str = "debug"


class SQLiteDatabase(BaseModel):
    path: Union[NewPath, FilePath] = Field(
        default="/tmp/bladecreate/bladecreate.db", union_mode="left_to_right"
    )


class PostgresDatabase(BaseModel):
    user: str
    password: str
    host: str
    database: str


class FileStorage(BaseModel):
    path: Union[NewPath, FilePath] = Field(default="/tmp/bladecreate/", union_mode="left_to_right")


class S3Storage(BaseModel):
    bucket: str


class StoragePaths(BaseModel):
    datasets: str = "datasets/user-{user_id}/default/"
    sample_sets: str = "sample_sets/user-{user_id}/{task_id}/"
    pretrain_models: str = "models/pretrain/{pretrain_model_id}"
    out_models: str = "models/user-{user_id}/{task_id}/"
    images: str = "images/{user_id}/{project_uuid}/{image_uuid}"


class GPUPlatformEnum(str, Enum):
    CUDA = "cuda"
    MAC = "mac"
    NONE = ""

    @property
    def is_cuda(self):
        return self == GPUPlatformEnum.CUDA

    @property
    def is_mac(self):
        return self == GPUPlatformEnum.MAC


class APISwitchEnum(str, Enum):
    CRUD = "crud"
    GENERATE = "generate"


class Server(BaseModel):
    apis: list[APISwitchEnum] = Field(default=[APISwitchEnum.CRUD])
    host: str = Field(default="0.0.0.0")
    port: int = Field(default=8080)
    reload: bool = Field(default=True)

    @property
    def is_crud_on(self):
        return APISwitchEnum.CRUD in self.apis

    @property
    def is_generate_on(self):
        return APISwitchEnum.GENERATE in self.apis


class Settings(BaseSettings):
    env: EnvEnum = Field(default=EnvEnum.dev)
    logging: Logging = Field(default=Logging())

    database: Union[SQLiteDatabase, PostgresDatabase] = Field(
        default=SQLiteDatabase(), union_mode="left_to_right"
    )
    object_storage: Union[FileStorage, S3Storage] = Field(
        default=FileStorage(), union_mode="left_to_right"
    )
    storage_paths: StoragePaths = Field(default=StoragePaths())
    gpu_platform: Optional[GPUPlatformEnum] = Field(default=None)
    server: Server = Field(default=Server())

    model_config = SettingsConfigDict(env_prefix="BC_", env_nested_delimiter="__")

    @property
    def is_db_sqlite(self):
        return isinstance(self.database, SQLiteDatabase)

    @property
    def is_db_postgres(self):
        return isinstance(self.database, PostgresDatabase)

    def sqlalchemy_url(self):
        if self.is_db_sqlite:
            return f"sqlite:///{self.database.path}"
        elif self.is_db_postgres:
            return f"postgresql://{self.database.user}:{self.database.password}@{self.database.host}/{self.database.database}"
        else:
            raise Exception(f"Unknown database: {self.database.model_dump_json(indent=2)}")

    @property
    def is_file_storage(self):
        return isinstance(self.object_storage, FileStorage)

    @property
    def is_s3_storage(self):
        return isinstance(self.object_storage, S3Storage)

    def init_prod(self):
        self.server.host = "127.0.0.1"
        self.server.reload = False
        self.logging = Logging(level="info")


settings = Settings()
if settings.env == EnvEnum.prod:
    settings.init_prod()

# TODO: override HG_HOME with values from settings


uvicorn_logging = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "default": {
            "()": "uvicorn.logging.DefaultFormatter",
            "fmt": "%(asctime)s : %(levelprefix)s %(message)s",
            "use_colors": None,
        },
        "access": {
            "()": "uvicorn.logging.AccessFormatter",
            "fmt": '%(asctime)s : %(levelprefix)s %(client_addr)s - "%(request_line)s" %(status_code)s',  # noqa: E501
        },
    },
    "handlers": {
        "default": {
            "formatter": "default",
            "class": "logging.StreamHandler",
            "stream": "ext://sys.stderr",
        },
        "access": {
            "formatter": "access",
            "class": "logging.StreamHandler",
            "stream": "ext://sys.stdout",
        },
    },
    "loggers": {
        "uvicorn": {"handlers": ["default"], "level": "INFO", "propagate": False},
        "uvicorn.error": {"level": "INFO"},
        "uvicorn.access": {"handlers": ["access"], "level": "INFO", "propagate": False},
    },
}
