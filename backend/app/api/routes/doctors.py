from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models.doctor import Doctor
from app.models.user import User
from typing import List
from pydantic import BaseModel

router = APIRouter()

class DoctorResponse(BaseModel):
    id: int
    user_id: int
    specialization: str
    qualification: str
    experience_years: int
    bio: str | None

    class Config:
        from_attributes = True

@router.get("/", response_model=List[DoctorResponse])
def get_doctors(db: Session = Depends(get_db)):
    return db.query(Doctor).all()

@router.get("/{id}", response_model=DoctorResponse)
def get_doctor(id: int, db: Session = Depends(get_db)):
    doctor = db.query(Doctor).filter(Doctor.id == id).first()
    if not doctor:
        raise HTTPException(status_code=404, detail="Doctor not found")
    return doctor
