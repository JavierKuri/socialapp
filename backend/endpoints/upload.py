import json
import base64
import os
import uuid
from endpoints.util import get_json_body, get_db_session

UPLOAD_DIR = "uploads/content"
os.makedirs(UPLOAD_DIR, exist_ok=True)

def save_base64_image(b64_string):
    image_bytes = base64.b64decode(b64_string)
    filename = f"{uuid.uuid4()}.jpg"
    path = os.path.join(UPLOAD_DIR, filename)

    with open(path, "wb") as f:
        f.write(image_bytes)

    return path

def handle_upload(handler):
    # 1. Validate JSON
    try:
        data = get_json_body(handler)
    except json.JSONDecodeError:
        handler.respond(400, {"error": "Invalid JSON"})
        return

    email = data.get("email")
    title = data.get("title")
    description = data.get("description")
    picture_b64 = data.get("postPicture")


    if not all([email, title, description, picture_b64]):
        handler.respond(400, {"error": "Missing values"})
        return

    # 2. Save images to disk
    try:
        picture_path = save_base64_image(picture_b64)
    except Exception:
        handler.respond(500, {"error": "Failed to save images"})
        return

    # 3. Query Neo4j
    with get_db_session() as session:

        # Create new post
        session.run(
            """
            MATCH (u:User {email: $email})
            CREATE (u)-[:POSTED {date: date()}]->(p:Post {title: $title, description: $description, picture_path: $picture_path})
            """,
            email=email,
            title=title,
            description=description,
            picture_path=picture_path
        )

    # 4. Success
    handler.respond(200, {"message": "Post created"})