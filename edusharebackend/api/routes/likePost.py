from fastapi import APIRouter, HTTPException
from firebase_admin import auth
from google.cloud.firestore import SERVER_TIMESTAMP
from config.firebase_config import db
import uuid

router = APIRouter()

# ✅ LIKE / UNLIKE
@router.post("/like-post")
def like_post(data: dict):
    id_token = data.get("id_token")
    post_id = data.get("postId")

    if not id_token or not post_id:
        raise HTTPException(status_code=400, detail="Missing data")

    try:
        decoded = auth.verify_id_token(id_token)
    except:
        raise HTTPException(status_code=401, detail="Invalid token")

    uid = decoded["uid"]

    # check đã like chưa
    existing = db.collection("save_post") \
        .where("postId", "==", post_id) \
        .where("userId", "==", uid) \
        .limit(1).get()

    if existing:
        # 👉 UNLIKE
        for doc in existing:
            db.collection("save_post").document(doc.id).delete()

        return {
            "liked": False,
            "message": "Unliked"
        }

    # 👉 LIKE
    like_id = str(uuid.uuid4())

    db.collection("save_post").document(like_id).set({
        "id": like_id,
        "postId": post_id,
        "userId": uid,
        "createdAt": SERVER_TIMESTAMP
    })

    return {
        "liked": True,
        "message": "Liked"
    }


# ✅ COUNT LIKE
@router.get("/like-count/{post_id}")
def get_like_count(post_id: str):
    docs = db.collection("save_post") \
        .where("postId", "==", post_id).get()

    return {
        "count": len(docs)
    }


# ✅ CHECK USER LIKE
@router.post("/check-liked")
def check_liked(data: dict):
    id_token = data.get("id_token")
    post_id = data.get("postId")

    if not id_token or not post_id:
        raise HTTPException(status_code=400, detail="Missing data")

    try:
        decoded = auth.verify_id_token(id_token)
    except:
        raise HTTPException(status_code=401, detail="Invalid token")

    uid = decoded["uid"]

    docs = db.collection("save_post") \
        .where("postId", "==", post_id) \
        .where("userId", "==", uid) \
        .limit(1).get()

    return {
        "liked": len(docs) > 0
    }