from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from bladecreate.config import APIS, CRUD, GENERATE

app = FastAPI(generate_unique_id_function=lambda route: f"{route.name}")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


if CRUD in APIS:
    from bladecreate.crud_router import router as crud_router

    app.include_router(crud_router)

if GENERATE in APIS:
    from bladecreate.generate_router import router as generate_router

    app.include_router(generate_router)


@app.get("/health", response_model=None)
async def health_check():
    return
