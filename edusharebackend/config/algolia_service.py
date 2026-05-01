import requests
import time
from config.config import settings


APP_ID = settings.ALGOLIA_APP_ID
API_KEY = settings.ALGOLIA_WRITE_KEY
INDEX_NAME = "posts"

BASE_URL = f"https://{APP_ID}-dsn.algolia.net/1/indexes/{INDEX_NAME}"


headers = {
    "X-Algolia-Application-Id": APP_ID,
    "X-Algolia-API-Key": API_KEY,
    "Content-Type": "application/json"
}


def save_post(post_id, data):
    created_at = data.get("createdAt")

    if created_at is None:
        created_at = time.time()
    elif hasattr(created_at, "timestamp"):
        created_at = created_at.timestamp()

    payload = {
        "objectID": str(post_id),
        "postId": post_id,
        "content": data.get("content", ""),
        "authorName": data.get("authorName", ""),
        "authorAvatar": data.get("authorAvatar", ""),
        "subject": data.get("subject", ""),
        "status": data.get("status", "APPROVED"),
        "createdAt": created_at,
    }

    r = requests.post(BASE_URL, json=payload, headers=headers)
    return r.json()


def search_posts(keyword, page=0, hits_per_page=10, subject=None):
    url = f"{BASE_URL}/query"

    filters = "status:APPROVED"

    if subject:
        filters += f" AND subject:\"{subject}\""

    body = {
        "query": keyword,
        "page": page,
        "hitsPerPage": hits_per_page,
        "filters": filters
    }

    r = requests.post(url, json=body, headers=headers)
    return r.json()

def setup_index():
    url = f"https://{APP_ID}-dsn.algolia.net/1/indexes/{INDEX_NAME}/settings"

    body = {
        "attributesForFaceting": [
            "status",
            "subject"
        ]
    }

    r = requests.put(url, json=body, headers=headers)
    return r.json()