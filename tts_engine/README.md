# JAROOS Piper TTS Neural Voice Synthesis Engine

This directory contains the integration of **Piper TTS** ([`https://github.com/rhasspy/piper`](https://github.com/rhasspy/piper)) for low-latency, real-time child and cartoon neural voice generation in JAROOS using ONNX Runtime.

## Architecture & Benefits
- **Pure ONNX Runtime Execution**: Real-time factor < 0.1x (speech synthesizes in ~100-200ms).
- **Zero PyTorch GPU Dependency**: Runs blazingly fast on CPUs across Windows, Linux, Android, and macOS.
- **Child & Talking Tom Formant Pitch Modulation**: Dynamically modulates speech rate and formants for lively cartoon, mascot, and cat voices.
- **Offline Resilient**: Seamless zero-latency fallback to Flutter device native TTS if server is offline.

## Quick Start

### 1. Requirements
Ensure Python 3.10+ is available:
```bash
pip install -r requirements.txt
```

### 2. Launch Server
Double-click `start_server.bat` or run:
```bash
python server.py --port 5002
```

The server listens on `http://localhost:5002` (or `http://10.0.2.2:5002` from Android emulator).

## API Endpoints

| Endpoint | Method | Description |
|---|---|---|
| `/api/health` | GET | Health status, active model, and engine version |
| `/api/voices` | GET | List available child personas and profiles |
| `/api/tts?text=...&persona=...` | GET | Synthesizes speech and streams 22.05 kHz audio/wav |
| `/api/tts` | POST | JSON synthesis with `{ "text": "...", "persona": "...", "speed": 1.0 }` |

## Available Voice Personas
- `sparky_kid`: High-pitched cheerful child mascot
- `talking_tom`: Comical high-pitched repeating cat voice
- `dora_explorer`: Adventurous, bilingual cadence
- `sweet_lily`: Gentle, soothing bedtime story narrator
- `cheerful_leo`: Friendly, upbeat playground buddy
- `teacher_emma`: Clear, instructive teacher voice
- `robo_buddy`: Playful animated robotic companion
- `aarav_kid`: Indian Hindi-English child voice
- `unni_kid`: Kerala Malayalam-English child voice
