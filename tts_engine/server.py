"""
JAROOS Piper TTS Neural Voice Synthesis Server
Powered by Rhasspy Piper (https://github.com/rhasspy/piper)

High-performance, low-latency neural text-to-speech engine using ONNX Runtime.
Supports dynamic model switching and web model downloads into the project folder.
"""

import sys
import os
import io
import wave
import math
import struct
import argparse
from pathlib import Path
from http.server import HTTPServer, BaseHTTPRequestHandler
import urllib.parse
import json
import urllib.request

# Ensure UTF-8 output on Windows console
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass

# Import model registry and downloader
sys.path.insert(0, str(Path(__file__).resolve().parent))
try:
    from download_models import PIPER_MODEL_REGISTRY, download_model
except ImportError:
    PIPER_MODEL_REGISTRY = {}
    download_model = lambda m, force=False: False

MODELS_DIR = Path(__file__).resolve().parent / "models"
DEFAULT_MODEL_NAME = "en_US-lessac-medium"
active_model_name = DEFAULT_MODEL_NAME

PIPER_AVAILABLE = False
loaded_voices = {}  # Cache of model_name -> PiperVoice

# Persona to pitch / speed profiles
CHILD_VOICE_PROFILES = {
    "sparky_kid": {"pitch_shift": 1.35, "length_scale": 0.90, "desc": "Energetic curious child mascot"},
    "talking_tom": {"pitch_shift": 1.55, "length_scale": 0.85, "desc": "Classic high-pitched funny repeater cat"},
    "dora_explorer": {"pitch_shift": 1.30, "length_scale": 0.92, "desc": "Bilingual enthusiastic adventurer"},
    "sweet_lily": {"pitch_shift": 1.25, "length_scale": 0.95, "desc": "Gentle kind preschool friend"},
    "cheerful_leo": {"pitch_shift": 1.20, "length_scale": 0.92, "desc": "Playful energetic boy buddy"},
    "teacher_emma": {"pitch_shift": 1.05, "length_scale": 1.05, "desc": "Patient warm phonics teacher"},
    "robo_buddy": {"pitch_shift": 0.92, "length_scale": 1.00, "desc": "Futuristic friendly robot helper"},
    "aarav_kid": {"pitch_shift": 1.35, "length_scale": 0.90, "desc": "Lively Hindi/English companion"},
    "unni_kid": {"pitch_shift": 1.35, "length_scale": 0.90, "desc": "Cheerful Malayalam/English friend"},
    "pari_story": {"pitch_shift": 1.20, "length_scale": 1.00, "desc": "Soothing Hindi storyteller"},
    "meenu_story": {"pitch_shift": 1.20, "length_scale": 1.00, "desc": "Calm Malayalam fairy storyteller"},
    "appu_elephant": {"pitch_shift": 0.85, "length_scale": 1.10, "desc": "Friendly giant jungle elephant"},
}

def get_piper_voice(model_name: str = None):
    """Retrieves or loads a PiperVoice instance by model name."""
    global PIPER_AVAILABLE
    target_name = model_name or active_model_name
    
    if target_name in loaded_voices:
        return loaded_voices[target_name]

    onnx_path = MODELS_DIR / f"{target_name}.onnx"
    json_path = MODELS_DIR / f"{target_name}.onnx.json"

    # If model is not downloaded yet, try auto-downloading it from web
    if not onnx_path.exists() or not json_path.exists():
        print(f"[Piper TTS] Model {target_name} not found locally. Attempting download from web...")
        if not download_model(target_name):
            print(f"[Piper TTS Warning] Could not download {target_name}. Falling back to default model.")
            target_name = DEFAULT_MODEL_NAME
            onnx_path = MODELS_DIR / f"{target_name}.onnx"

    if onnx_path.exists():
        try:
            from piper import PiperVoice
            print(f"[Piper TTS] Loading ONNX voice model: {target_name}...")
            voice = PiperVoice.load(str(onnx_path))
            loaded_voices[target_name] = voice
            PIPER_AVAILABLE = True
            print(f"[Piper TTS] Successfully loaded '{target_name}'! Sample rate: {voice.config.sample_rate} Hz")
            return voice
        except Exception as e:
            print(f"[Piper TTS Error] Failed loading model {target_name}: {e}")

    return None

