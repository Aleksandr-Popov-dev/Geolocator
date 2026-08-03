from pydantic import BaseModel, Field

class UserBase(BaseModel):
    username: str = Field(... , min_length=5, max_length=100,
        desctiption="Username")
    fullname: str = Field(... , min_length=5, max_length=100,
        desctiption="Fullname")
    email: str = Field(... , min_length=5, max_length=100,
        desctiption="Email")
    password: str = Field(... , min_length=8, max_length=100,
        desctiption="Password")


class UserCreate(UserBase):
    pass 


class UserResponse(UserBase):
    id: int = Field(... , description="Unique user indetifier")

    class Config:
        from_attributes = True
    