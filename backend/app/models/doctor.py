from sqlalchemy import Column, Integer, String, ForeignKey, Numeric
from sqlalchemy.orm import relationship
from app.db.database import Base

class Doctor(Base):
    __tablename__ = "doctors"

    id             = Column(Integer, primary_key=True, index=True)
    user_id        = Column(Integer, ForeignKey("users.id"), unique=True)
    specialization = Column(String, nullable=False)
    qualification  = Column(String, nullable=False)
    experience_years = Column(Integer, default=0)
    consultation_fee = Column(Numeric(10, 2), default=0)
    bio            = Column(String)

    user         = relationship("User", backref="doctor_profile")
    appointments = relationship("Appointment", back_populates="doctor")
    slots        = relationship("TimeSlot", back_populates="doctor")
