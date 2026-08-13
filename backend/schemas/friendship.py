from pydantic import BaseModel
from typing import Optional
import enum

class FriendshipStatus(str, enum.Enum):
    PENDING = "pending"
    ACCEPTED = "accepted"
    REJECTED = "rejected"
    BLOCKED = "blocked"

class FriendshipBase(BaseModel):
    sender_id: int
    receiver_id: int
    status: FriendshipStatus

class FriendshipCreate(BaseModel):
    receiver_id: int

class FriendshipResponse(BaseModel):
    id: int
    sender_id: int
    receiver_id: int
    status: str

    class Config:
        from_attributes = True

class FriendResponse(BaseModel):
    id: int
    username: str
    fullname: str
    email: str
    friendship_id: int

    class Config:
        from_attributes = True


