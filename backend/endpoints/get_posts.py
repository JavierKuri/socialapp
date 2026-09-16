import json
from endpoints.util import get_json_body, get_db_session

def handle_get_posts(handler):
    # 1. Validate JSON
    try:
        data = get_json_body(handler)
    except json.JSONDecodeError:
        handler.respond(400, {"error": "Invalid JSON"})
        return

    # 2. Query Neo4j
    with get_db_session() as session:
        result = session.run(
            """
            MATCH (u:User)-[:POSTED]->(p:Post)
            RETURN p
            """
        )

        posts = [dict(record["p"]) for record in result]

    handler.respond(200, {"posts": posts})