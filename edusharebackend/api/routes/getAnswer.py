
from fastapi import APIRouter, HTTPException
from firebase_admin import auth
from google.cloud.firestore import SERVER_TIMESTAMP
import uuid

from config.firebase_config import db

router = APIRouter()

@router.get("/getanswers")
def get_answers(postId: str):
    try:
        docs = db.collection("answers") \
            .where("postId", "==", postId) \
            .stream()

        result = []

        for doc in docs:
            data = doc.to_dict()

            result.append({
                "answerId": data.get("answerId"),
                "postId": data.get("postId"),
                "userId": data.get("userId"),
                "userName": data.get("userName"),
                "userAvatar": data.get("userAvatar"),
                "content": data.get("content"),
                "createdAt": str(data.get("createdAt")),
                "parentAnswerId": data.get("parentAnswerId"),
            })

        return {"data": result}

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))