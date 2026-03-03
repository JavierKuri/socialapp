import json
from endpoints.util import get_json_body, get_db_session

def handle_login(handler):
    # 1. Validate JSON
    try:
        data = get_json_body(handler)
    except json.JSONDecodeError:
        handler.respond(400, {"error": "Invalid JSON"})
        return

    email = data.get("email")
    password = data.get("password")

    if not email or not password:
        handler.respond(400, {"error": "Missing email or password"})
        return

    # 2. Query Neo4j
    with get_db_session() as session:
        result = session.run(
            """
            MATCH (u:User {email: $email, password: $password})
            RETURN u
            """,
            email=email,
            password=password
        )
        record = result.single()

    # 3. Auth logic
    if not record:
        handler.respond(401, {
            "success": False,
            "message": "Invalid credentials"
        })
        return

    # 4. Success
    user_node = record["u"]
    handler.respond(200, {
        "name": user_node["name"],
        "email": user_node["email"],
        "birthday": user_node["birthday"],
        "profilePicture": user_node.get("profilePicturePath"),
        "bannerPicture": user_node.get("bannerPicturePath")
    })