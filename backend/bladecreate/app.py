import multiprocessing
import sys

import uvicorn
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from bladecreate.logging import Logger
from bladecreate.services.generate_router import router as generate_router
from bladecreate.services.image_router import router as image_router
from bladecreate.services.project_router import router as crud_router
from bladecreate.settings import settings, uvicorn_logging

logger = Logger.get_logger(__name__)
logger.info(f"Settings: {settings.model_dump_json(indent=2)}")


app = FastAPI(generate_unique_id_function=lambda route: f"{route.name}")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.include_router(image_router)
app.include_router(crud_router)
app.include_router(generate_router)


@app.get("/health", response_model=None)
async def health_check():
    return


def run_app():
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


if __name__ == "__main__":
    # Check if it is frozen (running from pyinstaller-built bundle)
    # This has to be called right here.
    if getattr(sys, "frozen", False) and hasattr(sys, "_MEIPASS"):
        logger.info("running in a PyInstaller bundle")
        multiprocessing.freeze_support()
    else:
        logger.info("running in a unbundled Python process")
        pass

    if settings.server.worker:
        from bladecreate.services.generate_worker import run_generate_worker

        worker_p = multiprocessing.Process(
            name="BladeCreate Generate Worker", target=run_generate_worker
        )
        worker_p.start()

        try:
            run_app()

        except Exception as e:
            worker_p.terminate()
            raise e

        finally:
            worker_p.join()

    else:
        run_app()
