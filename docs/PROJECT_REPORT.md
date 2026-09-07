# JAROOS: Interactive Educational Application for Early Childhood Learning
**A Major Project Report Submitted in Partial Fulfillment of the Requirements for the Degree of**  
### MASTER OF COMPUTER APPLICATIONS (MCA)

---

## 📑 TABLE OF CONTENTS

1. [CHAPTER 1: INTRODUCTION & OVERVIEW](#chapter-1-introduction--overview)
   - 1.1 Project Background
   - 1.2 Problem Statement
   - 1.3 Objectives of the Project
   - 1.4 Scope and Limitations
2. [CHAPTER 2: LITERATURE SURVEY & FEASIBILITY ANALYSIS](#chapter-2-literature-survey--feasibility-analysis)
   - 2.1 Study of Existing Systems
   - 2.2 Comparative Analysis
   - 2.3 Feasibility Study (Technical, Operational, Economic)
3. [CHAPTER 3: SOFTWARE REQUIREMENT SPECIFICATION (SRS)](#chapter-3-software-requirement-specification-srs)
   - 3.1 User Characteristics & Persona
   - 3.2 Functional Requirements
   - 3.3 Non-Functional Requirements
   - 3.4 Hardware and Software Prerequisites
4. [CHAPTER 4: SYSTEM DESIGN & ARCHITECTURE](#chapter-4-system-design--architecture)
   - 4.1 High-Level System Architecture
   - 4.2 Data Flow Diagrams (DFD Level 0, Level 1)
   - 4.3 Entity-Relationship (ER) Diagram
   - 4.4 Component & State Management Design
5. [CHAPTER 5: IMPLEMENTATION DETAILS & ALGORITHMS](#chapter-5-implementation-details--algorithms)
   - 5.1 Early Learning Modules Implementation
   - 5.2 Academic Scoring & Stars Calculation Algorithm
   - 5.3 Modular Text-to-Speech & Speech Synthesis
   - 5.4 AI Curiosity Engine & Child Safety Moderation Filter
   - 5.5 Backend REST API & Database Integration
6. [CHAPTER 6: TESTING METHODOLOGY & VERIFICATION](#chapter-6-testing-methodology--verification)
   - 6.1 Testing Strategy (Unit, Widget, Integration)
   - 6.2 Test Case Specifications & Results
7. [CHAPTER 7: CONCLUSION & FUTURE ENHANCEMENTS](#chapter-7-conclusion--future-enhancements)
   - 7.1 Conclusion
   - 7.2 Future Scope

---

## CHAPTER 1: INTRODUCTION & OVERVIEW

### 1.1 Project Background
Early childhood education (ages 3 to 8 years) represents the most critical developmental window for neuroplasticity, phonemic awareness, and foundational numeracy. While digital mobile devices are increasingly accessible to families, the vast majority of existing children's applications suffer from intrusive advertisements, complex adult-oriented navigation, lack of educational scaffolding, or violent content that can lead to digital fatigue. 

**JAROOS** (Learn • Play • Grow) was conceived to address these shortcomings by delivering an ad-free, child-centric Android educational ecosystem adhering to modern human-computer interaction (HCI) standards for toddlers and pre-schoolers.

### 1.2 Problem Statement
Traditional mobile educational apps exhibit key limitations:
- **Commercial Ad Infiltration**: Young children inadvertently click third-party banners, exposing them to tracking and age-inappropriate media.
- **Cognitive Overload**: Cluttered user interfaces with tiny touch targets (<40dp) frustrate toddlers who lack fine motor control.
- **Absence of Parental Oversight**: Parents lack direct visibility into daily screen time, learning streaks, and subject mastery.
- **Monolithic Online Dependency**: Many apps fail to function when mobile data or Wi-Fi is unavailable in rural or travel settings.

### 1.3 Objectives of the Project
1. Build an offline-capable, cross-platform Android application using **Flutter (Material 3)**.
2. Deliver **10 core learning modules**: Phonics Alphabet, Counting 1–20, Colors & Mixing, 2D Geometric Shapes, Animals with sound onomatopoeia, Nutritional Fruits & Veggies, Classic Bedtime Moral Tales, Sing-Along Rhymes, an Interactive Quiz Arena, and Progress Badges.
3. Integrate an AI Voice Companion (**Sparky AI Buddy**) and **AI Bedtime Story Generator** with strict child-safety content filtering.
4. Implement a dedicated **Parental Control Dashboard** protected by a dual-mode Parent Gate (4-digit PIN or adult math challenge) featuring digital wellness screen-time limiters and 7-day activity telemetry.
5. Provide a full-stack companion **Node.js/Express REST API** and **MySQL 8.0** relational database for authentication and cross-device telemetry sync.

---

## CHAPTER 2: LITERATURE SURVEY & FEASIBILITY ANALYSIS

### 2.1 Comparative Analysis with Existing Systems

| Metric / Feature | Commercial Kids Apps (ABCmouse, Khan Academy Kids) | Generic Video Platforms (YouTube Kids) | JAROOS (Proposed MCA System) |
|---|---|---|---|
| **Ad-Free Experience** | Requires costly recurring subscription ($12+/mo) | Contains algorithmic ads and influencer promotions | **100% Ad-Free, Walled Garden** |
| **Offline Capability** | Partial; requires online assets | None; stream-dependent | **100% Offline-First Architecture** |
| **Parent Gate Security** | Simple numeric prompts | Algorithmic restrictions only | **Dual-Mode: 4-digit PIN or Dynamic Adult Math Challenge** |
| **Generative AI Storytelling** | Static fixed storybooks | Passive video streaming | **Dynamic 3-Step Moral Bedtime Story Generator** |
| **Open Source / Self-Hosted** | Closed proprietary | Closed proprietary | **Fully Documented Open Architecture (Flutter + Express + MySQL)** |

### 2.2 Feasibility Study
- **Technical Feasibility**: Flutter 3.47+ compiles to native ARM64 Android binaries using Skia/Impeller, rendering smooth 60–120 FPS graphics on entry-level Android devices (API level 21+). Node.js v24 and MySQL 8.0 handle API concurrency using non-blocking asynchronous event loops.
- **Economic Feasibility**: Open-source frameworks eliminate commercial runtime licensing costs.
- **Operational Feasibility**: Minimal learning curve for young children through large pictograms, vibrant color cues, and auditory feedback.

---

## CHAPTER 3: SOFTWARE REQUIREMENT SPECIFICATION (SRS)

### 3.1 User Personas
1. **The Young Learner (Primary, Ages 3–8)**: Non-readers or emerging readers requiring large touch targets ($\ge 52\text{dp}$), phonics speech synthesis, and immediate gamification (coins, stars, trophy badges).
2. **The Parent / Educator (Secondary)**: Requires monitoring tools, digital wellness screen-time controls, audio narration speed tuners, and curriculum module visibility toggles.

### 3.2 Functional Requirements
- **FR-01 (Authentication)**: Register parent/child profile, login with email/password, simulated JWT session persistence, and 1-tap demo login for academic evaluation.
- **FR-02 (Early Learning Curriculum)**: 10 structured modules covering literacy, numeracy, spatial reasoning, biology, nutrition, and classic literature.
- **FR-03 (Audio Pronunciation)**: Text-to-Speech (TTS) integration across letters, numbers, vocabulary, and story narration.
- **FR-04 (Academic Quiz Engine)**: Multiple-choice quizzes with deterministic scoring: $\text{score} = \left(\frac{\text{correct}}{\text{total}}\right) \times 100$.
- **FR-05 (Gamified Economy)**: Award coins on lesson/quiz completion; unlock 10 milestone badges in the Trophy Room.
- **FR-06 (Parent Gate & Dashboard)**: Restrict configuration views behind PIN/math checks; provide daily usage limiters and 7-day usage charts.
- **FR-07 (Generative Story & AI Buddy)**: Inquire curious STEM questions; generate bedtime tales with moral takeaways.

### 3.3 Non-Functional Requirements
- **Performance**: Frame rate $\ge 60\text{ FPS}$; API response latency $< 150\text{ms}$.
- **Security**: Passwords hashed with 10 rounds of Bcrypt; stateless JWT tokens with 7-day expiration.
- **Reliability**: Graceful in-memory database fallback (`USE_MOCK_DB=true`) if MySQL server is absent.
- **Accessibility**: High-contrast child color palette complying with WCAG 2.1 AA guidelines.

---

## CHAPTER 4: SYSTEM DESIGN & ARCHITECTURE

### 4.1 High-Level Architecture
The project follows a **Decoupled Client-Server Tiered Architecture**:
1. **Presentation & Interaction Tier**: Flutter Material 3 reactive widget hierarchy.
2. **State Management & Domain Tier**: `ChangeNotifierProvider` stores (`AuthProvider`, `LearningProvider`, `ParentProvider`).
3. **Hardware Abstraction Tier**: TTS Engine, local SQLite/SharedPreferences caching.
4. **Network & API Tier**: Node.js, Express.js middleware, Bcrypt, JWT.
5. **Data Persistence Tier**: MySQL 8.0 relational tables (`users`, `progress`, `quiz_results`, `parent_settings`, `user_achievements`).

### 4.2 Data Flow Diagram (DFD)

#### Level 0 DFD (Context Diagram)
```
[ Child User ]  <---> [ JAROOS Mobile App ] <---> [ Node.js REST API ] <---> [ MySQL Database ]
[ Parent User ] <---> [ JAROOS Mobile App ]
```

#### Level 1 DFD (Module Interactions)
```
[ User Interaction ] 
       │
       ▼
[ UI Components (Screens/Widgets) ] 
       │
       ▼
[ State Management Providers ] 
       ├───────────────┬─────────────────┬──────────────────┐
       ▼               ▼                 ▼                  ▼
[ AuthProvider ] [ LearningProvider ] [ ParentProvider ] [ ModularAiService ]
       │               │                 │                  │
       ▼               ▼                 ▼                  │
[ Local Storage / Session (SharedPreferences) ]             │
       │                                                    │
       ▼ (Async REST API via JWT)                           │
[ Node.js / Express Server (Port 5000) ]                    │
       │                                                    │
       ▼                                                    │
[ MySQL 8.0 Relational Database (jaroos_db) ] <─────────────┘
```

### 4.3 Entity-Relationship (ER) Diagram
- **`users` (1) ── (1) `progress`**: One user maintains one holistic learning record.
- **`users` (1) ── (1) `parent_settings`**: One user maintains one parent configuration.
- **`users` (1) ── (N) `quiz_results`**: One user records multiple quiz attempts.
- **`users` (1) ── (N) `user_achievements`**: One user unlocks multiple badges.

---

## CHAPTER 5: IMPLEMENTATION DETAILS & ALGORITHMS

### 5.1 Academic Quiz Scoring Algorithm
The quiz engine calculates score percentage and assigns celebration stars using the following deterministic algorithm:

$$\text{scorePercentage} = \left(\frac{\text{correctAnswers}}{\text{totalQuestions}}\right) \times 100$$

$$\text{starsEarned} = \begin{cases} 
3 & \text{if } \text{scorePercentage} \ge 80 \\
2 & \text{if } 50 \le \text{scorePercentage} < 80 \\
1 & \text{if } 0 < \text{scorePercentage} < 50 \\
0 & \text{otherwise}
\end{cases}$$

$$\text{earnedCoins} = \text{correctAnswers} \times 10$$

### 5.2 Child Safety Moderation Algorithm
The `ModularAiService` evaluates incoming prompts through an algorithmic keyword interception pipeline prior to natural language response synthesis:

```dart
static const List<String> _safetyFilterKeywords = [
  'kill', 'die', 'blood', 'gun', 'fight', 'hate', 'stupid', 'ugly', 'scary',
  'monster', 'ghost', 'war', 'hurt', 'curse', 'bad', 'weapon'
];

Future<String> askJaroosBuddy(String question) async {
  final cleanPrompt = question.trim().toLowerCase();
  for (final word in _safetyFilterKeywords) {
    if (cleanPrompt.contains(word)) {
      return "That sounds a little scary! 🧸 Let's talk about something cheerful and bright, like cuddly animals, colorful rainbows, or twinkling stars! 🌟";
    }
  }
  // Safe prompt processing...
}
```

---

## CHAPTER 6: TESTING METHODOLOGY & VERIFICATION

### 6.1 Test Suite Breakdown

| Suite Name | Type | Target Class / Module | Test Count | Result |
|---|---|---|---|---|
| `auth_test.dart` | Unit & Widget | `AuthProvider`, `LoginScreen`, `RegisterScreen` | 6 | **Passed** |
| `early_learning_modules_test.dart` | Widget | Alphabet, Numbers, Colors, Shapes | 14 | **Passed** |
| `media_learning_modules_test.dart` | Widget | Animals, Fruits, Stories, Rhymes | 4 | **Passed** |
| `quiz_test.dart` | Unit & Widget | `QuizScreen`, Scoring formula | 5 | **Passed** |
| `progress_achievements_profile_test.dart` | Unit & Widget | Progress, Badges, Avatar switcher | 7 | **Passed** |
| `parent_dashboard_test.dart` | Unit & Widget | Parent Gate, PIN validation, Time limits | 6 | **Passed** |
| `ai_features_test.dart` | Unit & Widget | `AiBuddyScreen`, `AiStoryGeneratorScreen`, `AiService` | 8 | **Passed** |
| `widget_test.dart` | Integration | End-to-end navigation pipeline | 2 | **Passed** |
| `backend/test/api.test.js` | Integration | REST endpoints (Health, Auth, Progress, Parent) | 6 | **Passed** |
| **TOTAL** | | | **58 Tests** | **100% Green** |

---

## CHAPTER 7: CONCLUSION & FUTURE ENHANCEMENTS

### 7.1 Conclusion
The **JAROOS** application successfully satisfies all functional, architectural, and safety requirements specified for this MCA Major Project. By uniting child-centered UI design, robust state management, an offline-first modular architecture, an assistive generative AI storytelling engine, and a secure Node.js/MySQL backend, the platform demonstrates academic depth, practical engineering viability, and adherence to modern software design patterns.

### 7.2 Future Scope
1. **Automated Speech Recognition (ASR)**: On-device toddler phoneme recognition and speech articulation feedback using TensorFlow Lite.
2. **Augmented Reality (AR) Flashcards**: 3D interactive animals projecting onto physical flashcards using ARCore.
3. **Multi-Language Localization**: Expanding the phonetic alphabet and rhyme audio library to regional Indian languages (Hindi, Tamil, Telugu, Bengali).
