# JAROOS v1.4.0 Release Notes 🚀🌟

We are proud to release **JAROOS v1.4.0 (Build 4)**, delivering our most advanced and delightful update yet! This release introduces the **Piper TTS Neural AI Voice Engine**, the all-new **Interactive Virtual Simulator ("Talking Tom" Kid Companion)**, and a **3D Jungle Adventure Animated Splash Screen**.

---

## 🌟 What's New in v1.2.0

### 1. 🎙️ Piper Neural Voice Synthesis Engine & Web Model Downloader
- **Ultra-Fast Local Piper ONNX Engine**: Replaced legacy bulky engines with high-efficiency Piper neural TTS running on ONNX Runtime (`onnxruntime` v1.30.0), synthesizing natural speech in under 150ms.
- **Web Model Downloader Integrated in Project**:
  - `tts_engine/download_models.py` & `tts_engine/download_models.bat` download neural models directly from HuggingFace (`rhasspy/piper-voices`) into `tts_engine/models/`.
  - Downloaded models include `en_US-lessac-medium` (high-quality child mascot & Talking Tom) and `en_US-amy-medium` (expressive bedtime story & teacher voice).
- **In-App Dynamic Voice Catalog & Download**:
  - Parent Dashboard feature: **Voice Models (Download from Web)**.
  - Parents can monitor downloaded models, check disk size, download new voice packs directly from the web, and activate models with one tap.
- **Real-Time Talking Tom Pitch Modulation**: High-speed digital signal processing pitch shifts raw 22.05 kHz PCM audio to deliver the signature hilarious Talking Tom voice mimicry.
- **Zero-Downtime Fallback**: If the microservice is offline, the app automatically and seamlessly falls back to the native device TTS engine.

### 2. 🐱 Interactive Virtual Simulator ("Talking Tom" Kid Companion)
- **3D Child-Friendly Character**: Adorable 3D cartoon kid buddy ready to play, learn, and laugh with children.
- **Voice Repeat ("Talking Tom" Mode)**: Speaks back what the child says with playful, cheerful voice mimicry.
- **Dynamic Physics Animations**: Continuous idle breathing, spring jump, squash-and-stretch belly wobble, and dance groove.
- **Interactive Multi-Zone Touch**:
  - 🖐️ **Hand**: High five (+5 Stars)!
  - 🦱 **Hair/Head**: Tickle chuckle and head shake.
  - 😊 **Cheeks**: Blushing pet reaction with floating hearts.
  - 👕 **Tummy**: Elastic tickle wobble.
  - 👟 **Feet**: Bouncing sneaker jump.
- **Snack Feeding**: Feed delicious pizza 🍕, apples 🍎, and cookies 🍪 with munching sound effects.
- **AI STEM Curiosity Companion**: Ask questions like *"Why is the sky blue?"* or *"How do birds fly?"* and the character speaks the answers.
- **Dress-Up Accessories**: Toggle cool sunglasses 😎 and golden royal crown 👑.

### 3. 🦁 3D Jungle Adventure Animated Splash Screen
- **Disney/Pixar Style Artwork**: Lion cub, monkey, parrot, deer, squirrels, secret waterfall, and rainforest canopy.
- **Living Nature Animations**: Breathing parallax camera zoom, fluttering tropical butterflies, cascading waterfall mist, dappled sunbeams, glowing fireflies, and interactive touch sparkles.

### 4. 🗄️ Organized Release Archive
- Cleaned and organized the `releases/` directory.
- Legacy v1.0.0 APKs moved to `releases/archive/` for historical reference.

---

## 📱 Release Binaries
- **Global Release APK**: `releases/JAROOS-Global.apk`
- **Testing / Evaluation APK**: `releases/JAROOS-Testing.apk`
- **Versioned APK**: `releases/JAROOS-v1.4.0-release.apk`
