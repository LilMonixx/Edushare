from fastapi import APIRouter, HTTPException
from firebase_admin import auth
from google.cloud.firestore import SERVER_TIMESTAMP
import uuid

from config.firebase_config import db

router = APIRouter()


@router.post("/create-post")
def create_post(data: dict):
    id_token = data.get("id_token")
    content = data.get("content")
    subject = data.get("subject")

  
    if not id_token:
        raise HTTPException(status_code=400, detail="Missing id_token")

    if not subject:
        raise HTTPException(status_code=400, detail="Subject is required")

    
    try:
        decoded = auth.verify_id_token(id_token)
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")

    uid = decoded["uid"]

    
    user_doc = db.collection("users").document(uid).get()

    if not user_doc.exists:
        raise HTTPException(status_code=404, detail="User not found")

    user_data = user_doc.to_dict()

    author_name = user_data.get("name", "Anonymous")
    author_avatar = user_data.get("avatar", None)

    
    post_id = str(uuid.uuid4())

    post_data = {
        "postId": post_id,
        "userId": uid,

        
        "authorName": author_name,
        "authorAvatar": author_avatar,

        "content": content,
        "subject": subject,
        "status": "APPROVED",
        "createdAt": SERVER_TIMESTAMP,
        "updatedAt": SERVER_TIMESTAMP,
    }

    db.collection("posts").document(post_id).set(post_data)

    return {
        "message": "Post created successfully",
        "postId": post_id
    }