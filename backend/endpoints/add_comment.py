import json
from endpoints.util import get_json_body, get_db_session

def handle_add_comment(handler):
    try:
        data = get_json_body(handler)
    except json.JSONDecodeError:
        return handler.respond(400, {"error": "Invalid JSON"})

    email = data.get("email")
    title = data.get("title")
    description = data.get("description")

    if not all([email, title, description]):
        return handler.respond(400, {"error": "Missing values"})

    with get_db_session() as session:
        session.run(
            """
            MATCH (u:User {email: $email}), (p:Post {title: $title})
            CREATE (u)-[:COMMENTED]->(c:Comment {description: $description})-[:ON]->(p)
            """,
            email=email,
            title=title,
            description=description
        )

    handler.respond(200, {"message": "Comment added"})