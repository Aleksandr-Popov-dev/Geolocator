from fastapi import APIRouter, Depends, status, HTTPException
from sqlalchemy.orm import Session
from typing import List
from ..database import get_db
from ..services.user_service import UserService
from ..schemas.user import UserResponse, UserCreate, UserWithToken, UserLogin

router = APIRouter(
    prefix="/auth",
    tags=["users"]
)

@router.post("/register", response_model=UserWithToken, status_code=status.HTTP_201_CREATED)
def register_user(user_data: UserCreate, db: Session = Depends(get_db)):
    service = UserService(db)

    # check if user exist
    existing_username = service.get_user_by_username_optional(user_data.username)
    if existing_username:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Username is alredy exist"
        )
    
    existing_email = service.get_user_by_email_optional(user_data.email)
    if existing_email:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email is alredy exist"
        )

    return service.create_user(user_data)

@router.post("/login", response_model=UserWithToken)
def login_user(user_data: UserLogin, db: Session = Depends(get_db)):
    service = UserService(db)
    return service.authenticate_user(user_data)


@router.get("/getUser/All", response_model=List[UserResponse], status_code=status.HTTP_200_OK)
def get_users(db: Session = Depends(get_db)):
    service = UserService(db)
    return service.get_all_users()


@router.get("/getUser/byUsername/{username}", response_model=UserResponse, status_code=status.HTTP_200_OK)
def get_user(username: str, db: Session = Depends(get_db)):
    service = UserService(db)
    return service.get_user_by_username(username)

@router.get("/getUser/byId/{user_id}", response_model=UserResponse, status_code=status.HTTP_200_OK)
def get_user_by_id(
    user_id: int,
    db: Session = Depends(get_db)
):
    service = UserService(db)
    return service.get_user_by_id(user_id)