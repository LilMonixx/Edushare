from fastapi import FastAPI

from config.firebase_config import db

from api.routes import login  
from api.routes import createPost
from api.routes import getPosts
from api.routes import createAnswer
from api.routes import getAnswer


app = FastAPI()

app.include_router(login.router)
app.include_router(createPost.router)
app.include_router(getPosts.router)
app.include_router(createAnswer.router)
app.include_router(getAnswer.router)


#uvicorn app.main:app --reload
#uvicorn app.main:app --host 0.0.0.0 --port 8000