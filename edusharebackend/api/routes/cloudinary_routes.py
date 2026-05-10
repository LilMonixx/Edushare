# routes/cloudinary_route.py

import os
import time
import hashlib

from fastapi import APIRouter

router = APIRouter()

CLOUD_NAME = os.getenv("CLOUD_NAME")
CLOUD_API_KEY = os.getenv("CLOUD_API_KEY")
CLOUD_API_SECRET = os.getenv("CLOUD_API_SECRET")


@router.get("/cloudinary-signature")
def get_signature():

    timestamp = int(time.time())

    params_to_sign = f"folder=posts&timestamp={timestamp}"

    signature = hashlib.sha1(
        (params_to_sign + CLOUD_API_SECRET).encode()
    ).hexdigest()

    return {
        "timestamp": timestamp,
        "signature": signature,
        "apiKey": CLOUD_API_KEY,
        "cloudName": CLOUD_NAME
    }