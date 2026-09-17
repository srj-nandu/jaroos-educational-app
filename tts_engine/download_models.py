"""
JAROOS Piper TTS Model Downloader
Downloads Piper ONNX neural voice models directly from HuggingFace
into the project folder (tts_engine/models/).
"""

import os
import sys
import argparse
import urllib.request
from pathlib import Path

# Ensure UTF-8 output on Windows
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8")
        sys.stderr.reconfigure(encoding="utf-8")
    except Exception:
        pass

MODELS_DIR = Path(__file__).resolve().parent / "models"

# Registry of supported Piper models from rhasspy/piper-voices
PIPER_MODEL_REGISTRY = {
    "en_US-lessac-medium": {
        "name": "en_US-lessac-medium",
        "description": "Clear American English (Default JAROOS Mascot & Talking Tom)",
        "quality": "medium (22.05 kHz)",
        "language": "en_US",
        "onnx_url": "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx",
        "json_url": "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/lessac/medium/en_US-lessac-medium.onnx.json",
    },
    "en_US-amy-medium": {
        "name": "en_US-amy-medium",
        "description": "Warm English Teacher & Bedtime Story Narrator",
        "quality": "medium (22.05 kHz)",
        "language": "en_US",
        "onnx_url": "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/amy/medium/en_US-amy-medium.onnx",
        "json_url": "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/amy/medium/en_US-amy-medium.onnx.json",
    },
    "en_US-danny-low": {
        "name": "en_US-danny-low",
        "description": "Playful Energetic Boy Voice (Leo & Buddy)",
        "quality": "low (16 kHz)",
        "language": "en_US",
        "onnx_url": "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/danny/low/en_US-danny-low.onnx",
        "json_url": "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/danny/low/en_US-danny-low.onnx.json",
    },
    "en_US-kathleen-low": {
        "name": "en_US-kathleen-low",
        "description": "Gentle Kind Preschool Companion (Sweet Lily)",
        "quality": "low (16 kHz)",
        "language": "en_US",
        "onnx_url": "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/kathleen/low/en_US-kathleen-low.onnx",
        "json_url": "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_US/kathleen/low/en_US-kathleen-low.onnx.json",
    },
}

def download_file_with_progress(url: str, dest_path: Path, label: str):
    """Downloads a file showing live progress."""
    req = urllib.request.Request(url, headers={"User-Agent": "JAROOS-Downloader/1.0"})
    
    with urllib.request.urlopen(req) as response, open(dest_path, "wb") as out_file:
        total_size = int(response.headers.get("content-length", 0))
        downloaded = 0
        chunk_size = 1024 * 512  # 512 KB chunks

        print(f"  Downloading {label} ({total_size / (1024 * 1024):.1f} MB)...")
        while True:
            chunk = response.read(chunk_size)
            if not chunk:
                break
            out_file.write(chunk)
            downloaded += len(chunk)
            if total_size > 0:
                percent = downloaded * 100 / total_size
                mb = downloaded / (1024 * 1024)
                sys.stdout.write(f"\r    [{percent:5.1f}%] {mb:5.1f} MB / {total_size / (1024 * 1024):.1f} MB")
                sys.stdout.flush()
        sys.stdout.write("\n")

def download_model(model_key: str, force: bool = False) -> bool:
    """Downloads both the .onnx and .onnx.json files for a registered model."""
    if model_key not in PIPER_MODEL_REGISTRY:
        print(f"[ERROR] Unknown model '{model_key}'. Available models:")
        for k in PIPER_MODEL_REGISTRY:
            print(f"  - {k}")
        return False

    info = PIPER_MODEL_REGISTRY[model_key]
    MODELS_DIR.mkdir(parents=True, exist_ok=True)
    
    onnx_dest = MODELS_DIR / f"{info['name']}.onnx"
    json_dest = MODELS_DIR / f"{info['name']}.onnx.json"

    print(f"\n[JAROOS Model Downloader] Model: {info['name']}")
    print(f"Description: {info['description']}")
    print(f"Quality:     {info['quality']}")

    # 1. Download JSON config
    if json_dest.exists() and not force:
        print(f"  Config JSON already exists: {json_dest.name}")
    else:
        try:
            download_file_with_progress(info["json_url"], json_dest, f"{info['name']}.onnx.json")
        except Exception as e:
            print(f"[ERROR] Failed to download JSON: {e}")
            return False

    # 2. Download ONNX model weights
    if onnx_dest.exists() and not force:
        print(f"  ONNX weights already exist: {onnx_dest.name} ({onnx_dest.stat().st_size / (1024*1024):.1f} MB)")
    else:
        try:
            download_file_with_progress(info["onnx_url"], onnx_dest, f"{info['name']}.onnx")
        except Exception as e:
            print(f"[ERROR] Failed to download ONNX: {e}")
            return False

    print(f"[SUCCESS] Model '{info['name']}' ready in {MODELS_DIR}!\n")
    return True

def list_models():
    """Prints all models and their download status."""
    MODELS_DIR.mkdir(parents=True, exist_ok=True)
    print("\n===========================================================")
    print("  JAROOS Piper Voice Model Catalog")
    print("===========================================================")
    for key, info in PIPER_MODEL_REGISTRY.items():
        onnx_file = MODELS_DIR / f"{info['name']}.onnx"
        status = "[DOWNLOADED]" if onnx_file.exists() else "[NOT DOWNLOADED]"
        size = f"({onnx_file.stat().st_size / (1024*1024):.1f} MB)" if onnx_file.exists() else ""
        print(f"• {info['name']:<22} {status:<18} {size}")
        print(f"  Desc: {info['description']}")
        print(f"  Quality: {info['quality']}\n")
    print("===========================================================\n")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="JAROOS Piper TTS Model Downloader")
    parser.add_argument("--model", type=str, default=None, help="Specific model to download")
    parser.add_argument("--all", action="store_true", help="Download all registered models")
    parser.add_argument("--list", action="store_true", help="List all available models and status")
    parser.add_argument("--force", action="store_true", help="Force redownload even if exists")
    args = parser.parse_args()

    if args.list or (not args.model and not args.all):
        list_models()
        if not args.model and not args.all:
            print("Run with: python download_models.py --model <name>")
            print("Or download all: python download_models.py --all")
            sys.exit(0)

    if args.all:
        for m in PIPER_MODEL_REGISTRY:
            download_model(m, force=args.force)
    elif args.model:
        download_model(args.model, force=args.force)
