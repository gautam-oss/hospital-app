from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    PROJECT_NAME: str = "Hospital Appointment System"
    VERSION: str = "1.0.0"
    DATABASE_URL: str = "postgresql://dbadmin:localtest123@localhost:5432/mysaas_local"
    SECRET_KEY: str = "local-jwt-secret-changeme"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    ENVIRONMENT: str = "local"

    class Config:
        env_file = ".env"

settings = Settings()
