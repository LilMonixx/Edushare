from fastapi import APIRouter
from config.firebase_config import db

router = APIRouter()


@router.get("/posts")
def get_posts(limit: int = 10, lastId: str = None):

    query = db.collection("posts") \
        .order_by("createdAt", direction="DESCENDING") \
        .limit(limit)

    if lastId:
        last_doc = db.collection("posts").document(lastId).get()
        if last_doc.exists:
            query = query.start_after(last_doc)

    docs = list(query.stream())

    posts = []

    for doc in docs:
        data = doc.to_dict()

        posts.append({
            "postId": doc.id,
            **data,

            # optional: ensure fallback an toàn
            "authorName": data.get("authorName", "Unknown"),
            "authorAvatar": data.get("authorAvatar", None),
        })

    return {"data": posts}