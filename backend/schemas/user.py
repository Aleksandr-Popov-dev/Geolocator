from pydantic import BaseModel, Field, EmailStr

class UserBase(BaseModel):
    username: str = Field(... , min_length=5, max_length=100,
        description="Username")
    fullname: str = Field(... , min_length=5, max_length=100,
        description="Fullname")
    email: str = Field(... , min_length=5, max_length=100,
        description="Email")
    password: str = Field(... , min_length=4, max_length=100,
        description="Password")


class UserCreate(UserBase):
    pass 


class UserResponse(BaseModel):
    id: int
    username: str
    fullname: str
    email: str

    class Config:
        from_attributes = True

class UserWithToken(UserResponse):
    access_token: str
    token_type: str = "bearer"


class UserLogin(BaseModel):
    email: EmailStr
    password: str