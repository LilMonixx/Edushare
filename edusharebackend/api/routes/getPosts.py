from unittest import result

from fastapi import APIRouter
from config.firebase_config import db
from config.algolia_service import search_posts

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

        # ================= ATTACHMENTS =================
        attachments_docs = db.collection("attachments") \
            .where("postId", "==", doc.id) \
            .stream()

        attachments = []

        for att in attachments_docs:

            att_data = att.to_dict()

            attachments.append({
                "attachmentId": att_data.get("attachmentId"),
                "file_url": att_data.get("file_url"),
                "file_type": att_data.get("file_type"),
                "file_name": att_data.get("file_name"),
                "file_size": att_data.get("file_size"),
            })

        posts.append({
            "postId": doc.id,

            **data,

            "attachments": attachments,

            "authorName": data.get("authorName", "Unknown"),
            "authorAvatar": data.get("authorAvatar"),
        })

    return {
        "data": posts
    }

@router.get("/posts/search")
def search_posts_api(q: str, limit: int = 10, page: int = 0, subject: str = None):

    result = search_posts(q, page, limit, subject)

    print(result)

    nb_pages = result.get("nbPages", 0)

    return {
        "data": result.get("hits", []),
        "hasMore": page + 1 < nb_pages
    }