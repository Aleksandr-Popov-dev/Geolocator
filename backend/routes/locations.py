from fastapi import APIRouter, Depends, status, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
from ..services.location_service import LocationService
from ..schemas.location import LocationCreate, LocationResponse
from ..services.auth_dependency import get_current_user
from ..models.user import User


router = APIRouter(
    prefix="/api/locations",
    tags=["locations"]
)

@router.post("/update", response_model=LocationResponse, status_code=status.HTTP_200_OK)
def update_location(
    location_data: LocationCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    service = LocationService(db)
    return service.update_location(current_user.id, location_data)

@router.get("/me", response_model=LocationResponse)
def get_my_location(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    service = LocationService(db)
    location = service.get_location(current_user.id)
    if not location:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Location not found"
        )
    return location

@router.get("/user/{user_id}", response_model=LocationResponse)
def get_user_location(
    user_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    service = LocationService(db)
    location = service.get_location(user_id)
    if not location:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Location not found"
        )
    return location
