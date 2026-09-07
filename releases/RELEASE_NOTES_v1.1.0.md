# JAROOS v1.1.0 Release Notes 🚀🌟

We are thrilled to announce **JAROOS v1.1.0**, featuring a complete visual redesign matching modern gamified learning experiences (Duolingo-style stepping stones), humanized child-friendly voice synthesis, persistent bottom navigation, and dual build variants for real-world global users and examiners/evaluators!

---

## 🌟 What's New in v1.1.0

### 1. 🎙️ Humanized Voice & Speech Engine
- **Natural Cadence & Neural Selection**: Upgraded `TtsService` to dynamically prioritize high-clarity neural/natural voices (`en-us-x-sfg-network`, `neural`, `natural`).
- **Child-Friendly Prosody**: Calibrated cheerful pitch (`1.08`) and conversational speech rate (`0.44`).
- **Breath Pauses & Phoneme Clarity**: Built-in micro-pauses at punctuation marks (`...`, `!`, `,`, `:`) to sound expressive, warm, and human-like rather than robotic.

### 2. 🎨 Modern Duolingo-Style UI Redesign
- **Screen 1: Meadow Welcome Screen**
  - Scenic layered meadow hills and 3D pedestal with hero mascot.
  - Floating reward badges (coin, star, shield, checkmark).
  - Deep forest green bottom sheet with smooth scalloped cloud border.
  - Bold typography: *"Learn & Play. Level Up Your World."* with *"Start Learning"* pill CTA.
- **Screen 2: Modern Learning Dashboard**
  - Top header capsules: Streak (🔥 7) and Gems (💎 320) with notification/parent gate bell.
  - Personal greeting: *"Hey, Aria!"* with mascot avatar and level sprout badge.
  - 3 Gamified Stat Cards: Streak (7 days), XP (320 Total XP), and League (Silver Top 12%).
  - Dark forest green *"Continue Learning"* hero card with lesson progress bar and character companions.
  - *"Today's Goal"* capsule (12/20 min) with bonus gift chest (+20 XP).
  - *"Quick Practice"* interactive module carousel (Alphabet, Numbers, Colors, Animals, Stories).
- **Screen 3: Stepping Stones Learning Path**
  - Duolingo-style winding S-curve stepping stones path.
  - Diverse interactive node types: completed checkmarks, book lessons, mystery reward chests (awarding 20 coins), and locked nodes.
  - Active audio node with bouncing *"Start"* tooltip and pulse animation.

### 3. 🧭 Persistent Bottom Navigation Bar
- Seamless 5-tab persistent bottom bar powered by `IndexedStack`:
  - 🏠 **Home**: Daily dashboard, streak, goals, and quick practice.
  - 📖 **Courses**: Duolingo-style winding learning path and units.
  - 🤹 **Practice**: Quick activities (Alphabet, Numbers, Shapes, Colors, etc.).
  - 📊 **Progress**: Visual mastery bars, XP history, and trophy room.
  - 👤 **Profile**: Child avatar, badges, daily goals, and parent gate access.

### 4. 📦 Dual APK Distribution Flavors
We now provide two dedicated APK builds tailored for distinct audiences:

1. **`JAROOS-Global.apk` (For New / Global Users)**:
   - Completely clean state for real-world children and new parents.
   - Starts at **0 Streak**, **0 Coins**, and fresh unpolluted progress.
   - Full onboarding flow with age selection and fresh account registration.

2. **`JAROOS-Testing.apk` (For Testing, Viva Evaluation & Examiners)**:
   - Pre-populated demonstration profile (**Aria**, **7-day streak**, **320 XP**, **Silver League**).
   - Pre-unlocked learning path nodes for immediate hands-on exploration.
   - Quick 1-tap **Demo Login** (`learner@jaroos.com` / `Learner@123`) and instant Parent PIN (`1234`).

---

## 🧪 Test Verification
- **52 / 52 Automated Tests Passing** (100% pass rate).
- Verified unit tests for TTS prosody, AuthProvider, ParentProvider PIN security, and widget navigation.

---

## 📥 Download Links
- **Global Release**: `JAROOS-Global.apk` (Clean new-user experience)
- **Testing Release**: `JAROOS-Testing.apk` (Pre-populated evaluation experience)
