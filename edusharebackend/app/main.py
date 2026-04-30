from fastapi import FastAPI

from config.firebase_config import db

from api.routes import login  


app = FastAPI()

app.include_router(login.router)



#uvicorn app.main:app --reload