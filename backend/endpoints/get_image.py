import base64
import json
import os
from endpoints.util import get_json_body, get_db_session

def handle_get_image(handler):
    # 1. Validate JSON
    try:
        data = get_json_body(handler)
    except json.JSONDecodeError:
        handler.respond(400, {"error": "Invalid JSON"})
        return

    image_path = data.get("path")

    if not image_path or not os.path.exists(image_path):
        handler.respond(404, {"error": "Image not found"})
        return

    # 2. Retrieve image 
    try:
        with open(image_path, "rb") as f:
            image_bytes = f.read()

        b64_string = base64.b64encode(image_bytes).decode("utf-8")

        handler.respond(200, {
            "image": b64_string
        })

    except Exception as e:
        handler.respond(500, {"error": str(e)})