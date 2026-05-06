from http.server import BaseHTTPRequestHandler, HTTPServer
from endpoints.login import handle_login
from endpoints.signup import handle_signup
from endpoints.upload import handle_upload
from endpoints.get_image import handle_get_image
from endpoints.get_posts_by_user import handle_get_posts_by_user
import json

class MyHandler(BaseHTTPRequestHandler):

    def do_OPTIONS(self):
        self.send_response(200)
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def respond(self, status_code, data):
        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode("utf-8"))

    def do_GET(self):
        if self.path == "/":
            self.respond(200, {"message": "Hello from root"})
        elif self.path == "/health":
            self.respond(200, {"status": "ok"})
        else:
            self.respond(404, {"error": "Not found"})

    def do_POST(self):
        if self.path == "/login":
            handle_login(self)
        elif self.path == "/signup":
            handle_signup(self)
        elif self.path == "/upload":
            handle_upload(self)
        elif self.path == "/get_image":
            handle_get_image(self)
        elif self.path == "/get_posts_by_user":
            handle_get_posts_by_user(self)
        else:
            self.send_json(404, {"error": "Not found"})

def main():
    server = HTTPServer(("localhost", 8000), MyHandler)
    print("Server running on http://localhost:8000")
    server.serve_forever()

if __name__ == "__main__":
    main()