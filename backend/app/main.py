from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.api.routes import auth, appointments, doctors

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    docs_url="/docs",
    redoc_url="/redoc"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(doctors.router, prefix="/api/doctors", tags=["doctors"])
app.include_router(appointments.router, prefix="/api/appointments", tags=["appointments"])

@app.get("/health")
def health():
    return {"status": "ok", "version": settings.VERSION}

@app.get("/")
def root():
    return {"message": "Hospital Appointment System API", "docs": "/docs"}
