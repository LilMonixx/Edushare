from fastapi import APIRouter, HTTPException
from firebase_admin import auth
from google.cloud.firestore import SERVER_TIMESTAMP

from config.firebase_config import db

router = APIRouter()

# ================= LOGIN =================
@router.post("/login")
def google_login(data: dict):
    id_token = data.get("id_token")

    if not id_token:
        raise HTTPException(status_code=400, detail="Missing id_token")

    try:
        # verify Firebase token
        decoded = auth.verify_id_token(id_token)
    except Exception:
        raise HTTPException(status_code=401, detail="Invalid token")

    uid = decoded["uid"]
    email = decoded.get("email", "")
    name = decoded.get("name") or email
    avatar = decoded.get("picture", "")

    # ================= USERS COLLECTION =================
    user_ref = db.collection("users").document(uid)
    user_doc = user_ref.get()

    if not user_doc.exists:
        user_ref.set({
            "uid": uid,
            "email": email,
            "name": name,
            "avatar": avatar,
            "role": "NORMALUSER",
            "createdAt": SERVER_TIMESTAMP,
            "lastLogin": SERVER_TIMESTAMP
        })
    else:
        user_ref.update({
            "lastLogin": SERVER_TIMESTAMP
        })

    # ================= RESPONSE TO FLUTTER =================
    return {
        "uid": uid,
        "email": email,
        "name": name,
        "avatar": avatar,
        "role": "NORMALUSER"
    }