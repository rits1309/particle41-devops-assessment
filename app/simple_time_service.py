from http.server import BaseHTTPRequestHandler, HTTPServer
import json
from datetime import datetime

class Handler(BaseHTTPRequestHandler):

    def do_GET(self):
        if self.path == "/":
            data = {
                "timestamp": datetime.utcnow().isoformat(),
                "ip": self.client_address[0]
            }

            self.send_response(200)
            self.send_header("Content-Type", "application/json")
            self.end_headers()

            self.wfile.write(json.dumps(data).encode())

if __name__ == "__main__":
    server = HTTPServer(("0.0.0.0", 8080), Handler)
    server.serve_forever()