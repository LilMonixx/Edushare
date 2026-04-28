from fastapi import FastAPI

from config.firebase_config import db
from utils.auth import create_access, create_refresh
from api.routes import login  
from api.routes import refresh

app = FastAPI()

app.include_router(login.router)
app.include_router(refresh.router)

#uvicorn app.main:app --reload