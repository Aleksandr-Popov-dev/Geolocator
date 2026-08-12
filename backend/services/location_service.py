from sqlalchemy.orm import Session
from typing import Optional
from ..repositories.location_repository import LocationRepository
from ..schemas.location import LocationCreate, LocationResponse
from fastapi import HTTPException, status

class LocationService:
    def __init__(self, db: Session):
        self.repository = LocationRepository(db)
    
    def update_location(self, user_id: int, location_data: LocationCreate) -> LocationResponse:
        location = self.repository.update_location(user_id, location_data)
        return LocationResponse.model_validate(location)
    
    def get_location(self, user_id: int) -> Optional[LocationResponse]:
        location = self.repository.get_by_user_id(user_id)
        if not location:
            return None
        return LocationResponse.model_validate(location)