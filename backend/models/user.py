import re
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from ..database import Base

class User(Base):
    __tablename__ = "user"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String, unique=True, nullable=False, index=True)
    fullname = Column(String, unique=False, nullable=False, index=True)
    email = Column(String, unique=True, nullable=False, index=True)
    password = Column(String, unique=False, nullable=False, index=True)

    def __repr__(self):
        return f"<User {self.username}>"