def pitch_shift_pcm(raw_bytes: bytes, pitch_factor: float = 1.0) -> bytes:
    """High-quality pitch shifting via linear interpolation resampling of 16-bit PCM."""
    if pitch_factor == 1.0 or not raw_bytes:
        return raw_bytes
    factor = max(0.5, min(2.5, pitch_factor))
    samples = struct.unpack(f"<{len(raw_bytes)//2}h", raw_bytes)
    out_len = int(len(samples) / factor)
    if out_len == 0:
        return raw_bytes
    
    out_samples = []
    for i in range(out_len):
        src_pos = i * factor
        idx = int(src_pos)
        frac = src_pos - idx
        if idx + 1 < len(samples):
            val = samples[idx] * (1.0 - frac) + samples[idx + 1] * frac
        else:
            val = samples[min(idx, len(samples) - 1)]
        out_samples.append(max(-32768, min(32767, int(val))))
    return struct.pack(f"<{len(out_samples)}h", *out_samples)

def generate_fallback_wav(text: str, pitch_multiplier: float = 1.35, speed: float = 1.0) -> bytes:
    """Generates clean harmonic modulated waveform if ONNX model is unready."""
    sample_rate = 22050
    duration_per_char = 0.055 / max(0.5, speed)
    total_duration = max(0.4, min(15.0, len(text) * duration_per_char))
    num_samples = int(sample_rate * total_duration)
    base_freq = 280.0 * max(0.6, min(2.5, pitch_multiplier))

    wav_io = io.BytesIO()
    with wave.open(wav_io, 'wb') as wav_file:
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)

        raw_frames = bytearray()
        for i in range(num_samples):
            t = float(i) / sample_rate
            syllable_mod = 0.6 + 0.4 * math.sin(2.0 * math.pi * 5.0 * t)
            env = min(1.0, t * 20.0) * min(1.0, (total_duration - t) * 15.0)

            f1 = math.sin(2.0 * math.pi * base_freq * t)
            f2 = 0.4 * math.sin(2.0 * math.pi * (base_freq * 2.02) * t)
            f3 = 0.2 * math.sin(2.0 * math.pi * (base_freq * 3.01) * t)

            sample_val = (f1 + f2 + f3) * syllable_mod * env * 0.45
            sample_val = max(-1.0, min(1.0, sample_val))
            int_sample = int(sample_val * 32767.0)
            raw_frames.extend(struct.pack('<h', int_sample))

        wav_file.writeframes(raw_frames)

    return wav_io.getvalue()

def synthesize_audio(text: str, persona_id: str = "sparky_kid", speed: float = 1.0, model_name: str = None) -> bytes:
    """Synthesizes high-fidelity 22.05 kHz WAV audio using Piper TTS ONNX model."""
    profile = CHILD_VOICE_PROFILES.get(persona_id, CHILD_VOICE_PROFILES["sparky_kid"])
    pitch = profile.get("pitch_shift", 1.0)
    length_scale = profile.get("length_scale", 1.0) / max(0.5, min(2.0, speed))

    voice = get_piper_voice(model_name)

    if voice is not None:
        try:
            from piper import SynthesisConfig
            syn_config = SynthesisConfig(length_scale=length_scale)
            
            raw_wav_io = io.BytesIO()
            with wave.open(raw_wav_io, "wb") as wav_file:
                voice.synthesize_wav(text, wav_file, syn_config=syn_config)
            
            raw_wav_bytes = raw_wav_io.getvalue()
            
            # If pitch shift is requested for persona (e.g. Talking Tom / Sparky Kid)
            if pitch != 1.0:
                with wave.open(io.BytesIO(raw_wav_bytes), "rb") as orig_wav:
                    params = orig_wav.getparams()
                    frames = orig_wav.readframes(orig_wav.getnframes())
                
                shifted_frames = pitch_shift_pcm(frames, pitch_factor=pitch)
                
                out_io = io.BytesIO()
                with wave.open(out_io, "wb") as shifted_wav:
                    shifted_wav.setparams(params)
                    shifted_wav.writeframes(shifted_frames)
                return out_io.getvalue()
            
            return raw_wav_bytes
        except Exception as err:
            print(f"[Piper TTS Synthesis Error] {err}. Using fallback waveform.")

    return generate_fallback_wav(text, pitch_multiplier=pitch, speed=speed)

