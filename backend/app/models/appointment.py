from sqlalchemy import Column, Integer, String, ForeignKey, DateTime, Enum, Text
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
import enum
from app.db.database import Base

class AppointmentStatus(str, enum.Enum):
    pending   = "pending"
    confirmed = "confirmed"
    cancelled = "cancelled"
    completed = "completed"

class Appointment(Base):
    __tablename__ = "appointments"

    id           = Column(Integer, primary_key=True, index=True)
    patient_id   = Column(Integer, ForeignKey("users.id"), nullable=False)
    doctor_id    = Column(Integer, ForeignKey("doctors.id"), nullable=False)
    slot_id      = Column(Integer, ForeignKey("time_slots.id"), nullable=False)
    status       = Column(Enum(AppointmentStatus), default=AppointmentStatus.pending)
    reason       = Column(Text)
    notes        = Column(Text)
    created_at   = Column(DateTime(timezone=True), server_default=func.now())

    patient = relationship("User", foreign_keys=[patient_id])
    doctor  = relationship("Doctor", back_populates="appointments")
    slot    = relationship("TimeSlot", back_populates="appointment")

class TimeSlot(Base):
    __tablename__ = "time_slots"

    id         = Column(Integer, primary_key=True, index=True)
    doctor_id  = Column(Integer, ForeignKey("doctors.id"), nullable=False)
    start_time = Column(DateTime(timezone=True), nullable=False)
    end_time   = Column(DateTime(timezone=True), nullable=False)
    is_booked  = Column(Integer, default=0)

    doctor      = relationship("Doctor", back_populates="slots")
    appointment = relationship("Appointment", back_populates="slot", uselist=False)
