from sqlalchemy.orm import Session
from typing import Optional
from ..models.location import Location
from ..schemas.location import LocationCreate

class LocationRepository:
    def __init__(self, db: Session):
        self.db = db
    
    def get_by_user_id(self, user_id: int) -> Optional[Location]:
        return self.db.query(Location).filter(Location.user_id == user_id).first()
    
    def update_location(self, user_id: int, location_data: LocationCreate) -> Location:
        existing_location = self.get_by_user_id(user_id)

        if existing_location:
            existing_location.latitude = location_data.latitude
            existing_location.longitude = location_data.longitude
            self.db.commit()
            self.db.refresh(existing_location)
            return existing_location
        else:
            db_location = Location(
                user_id = user_id,
                latitude = location_data.latitude,
                longitude = location_data.longitude
            )
            self.db.add(db_location)
            self.db.commit()
            self.db.refresh(db_location)
            return db_location