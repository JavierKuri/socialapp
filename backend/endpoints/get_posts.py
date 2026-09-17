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
            RETURN p, u.email AS email
            """
        )

        posts = []
        for record in result:
            post_dict = dict(record["p"])          
            post_dict["email"] = record["email"]   
            posts.append(post_dict)

    handler.respond(200, {"posts": posts})