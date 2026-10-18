"""
Swachta API — FastAPI application entry point.
"""
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from config import get_settings
from database import Base, engine
from routers.auth import router as auth_router
from routers.households import router as households_router
from routers.issues import router as issues_router
from routers.ops import router as ops_router
from routers.payments_earnings import earnings_router, payments_router
from routers.routes import router as routes_router
from routers.verification import router as verification_router
from routers.rewards import router as rewards_router

settings = get_settings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    # Create tables on startup (Alembic handles migrations in production)
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    await engine.dispose()


app = FastAPI(
    title="Swachta API",
    description=(
        "Verified household waste collection platform — Ghaziabad Pilot MVP. "
        "Core mechanic: segregation quality verified at point of collection."
    ),
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc",
    lifespan=lifespan,
)

# CORS — allow Expo Go, web dashboard, and future domains
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routers
app.include_router(auth_router, prefix="/api/v1")
app.include_router(households_router, prefix="/api/v1")
app.include_router(routes_router, prefix="/api/v1")
app.include_router(verification_router, prefix="/api/v1")
app.include_router(payments_router, prefix="/api/v1")
app.include_router(earnings_router, prefix="/api/v1")
app.include_router(issues_router, prefix="/api/v1")
app.include_router(ops_router, prefix="/api/v1")
app.include_router(rewards_router, prefix="/api/v1")


@app.get("/health", tags=["system"])
async def health() -> dict:
    return {"status": "ok", "service": "swachta-api", "version": "1.0.0"}


@app.get("/", tags=["system"])
async def root() -> dict:
    return {
        "service": "Swachta API",
        "docs": "/docs",
        "health": "/health",
    }
