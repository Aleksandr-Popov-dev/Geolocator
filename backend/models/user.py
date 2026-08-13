import re
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from ..database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(100), unique=True, nullable=False, index=True)
    fullname = Column(String(100), unique=False, nullable=False, index=True)
    email = Column(String(100), unique=True, nullable=False, index=True)
    password = Column(String(255), nullable=False)  

    # Relationships
    locations = relationship("Location", back_populates="user", cascade="all, delete-orphan")
    sent_friend_requests = relationship("Friendship", foreign_keys="Friendship.sender_id", back_populates="sender")
    received_friend_requests = relationship("Friendship", foreign_keys="Friendship.receiver_id", back_populates="receiver")

    def __repr__(self):
        return f"<User {self.username}>"