from .users import router
from .locations import router as locations_router
from .friends import router as friends_router

__all__ = ['router', 'locations_router', 'friends_router']