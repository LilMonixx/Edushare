from fastapi import APIRouter, HTTPException
from firebase_admin import auth
from google.cloud.firestore import SERVER_TIMESTAMP
import uuid
from config.algolia_service import save_post

from config.firebase_config import db

router = APIRouter()


@router.post("/create-post")
def create_post(data: dict):
    id_token = data.get("id_token")
    content = data.get("content")
    subject = data.get("subject")
    attachments = data.get("attachments", [])

  
    if not id_token:
        raise HTTPException(status_code=400, detail="Missing id_token")

    if not subject:
        raise HTTPException(status_code=400, detail="Subject is required")

    
    try:
      print("ID TOKEN RECEIVED:", id_token)

      decoded = auth.verify_id_token(id_token)

      print("UID:", decoded["uid"])

    except Exception as e:
       print("🔥 FIREBASE VERIFY FAILED:", str(e))
       raise HTTPException(status_code=401, detail="Invalid Firebase token")

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

    doc_ref = db.collection("posts").document(post_id)
    doc_ref.set(post_data)

    saved_data = doc_ref.get().to_dict()

    save_post(post_id, saved_data)

    for att in attachments:

      attachment_id = str(uuid.uuid4())

      attachment_data = {
        "attachmentId": attachment_id,
        "postId": post_id,
        "file_url": att.get("file_url"),
        "file_type": att.get("file_type"),
        "file_name": att.get("file_name"),
        "file_size": att.get("file_size"),
        "createdAt": SERVER_TIMESTAMP,
       }

      db.collection("attachments").document(attachment_id).set(attachment_data)

    # db.collection("posts").document(post_id).set(post_data)

    # save_post(post_id, post_data)

    return {
        "message": "Post created successfully",
        "postId": post_id
    }