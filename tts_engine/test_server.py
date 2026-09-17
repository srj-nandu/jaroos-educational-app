import threading
import time
import urllib.request
import json
from server import HTTPServer, CoquiTtsHandler

def test_endpoints():
    server = HTTPServer(('127.0.0.1', 5003), CoquiTtsHandler)
    t = threading.Thread(target=server.serve_forever, daemon=True)
    t.start()
    time.sleep(0.5)

    try:
        # Test /api/health
        req = urllib.request.urlopen("http://127.0.0.1:5003/api/health")
        health = json.loads(req.read().decode('utf-8'))
        print("Health check status:", health.get("status"))
        print("Service:", health.get("service"))
        print("Repo:", health.get("repo"))
        assert health.get("status") == "ok"

        # Test /api/voices
        req = urllib.request.urlopen("http://127.0.0.1:5003/api/voices")
        voices = json.loads(req.read().decode('utf-8'))
        print("Available voices count:", len(voices))
        assert "sparky_kid" in voices

        # Test /api/tts
        url = "http://127.0.0.1:5003/api/tts?text=Welcome+to+JAROOS&persona=sparky_kid"
        req = urllib.request.urlopen(url)
        content_type = req.headers.get("Content-Type")
        audio_bytes = req.read()
        print(f"TTS Audio response: {len(audio_bytes)} bytes, Content-Type: {content_type}")
        assert content_type == "audio/wav"
        assert len(audio_bytes) > 1000
        # Check RIFF/WAVE header
        assert audio_bytes[:4] == b"RIFF"
        assert audio_bytes[8:12] == b"WAVE"
        print("All Coqui TTS server tests passed successfully!")
    finally:
        server.shutdown()
        server.server_close()

if __name__ == "__main__":
    test_endpoints()