def get_models_status():
    """Returns a list of registered models with download status and file sizes."""
    models_info = []
    for key, val in PIPER_MODEL_REGISTRY.items():
        onnx_file = MODELS_DIR / f"{key}.onnx"
        downloaded = onnx_file.exists()
        size_mb = round(onnx_file.stat().st_size / (1024 * 1024), 1) if downloaded else 0.0
        models_info.append({
            "id": key,
            "name": val.get("name", key),
            "description": val.get("description", ""),
            "quality": val.get("quality", ""),
            "downloaded": downloaded,
            "size_mb": size_mb,
            "is_active": (key == active_model_name),
        })
    return models_info

class PiperTtsHandler(BaseHTTPRequestHandler):
    def _send_cors_headers(self):
        self.send_header("Access-Control-Allow-Origin", "*")
        self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")

    def do_OPTIONS(self):
        self.send_response(204)
        self._send_cors_headers()
        self.end_headers()

    def do_GET(self):
        global active_model_name
        parsed = urllib.parse.urlparse(self.path)
        path = parsed.path
        query = urllib.parse.parse_qs(parsed.query)

        if path in ["/api/health", "/health"]:
            self.send_response(200)
            self._send_cors_headers()
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            downloaded = [f.stem for f in MODELS_DIR.glob("*.onnx")] if MODELS_DIR.exists() else []
            response = {
                "status": "ok",
                "service": "JAROOS Piper TTS Neural Engine",
                "repo": "https://github.com/rhasspy/piper",
                "engine": "piper-tts",
                "engine_loaded": PIPER_AVAILABLE or (len(loaded_voices) > 0),
                "active_model": active_model_name,
                "downloaded_models": downloaded,
                "sample_rate": 22050,
                "personas": list(CHILD_VOICE_PROFILES.keys()),
            }
            self.wfile.write(json.dumps(response).encode("utf-8"))

        elif path == "/api/models":
            self.send_response(200)
            self._send_cors_headers()
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            response = {
                "active_model": active_model_name,
                "models": get_models_status(),
            }
            self.wfile.write(json.dumps(response).encode("utf-8"))

        elif path == "/api/voices":
            self.send_response(200)
            self._send_cors_headers()
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps(CHILD_VOICE_PROFILES).encode("utf-8"))

        elif path in ["/api/tts", "/synthesize"]:
            text = query.get("text", ["Hello from JAROOS!"])[0]
            persona = query.get("persona", ["sparky_kid"])[0]
            model_req = query.get("model", [None])[0]
            try:
                speed = float(query.get("speed", ["1.0"])[0])
            except ValueError:
                speed = 1.0

            audio_data = synthesize_audio(text, persona_id=persona, speed=speed, model_name=model_req)

            self.send_response(200)
            self._send_cors_headers()
            self.send_header("Content-Type", "audio/wav")
            self.send_header("Content-Length", str(len(audio_data)))
            self.send_header("Cache-Control", "public, max-age=3600")
            self.end_headers()
            self.wfile.write(audio_data)

        else:
            self.send_response(404)
            self._send_cors_headers()
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"error": "Endpoint not found"}).encode("utf-8"))

    def do_POST(self):
        global active_model_name
        parsed = urllib.parse.urlparse(self.path)
        content_len = int(self.headers.get("Content-Length", 0))
        body = self.rfile.read(content_len).decode("utf-8") if content_len > 0 else "{}"
        try:
            payload = json.loads(body)
        except Exception:
            payload = {}

        if parsed.path in ["/api/models/download", "/api/model/download"]:
            model_to_download = payload.get("model", DEFAULT_MODEL_NAME)
            success = download_model(model_to_download)
            self.send_response(200 if success else 500)
            self._send_cors_headers()
            self.send_header("Content-Type", "application/json")
            self.end_headers()
            self.wfile.write(json.dumps({
                "status": "ok" if success else "error",
                "model": model_to_download,
                "downloaded": success,
                "models": get_models_status(),
            }).encode("utf-8"))

        elif parsed.path in ["/api/models/select", "/api/model/select"]:
            model_to_select = payload.get("model", DEFAULT_MODEL_NAME)
            voice = get_piper_voice(model_to_select)
            if voice is not None:
                active_model_name = model_to_select
                self.send_response(200)
                self._send_cors_headers()
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({
                    "status": "ok",
                    "active_model": active_model_name,
                }).encode("utf-8"))
            else:
                self.send_response(400)
                self._send_cors_headers()
                self.send_header("Content-Type", "application/json")
                self.end_headers()
                self.wfile.write(json.dumps({"error": f"Model {model_to_select} could not be loaded."}).encode("utf-8"))

        elif parsed.path in ["/api/tts", "/synthesize"]:
            text = payload.get("text", "Hello from JAROOS!")
            persona = payload.get("persona", "sparky_kid")
            speed = float(payload.get("speed", 1.0))
            model_req = payload.get("model", None)

            audio_data = synthesize_audio(text, persona_id=persona, speed=speed, model_name=model_req)

            self.send_response(200)
            self._send_cors_headers()
            self.send_header("Content-Type", "audio/wav")
            self.send_header("Content-Length", str(len(audio_data)))
            self.end_headers()
            self.wfile.write(audio_data)
        else:
            self.send_response(404)
            self._send_cors_headers()
            self.end_headers()

