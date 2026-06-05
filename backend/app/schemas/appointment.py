from pydantic import BaseModel
from datetime import datetime
from app.models.appointment import AppointmentStatus

class AppointmentCreate(BaseModel):
    doctor_id: int
    slot_id: int
    reason: str

class AppointmentResponse(BaseModel):
    id: int
    patient_id: int
    doctor_id: int
    slot_id: int
    status: AppointmentStatus
    reason: str | None
    created_at: datetime

    class Config:
        from_attributes = True

class TimeSlotCreate(BaseModel):
    doctor_id: int
    start_time: datetime
    end_time: datetime

class TimeSlotResponse(BaseModel):
    id: int
    doctor_id: int
    start_time: datetime
    end_time: datetime
    is_booked: bool

    class Config:
        from_attributes = True
