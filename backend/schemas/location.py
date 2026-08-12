from pydantic import BaseModel, Field
from typing import Optional

class LocationBase(BaseModel):
    latitude: float = Field(..., ge=-90, le=90, description="Широта (-90 до 90)")
    longitude: float = Field(..., ge=-180, le=180, description="Долгота (-180 до 180)")

class LocationCreate(LocationBase):
    pass

class LocationUpdate(LocationBase):
    pass

class LocationResponse(LocationBase):
    id: int
    user_id: int
    
    class Config:
        from_attributes = True