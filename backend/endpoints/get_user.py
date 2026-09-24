import json
from endpoints.util import get_json_body, get_db_session

def handle_get_user(handler):
    try:
        data = get_json_body(handler)
    except Exception:
        return handler.respond(400, {"error": "Invalid JSON"})

    email = data.get("email")
    if not email:
        return handler.respond(400, {"error": "Missing email"})

    with get_db_session() as session:
        result = session.run(
            """
            MATCH (u:User {email: $email})
            RETURN properties(u) AS props
            """,
            email=email
        )
        record = result.single()

        if not record:
            return handler.respond(404, {"error": "User not found"})

        props = record["props"] or {}
        
        # Read the exact DB property names ('profilePicturePath' / 'bannerPicturePath')
        profile_path = props.get("profilePicturePath") or props.get("profilePicture") or ""
        banner_path = props.get("bannerPicturePath") or props.get("bannerPicture") or ""

        # Normalize Windows paths
        profile_path = profile_path.replace("\\", "/")
        banner_path = banner_path.replace("\\", "/")

        user_data = {
            "name": props.get("name", ""),
            "email": props.get("email", email),
            "birthday": props.get("birthday", ""),
            "profilePicture": profile_path,
            "bannerPicture": banner_path
        }

    handler.respond(200, {"user": user_data})