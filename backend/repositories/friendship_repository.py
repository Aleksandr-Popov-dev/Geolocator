from sqlalchemy.orm import Session
from typing import List, Optional
from ..models.friendship import Friendship, FriendshipStatus
from ..models.user import User

class FriendshipRepository:
    def __init__(self, db: Session):
        self.db = db
    
    def get_friendship_by_id(self, friendship_id: int) -> Optional[Friendship]:
        return self.db.query(Friendship).filter(Friendship.id == friendship_id).first()
    
    def get_pending_requests(self, user_id: int) -> List[Friendship]:
        return self.db.query(Friendship).filter(
            Friendship.receiver_id == user_id,
            Friendship.status == FriendshipStatus.PENDING 
        ).all()
    
    def get_friends(self, user_id: int) -> List[User]:
        frieds = self.db.query(User).join(
            Friendship,
            ((Friendship.sender_id == user_id) & (Friendship.receiver_id == User.id)) | ((Friendship.sender_id == User.id) & (Friendship.receiver_id == user_id))
        ).filter(
            Friendship.status == FriendshipStatus.ACCEPTED
        ).all()
        return frieds
    
    def get_friendship(self, user1_id: int, user2_id: int) -> Optional[Friendship]:
        return self.db.query(Friendship).filter(
            ((Friendship.sender_id == user1_id) & (Friendship.receiver_id == user2_id)) | ((Friendship.sender_id == user2_id) & (Friendship.receiver_id == user1_id))
        ).first()
    
    def create_request(self, sender_id: int, receiver_id: int) -> Friendship:
        friendship = Friendship(
            sender_id = sender_id,
            receiver_id = receiver_id,
            status = FriendshipStatus.PENDING
        )
        self.db.add(friendship)
        self.db.commit()
        self.db.refresh(friendship)
        return friendship
    
    def update_status(self, friendship_id: int, status: FriendshipStatus) -> Friendship:
        friendship = self.get_friendship_by_id(friendship_id)
        if friendship_id:
            friendship.status = status
            self.db.commit()
            self.db.refresh(friendship)
        return friendship
    
