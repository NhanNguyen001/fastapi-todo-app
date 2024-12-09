from fastapi import FastAPI, Request, status, HTTPException
from models import Base
from database import engine
from routers import auth, todos, admin, users
from fastapi.staticfiles import StaticFiles
from fastapi.responses import RedirectResponse, JSONResponse
from monitoring import setup_monitoring
import logging

# Create FastAPI app
app = FastAPI(
    title="Todo App API",
    description="A FastAPI application for managing todos with monitoring",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# Setup monitoring first
setup_monitoring(app)

# Initialize database
Base.metadata.create_all(bind=engine)

# Mount static files
app.mount("/static", StaticFiles(directory="static"), name="static")

@app.get("/")
def test(request: Request):
    return RedirectResponse(url="/todos/todo-page", status_code=status.HTTP_302_FOUND)

@app.get("/health")
def health_check():
    return {"status": "Healthy"}

# Include routers
app.include_router(auth.router)
app.include_router(todos.router)
app.include_router(admin.router)
app.include_router(users.router)

@app.exception_handler(HTTPException)
async def http_exception_handler(request, exc):
    return JSONResponse(
        status_code=exc.status_code,
        content={"detail": exc.detail}
    )
