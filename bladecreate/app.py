import multiprocessing
import sys

import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from bladecreate.logging import Logger
from bladecreate.settings import settings, uvicorn_logging

logger = Logger.get_logger(__name__)
logger.info(f"Settings: {settings.model_dump_json(indent=2)}")

# Check if it is frozen (running from pyinstaller-built bundle)
if getattr(sys, "frozen", False) and hasattr(sys, "_MEIPASS"):
    logger.info("running in a PyInstaller bundle")
    multiprocessing.freeze_support()
else:
    logger.info("running in a normal Python process")
    pass

app = FastAPI(generate_unique_id_function=lambda route: f"{route.name}")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


if settings.server.is_crud_on:
    from bladecreate.crud_router import router as crud_router

    app.include_router(crud_router)

if settings.server.is_generate_on:
    from bladecreate.generate_router import router as generate_router

    app.include_router(generate_router)


@app.get("/health", response_model=None)
async def health_check():
    return


if __name__ == "__main__":
    if settings.server.reload:
        uvicorn.run(
            "bladecreate.app:app",
            host=settings.server.host,
            port=settings.server.port,
            reload=True,
            log_config=uvicorn_logging,
        )
    else:
        uvicorn.run(
            app,
            host=settings.server.host,
            port=settings.server.port,
            log_config=uvicorn_logging,
        )
