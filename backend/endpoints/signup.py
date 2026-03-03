import json
import base64
import os
import uuid
from endpoints.util import get_json_body, get_db_session

UPLOAD_DIR = "uploads/users"
os.makedirs(UPLOAD_DIR, exist_ok=True)

def save_base64_image(b64_string):
    image_bytes = base64.b64decode(b64_string)
    filename = f"{uuid.uuid4()}.jpg"
    path = os.path.join(UPLOAD_DIR, filename)

    with open(path, "wb") as f:
        f.write(image_bytes)

    return path

def handle_signup(handler):
    # 1. Validate JSON
    try:
        data = get_json_body(handler)
    except json.JSONDecodeError:
        handler.respond(400, {"error": "Invalid JSON"})
        return

    name = data.get("name")
    email = data.get("email")
    password = data.get("password")
    birthday = data.get("birthday")
    profile_b64 = data.get("profilePicture")
    banner_b64 = data.get("bannerPicture")

    if not all([name, email, password, birthday, profile_b64, banner_b64]):
        handler.respond(400, {"error": "Missing values"})
        return

    # 2. Save images to disk
    try:
        profile_path = save_base64_image(profile_b64)
        banner_path = save_base64_image(banner_b64)
    except Exception:
        handler.respond(500, {"error": "Failed to save images"})
        return

    # 3. Query Neo4j
    with get_db_session() as session:
        # Check if user exists
        result = session.run(
            "MATCH (u:User {email: $email}) RETURN u",
            email=email
        )
        if result.single():
            handler.respond(409, {"error": "User already exists"})
            return

        # Create user
        session.run(
            """
            CREATE (u:User {
                name: $name,
                email: $email,
                password: $password,
                birthday: $birthday,
                profilePicturePath: $profile_path,
                bannerPicturePath: $banner_path
            })
            """,
            name=name,
            email=email,
            password=password,
            birthday=birthday,
            profile_path=profile_path,
            banner_path=banner_path
        )

    # 4. Success
    handler.respond(200, {
        "name": name,
        "email": email,
        "birthday": birthday,
        "profilePicture": profile_path,
        "bannerPicture": banner_path
    })