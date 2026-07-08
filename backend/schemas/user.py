from pydantic import BaseModel, Field

class UserBase(BaseModel):
    username: str = Field(... , min_lenght=5, max_lenght=100,
        desctiption="Username")
    fullname: str = Field(... , min_lenght=5, max_lenght=100,
        desctiption="Fullname")
    email: str = Field(... , min_lenght=5, max_lenght=100,
        desctiption="Email")
    Password: str = Field(... , min_lenght=5, max_lenght=100,
        desctiption="Password")


class UserCreate(UserBase):
    pass 


class UserResponse(UserBase):
    id: int = Field(... , description="Unique user indetifier")

    class Config:
        for_attributes = True
    