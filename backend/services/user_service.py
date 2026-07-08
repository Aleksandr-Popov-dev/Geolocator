from sqlalchemy.orm import Session
from typing import List
from ..repositories.user_repository import UserRepository
from ..schemas.user import UserResponse, UserCreate
from fastapi import HTTPException, status


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
    

    def create_user(self, user_data: UserCreate) -> UserResponse:
        user = self.repository.create(user_data)
        return UserResponse.model_validate(user)