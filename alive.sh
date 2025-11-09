#!/usr/bin/env python3
import threading
import time
import http.server
import socketserver
from urllib.request import urlopen, Request
from urllib.error import URLError, HTTPError

# === Configuration ===
PORT = 8080
URL_TO_PING = "https://8080-cs-189e1c9b-6cf5-47e1-bea0-8227df035e5c.cs-asia-southeast1-yelo.cloudshell.dev/?authuser=0"
PING_INTERVAL = 40  # seconds

# === 1. Background pinger ===
def ping_loop():
    while True:
        try:
            req = Request(URL_TO_PING, headers={"User-Agent": "KeepAlive/1.0"})
            with urlopen(req, timeout=10) as resp:
                print(f"[OK] Pinged {URL_TO_PING} → HTTP {resp.status}")
        except (HTTPError, URLError, Exception) as e:
            print(f"[ERR] Ping failed: {e}")
        time.sleep(PING_INTERVAL)

# === 2. Simple local HTTP server (port 8080) ===
class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html; charset=utf-8")
        self.end_headers()
        self.wfile.write(b"<h1>✅ VPS is alive</h1>")
    def log_message(self, format, *args):
        return  # disable console logs

def start_http():
    with socketserver.TCPServer(("", PORT), Handler) as httpd:
        print(f"[INFO] HTTP server started on port {PORT}")
        httpd.serve_forever()

# === 3. Main ===
if __name__ == "__main__":
    print("[START] KeepAlive Server + Pinger running...")
    threading.Thread(target=ping_loop, daemon=True).start()
    start_http()
