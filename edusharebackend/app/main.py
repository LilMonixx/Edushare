from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from config.firebase_config import db

from api.routes import login  
from api.routes import createPost
from api.routes import getPosts
from api.routes import createAnswer
from api.routes import getAnswer
from api.routes import likePost
from api.routes import chat


app = FastAPI()

# Cấu hình CORS để cho phép Flutter kết nối
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(login.router)
app.include_router(createPost.router)
app.include_router(getPosts.router)
app.include_router(createAnswer.router)
app.include_router(getAnswer.router)
app.include_router(likePost.router)
app.include_router(chat.router)


#uvicorn app.main:app --reload
#uvicorn app.main:app --host 0.0.0.0 --port 8000