def run_server(port=5002):
    # Pre-load default voice model
    get_piper_voice(DEFAULT_MODEL_NAME)
    server_address = ('0.0.0.0', port)
    try:
        httpd = HTTPServer(server_address, PiperTtsHandler)
    except OSError as err:
        if getattr(err, 'winerror', None) == 10048 or "Address already in use" in str(err):
            print(f"[ERROR] Port {port} is already in use by another running process.")
            print(f"[TIP] Either close the running process or specify another port:")
            print(f"      python server.py --port 5003")
        else:
            print(f"[ERROR] Could not bind server to port {port}: {err}")
        return

    downloaded = [f.stem for f in MODELS_DIR.glob("*.onnx")] if MODELS_DIR.exists() else []
    print("===========================================================")
    print(f"[JAROOS] Piper TTS Server listening on http://0.0.0.0:{port}")
    print(f"[JAROOS] Engine: Piper Neural ONNX (rhasspy/piper)")
    print(f"[JAROOS] Active Model: {active_model_name}")
    print(f"[JAROOS] Downloaded Models: {downloaded}")
    print(f"[JAROOS] Health: http://localhost:{port}/api/health")
    print(f"[JAROOS] Models Catalog: http://localhost:{port}/api/models")
    print(f"[JAROOS] Synthesis: http://localhost:{port}/api/tts?text=Hello")
    print("===========================================================")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        print("\nStopping Piper TTS server...")
        httpd.server_close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="JAROOS Piper TTS Server")
    parser.add_argument("--port", type=int, default=5002, help="Port to listen on (default 5002)")
    parser.add_argument("--model", type=str, default=DEFAULT_MODEL_NAME, help="Model name to activate")
    args = parser.parse_args()
    active_model_name = args.model
    run_server(args.port)
