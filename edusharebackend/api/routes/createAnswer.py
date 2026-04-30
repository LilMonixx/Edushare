
from fastapi import APIRouter, HTTPException
from firebase_admin import auth
from google.cloud.firestore import SERVER_TIMESTAMP
import uuid

from config.firebase_config import db

router = APIRouter()

@router.post("/answers")
def create_answer(data: dict):
    answer_id = str(uuid.uuid4())

    doc = {
        "answerId": answer_id,
        "userId": data["userId"],
        "userName": data["userName"],
        "userAvatar": data.get("userAvatar", ""),
        "postId": data["postId"],
        "parentAnswerId": None,
        "content": data["content"],
        "createdAt": SERVER_TIMESTAMP
    }

    db.collection("answers").document(answer_id).set(doc)

    # ❌ KHÔNG return doc nữa
    return {
        "message": "Answer created successfully",
        "answerId": answer_id
    }