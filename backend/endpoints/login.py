import json
from endpoints.util import get_json_body

def handle_login(handler):
    try:
        data = get_json_body(handler)
    except json.JSONDecodeError:
        handler.respond(400, {"error": "Invalid JSON"})
        return

    handler.respond(200, {"success": True})