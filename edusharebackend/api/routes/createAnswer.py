
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

    post_doc = db.collection("posts").document(data["postId"]).get()
    post_data = post_doc.to_dict()

    #note

    receiver_id = post_data["userId"]

    # không gửi notification cho chính mình
    if receiver_id != data["userId"]:

        notification_id = str(uuid.uuid4())

        notification = {
            "id": notification_id,
            "postId": data["postId"],
            "receiverId": receiver_id,
            "senderId": data["userId"],
            "userName": data["userName"],
            "avatarUrl": data.get("userAvatar", ""),
            "content": f"{data['userName']} commented on your post",
            "createdAt": SERVER_TIMESTAMP,
            "isSeen": False
        }

        db.collection("notifications").document(notification_id).set(notification)

    # KHÔNG return doc nữa
    return {
        "message": "Answer created successfully",
        "answerId": answer_id
    }