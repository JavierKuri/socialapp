import json
from endpoints.util import get_json_body, get_db_session

def handle_get_comments(handler):
    try:
        data = get_json_body(handler)
    except json.JSONDecodeError:
        return handler.respond(400, {"error": "Invalid JSON"})

    title = data.get("title")

    with get_db_session() as session:
        result = session.run(
            """
            MATCH (u:User)-[:COMMENTED]->(c:Comment)-[:ON]->(p:Post {title: $title})
            RETURN u.email AS email, c.description AS description
            """,
            title=title
        )

        comments = [
            {"email": record["email"], "description": record["description"]}
            for record in result
        ]

    handler.respond(200, {"comments": comments})