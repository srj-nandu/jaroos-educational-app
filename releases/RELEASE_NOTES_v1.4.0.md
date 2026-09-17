# JAROOS v1.4.0 Release Notes 🚀🌟

We are proud to release **JAROOS v1.4.0 (Build 4)**, delivering our most advanced and delightful update yet! This release introduces the **Piper TTS Neural AI Voice Engine**, the all-new **Interactive Virtual Simulator ("Talking Tom" Kid Companion)**, and a **3D Jungle Adventure Animated Splash Screen**.

---

## 🌟 What's New in v1.4.0

### 1. 🎙️ 100% On-Device Offline Piper Neural Voice Synthesis Engine
- **Completely Server-Free & Offline**: Removed all external Python servers, local microservices (`tts_engine/`), and server URL configurations (`http://10.0.2.2:5002`). The app runs 100% self-contained on the device with zero internet or server connection needed.
- **Precompiled Native Mobile ONNX Runtime (`sherpa_onnx`)**: Powered by high-efficiency int8-quantized Piper VITS models running directly on device CPU via native C++ binaries for Android (`arm64-v8a`, `armeabi-v7a`, `x86_64`).
- **Bundled Multi-Language Neural Voice Models**:
  - `en_US-lessac-medium` (18.5 MB): Default mascot (Sparky Kid) and Talking Tom.
  - `en_US-amy-medium` (18.7 MB): Warm English teacher (Emma) and bedtime story narrator.
  - `ml_IN-arjun-medium` (18.3 MB): Playful Malayalam child companion (Unni) and little explorer (Appu).
  - `ml_IN-meera-medium` (18.3 MB): Gentle Malayalam storyteller (Meenu).
  - `espeak-ng-data.zip` (8.7 MB): Shared phoneme dictionary for instant first-run on-device extraction.
- **Clean Parent Dashboard Experience**:
  - Removed server URLs, ping buttons, and fallback badges.
  - Replaced with a clean **100% Offline Piper Neural Engine** card with instant one-tap voice model activation.
- **Real-Time Talking Tom Pitch Modulation**: High-speed digital signal processing pitch shifts raw 22.05 kHz PCM audio to deliver hilarious Talking Tom voice caricature repeat mode directly on device.

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
