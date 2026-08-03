from fastapi import APIRouter, Depends, status, HTTPException
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..services.user_service import UserService
from ..schemas.user import UserResponse, UserCreate

router = APIRouter(
    prefix="/api/users",
    tags=["users"]
)

@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def register_user(user_data: UserCreate, db: Session = Depends(get_db)):
    service = UserService(db)

    # check if user exist
    existing_user = service.get_user_by_username_optional(user_data.username)
    if existing_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="username is alredy exist"
        )
    
    return service.create_user(user_data)


@router.get("", response_model=List[UserResponse], status_code=status.HTTP_200_OK)
def get_users(db: Session = Depends(get_db)):
    service = UserService(db)
    return service.get_all_users()


@router.get("/{username}", response_model=UserResponse, status_code=status.HTTP_200_OK)
def get_user(username: str, db: Session = Depends(get_db)):
    service = UserService(db)
    return service.get_user_by_username(username)