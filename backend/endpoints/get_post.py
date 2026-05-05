import json
from endpoints.util import get_json_body, get_db_session

def handle_get_posts_by_user(handler):
    # 1. Validate JSON
    try:
        data = get_json_body(handler)
    except json.JSONDecodeError:
        handler.respond(400, {"error": "Invalid JSON"})
        return

    email = data.get("email")
    if not email:
        handler.respond(400, {"error": "Missing userId"})
        return

    # 2. Query Neo4j
    with get_db_session() as session:
        result = session.run(
            """
            MATCH (u:User {email: $email})-[:POSTED]->(p:Post)
            RETURN p
            """,
            email=email
        )

        posts = [dict(record["p"]) for record in result]

    handler.respond(200, {"posts": posts})