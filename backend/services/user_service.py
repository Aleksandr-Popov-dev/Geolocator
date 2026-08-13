from sqlalchemy.orm import Session
from typing import List, Optional
from ..repositories.user_repository import UserRepository
from ..schemas.user import UserResponse, UserCreate, UserWithToken, UserLogin
from fastapi import HTTPException, status
from .jwt_service import JWTService
from .auth_service import AuthService



class UserService:
    def __init__(self, db: Session):
        self.repository = UserRepository(db)
    

    def get_all_users(self) -> List[UserResponse]:
        users = self.repository.get_all()
        return [UserResponse.model_validate(user) for user in users]
    

    def get_user_by_username(self, username: str) -> UserResponse:
        user = self.repository.get_by_username(username)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"User with username {username} not found"
            )
        return UserResponse.model_validate(user)
    
    def get_user_by_id(self, user_id: int) -> UserResponse:
        user = self.repository.get_by_id(user_id)
        if not user:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail=f"User with user_id {user_id} not found"
            )
        return UserResponse.model_validate(user)
    
    def get_user_by_username_optional(self, username: str) -> Optional[UserResponse]:
        user = self.repository.get_by_username(username)
        return UserResponse.model_validate(user) if user else None
    
    def get_user_by_email_optional(self, email: str) -> Optional[UserResponse]:
        user = self.repository.get_by_email(email)
        return UserResponse.model_validate(user) if user else None
    

    def create_user(self, user_data: UserCreate) -> UserWithToken:
        user_dict = user_data.model_dump()
        user_dict["password"] = AuthService.hash_password(user_dict["password"])
        user = self.repository.create(UserCreate(**user_dict))

        token_data = {"sub": user.username, "id": user.id}
        access_token = JWTService.create_access_token(token_data)

        return UserWithToken(
            id=user.id,
            username=user.username,
            fullname=user.fullname,
            email=user.email,
            access_token=access_token
        )
    
    def authenticate_user(self, login_data: UserLogin) -> UserWithToken:
        user = self.repository.get_by_email(login_data.email)
        if not user:
            raise HTTPException (
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password",
                headers={"WWW-Authenticate": "Bearer"}
            )
        
        if not AuthService.verify_password(login_data.password, user.password):
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Incorrect email or password",
                headers={"WWW-Authenticate": "Bearer"},
            )
        
        token_data = {"sub": user.username, "id": user.id}
        access_token = JWTService.create_access_token(token_data)

        return UserWithToken(
            id=user.id,
            username=user.username,
            fullname=user.fullname,
            email=user.email,
            access_token=access_token
        )

