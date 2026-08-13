from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..services.friendship_service import FriendshipService
from ..schemas.friendship import FriendResponse, FriendshipResponse, FriendshipCreate
from ..services.auth_dependency import get_current_user
from ..models.user import User

router = APIRouter(
    prefix="/api/friends",
    tags=["friends"]
)

@router.post("/request/{user_id}", response_model=FriendshipResponse)
def send_friend_request(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    service = FriendshipService(db)
    return service.send_request(current_user.id, user_id)

@router.post("/accept/{friendship_id}", response_model=FriendshipResponse)
def accept_friedn_request(
    friendship_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    service = FriendshipService(db)
    return service.accept_request(friendship_id)

@router.post("/reject/{friendship_id}", response_model=FriendshipResponse)
def reject_friedn_request(
    friendship_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    service = FriendshipService(db)
    return service.reject_request(friendship_id)

@router.get("/requests", response_model=List[FriendshipResponse])
def get_pending_requests(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    service = FriendshipService(db)
    return service.get_pending_requests(current_user.id)

@router.get("/friends", response_model=List[FriendResponse])
def get_friends(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    service = FriendshipService(db)
    return service.get_friends(current_user.id)

@router.get("/check/{user_id}", response_model=bool)
def check_friendship(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    service = FriendshipService(db)
    return service.are_friends(current_user.id, user_id)