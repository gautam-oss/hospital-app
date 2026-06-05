from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.db.database import get_db
from app.models.appointment import Appointment, TimeSlot, AppointmentStatus
from app.schemas.appointment import AppointmentCreate, AppointmentResponse, TimeSlotCreate, TimeSlotResponse
from typing import List

router = APIRouter()

@router.get("/slots", response_model=List[TimeSlotResponse])
def get_available_slots(doctor_id: int, db: Session = Depends(get_db)):
    return db.query(TimeSlot).filter(
        TimeSlot.doctor_id == doctor_id,
        TimeSlot.is_booked == 0
    ).all()

@router.post("/slots", response_model=TimeSlotResponse, status_code=201)
def create_slot(slot: TimeSlotCreate, db: Session = Depends(get_db)):
    db_slot = TimeSlot(**slot.model_dump())
    db.add(db_slot)
    db.commit()
    db.refresh(db_slot)
    return db_slot

@router.post("/", response_model=AppointmentResponse, status_code=201)
def book_appointment(appointment: AppointmentCreate, db: Session = Depends(get_db)):
    slot = db.query(TimeSlot).filter(TimeSlot.id == appointment.slot_id).first()
    if not slot or slot.is_booked:
        raise HTTPException(status_code=400, detail="Slot not available")
    slot.is_booked = 1
    db_appointment = Appointment(**appointment.model_dump(), patient_id=1)
    db.add(db_appointment)
    db.commit()
    db.refresh(db_appointment)
    return db_appointment

@router.get("/", response_model=List[AppointmentResponse])
def get_appointments(db: Session = Depends(get_db)):
    return db.query(Appointment).all()

@router.patch("/{id}/cancel", response_model=AppointmentResponse)
def cancel_appointment(id: int, db: Session = Depends(get_db)):
    apt = db.query(Appointment).filter(Appointment.id == id).first()
    if not apt:
        raise HTTPException(status_code=404, detail="Appointment not found")
    apt.status = AppointmentStatus.cancelled
    db.commit()
    db.refresh(apt)
    return apt
