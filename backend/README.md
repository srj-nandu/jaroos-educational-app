# JAROOS – Backend REST API (Node.js + Express + MySQL)
**MCA Major Project: Academic Architecture & Viva Defense Reference**

JAROOS Backend provides a secure, lightweight, and extensible RESTful web service architecture designed to power mobile client progress synchronization, authentication, quiz telemetry, and parental controls for young learners.

---

## 🏗️ 1. Technology Stack
- **Runtime**: Node.js (v18+)
- **Framework**: Express.js (v4.x)
- **Database**: MySQL (v8.0+) via connection pool (`mysql2/promise`)
- **Offline / Viva Mode**: Built-in In-Memory Mock Store fallback (zero external setup required during viva defense)
- **Authentication**: JWT (JSON Web Tokens) with 7-day expiration
- **Security**: Bcrypt password hashing, parameter validation, child-safety PIN protection

---

## 🗄️ 2. Database Schema (MySQL)
The schema is defined in [`database/schema.sql`](./database/schema.sql) and contains 5 normalized tables:

1. **`users`**:
   - `id` (VARCHAR 36 UUID / Primary Key)
   - `email` (VARCHAR 255 UNIQUE)
   - `password_hash` (VARCHAR 255)
   - `child_name` (VARCHAR 100)
   - `child_age` (INT, CHECK 2–12)
   - `avatar` (VARCHAR 50)
   - `favorite_subject` (VARCHAR 50)
   - `created_at`, `updated_at` (TIMESTAMP)

2. **`progress`**:
   - `id` (INT AUTO_INCREMENT Primary Key)
   - `user_id` (FOREIGN KEY -> `users.id` ON DELETE CASCADE)
   - `streak_days` (INT)
   - `total_coins` (INT)
   - `overall_percentage` (DECIMAL 5,2)
   - `completed_lessons` (INT)
   - `total_quizzes_attempted` (INT)
   - `average_quiz_score` (DECIMAL 5,2)
   - `module_progress` (JSON)
   - `completed_modules` (JSON)
   - `last_active_date` (TIMESTAMP)

3. **`quiz_results`**:
   - `id` (INT AUTO_INCREMENT Primary Key)
   - `user_id` (FOREIGN KEY -> `users.id` ON DELETE CASCADE)
   - `quiz_category` (VARCHAR 50)
   - `score_percentage` (DECIMAL 5,2)
   - `stars_earned` (INT, CHECK 0–3)
   - `coins_earned` (INT)
   - `total_questions` (INT)
   - `correct_answers` (INT)
   - `attempted_at` (TIMESTAMP)

4. **`parent_settings`**:
   - `id` (INT AUTO_INCREMENT Primary Key)
   - `user_id` (FOREIGN KEY -> `users.id` ON DELETE CASCADE)
   - `parent_pin` (VARCHAR 10, default '1234')
   - `daily_time_limit_minutes` (INT, default 30)
   - `math_gate_enabled` (BOOLEAN)
   - `speech_rate` (DECIMAL 3,2)
   - `speech_pitch` (DECIMAL 3,2)
   - `allowed_modules` (JSON)
   - `weekly_activity_minutes` (JSON)

5. **`user_achievements`**:
   - `id` (INT AUTO_INCREMENT Primary Key)
   - `user_id` (FOREIGN KEY -> `users.id` ON DELETE CASCADE)
   - `badge_id` (VARCHAR 50)
   - `title` (VARCHAR 100)
   - `is_unlocked` (BOOLEAN)
   - `reward_coins` (INT)
   - `unlocked_at` (TIMESTAMP NULL)

---

## 🚀 3. Quick Start & Execution

### A. Automatic Viva Demo Mode (No MySQL Server Required)
The server runs out-of-the-box with pre-seeded demo records for student evaluations:
```bash
cd backend
npm install
npm start
```
The server will start at `http://localhost:5000` in **Viva Mode** (`USE_MOCK_DB=true`).

### B. Live MySQL Database Setup
1. Open MySQL Command Line or MySQL Workbench.
2. Run the initialization script:
   ```bash
   mysql -u root -p < database/schema.sql
   ```
3. Update `.env`:
   ```env
   PORT=5000
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=your_mysql_password
   DB_NAME=jaroos_db
   USE_MOCK_DB=false
   ```
4. Start the server:
   ```bash
   npm start
   ```

---

## 📡 4. REST API Endpoint Documentation

| Method | Endpoint | Access | Description |
|---|---|---|---|
| `GET` | `/api/health` | Public | Server status and mode check |
| `POST` | `/api/auth/register` | Public | Register parent & learner profile |
| `POST` | `/api/auth/login` | Public | Authenticate and issue JWT token |
| `GET` | `/api/auth/profile` | Protected | Retrieve authenticated learner profile |
| `GET` | `/api/progress` | Protected | Fetch holistic learning stats & coins |
| `POST` | `/api/progress/sync` | Protected | Sync mobile completion & streak data |
| `POST` | `/api/progress/quiz` | Protected | Record quiz score and credit coins |
| `GET` | `/api/progress/achievements` | Protected | Fetch unlocked trophy badges |
| `GET` | `/api/parent/settings` | Protected | Fetch screen time & module permissions |
| `PUT` | `/api/parent/settings` | Protected | Update PIN and parental limits |
| `POST` | `/api/parent/verify-pin` | Protected | Verify 4-digit PIN for parent gate |

---

## 🧪 5. Automated Verification
Run the backend test script:
```bash
npm test
# or
node test/api.test.js
```
Runs 6 automated tests validating status, authentication, profile extraction, progress retrieval, quiz score logging, and PIN gate validation.
