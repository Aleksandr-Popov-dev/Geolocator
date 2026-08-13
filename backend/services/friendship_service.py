from sqlalchemy.orm import Session
from typing import List
from fastapi import HTTPException, status
from ..repositories.friendship_repository import FriendshipRepository
from ..repositories.user_repository import UserRepository
from ..schemas.friendship import FriendResponse, FriendshipResponse, FriendshipCreate
from ..models.friendship import FriendshipStatus

class FriendshipService:
    def __init__(self, db: Session):
        self.db = db
        self.repository = FriendshipRepository(db)
        self.user_repository = UserRepository(db)
    
    def send_request(self, sender_id: int, receiver_id: int) -> FriendshipResponse:
        if sender_id == receiver_id:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Cannot send friend request to yourself"
            )
        
        receiver = self.user_repository.get_by_id(receiver_id)
        if not receiver:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="User not found"
            )
        
        existing_friendship = self.repository.get_friendship(sender_id, receiver_id)
        if existing_friendship:
            if existing_friendship.status == FriendshipStatus.PENDING:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Friend request already sent"
                )
            elif existing_friendship.status == FriendshipStatus.ACCEPTED:
                raise HTTPException(
                    status_code=status.HTTP_400_BAD_REQUEST,
                    detail="Already friends"
                )
            
        friendship = self.repository.create_request(sender_id, receiver_id)
        return FriendshipResponse.model_validate(friendship)

    def checker_for_request(self, user_id: int, friendship_id: int) -> bool:
        friendship = self.repository.get_friendship_by_id(friendship_id)
        if not friendship_id:
            raise HTTPException(
                status_code=status.HTTP_404_NOT_FOUND,
                detail="Friend request not found"
            )
        
        if friendship.receiver_id != user_id:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="You can only accept requests sent to you"
            )
        
        if friendship.status != FriendshipStatus.PENDING:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail=f"Request already {friendship.status}"
            )
        return True

    def accept_request(self, friendship_id: int) -> FriendshipResponse:
        if self.checker_for_request:
            friendship = self.repository.update_status(friendship_id, FriendshipStatus.ACCEPTED)
        return FriendshipResponse.model_validate(friendship)

    def reject_request(self, friendship_id: int) -> FriendshipResponse:
        if self.checker_for_request:
            friendship = self.repository.update_status(friendship, FriendshipStatus.REJECTED)
    
    def get_pending_requests(self, user_id: int) -> List[FriendshipResponse]:
        friendships = self.repository.get_pending_requests(user_id)
        return friendships
    
    def get_friends(self, user_id: int) -> List[FriendResponse]:
        friends = self.repository.get_friends(user_id)
        result = []
        for friend in friends:
            friendship = self.repository.get_friendship(user_id, friend.id)
            result.append(FriendResponse(
                id = friend.id,
                username = friend.username,
                fullname = friend.fullname,
                email = friend.email,
                friendship_id = friendship.id
            ))
        return result

    def are_friends(self, user1_id: int, user2_id: int) -> bool:
        friendship = self.repository.get_friendship(user1_id, user2_id)
        return friendship is not None and friendship.status == FriendshipStatus.ACCEPTED
