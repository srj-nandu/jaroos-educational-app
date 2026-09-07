/**
 * Database configuration & Connection Manager for JAROOS.
 * Provides a resilient dual-mode adapter:
 * 1. Live MySQL 8.0+ Connection Pool via `mysql2/promise`
 * 2. In-Memory Mock Database fallback for zero-configuration viva evaluations
 */

const dotenv = require('dotenv');
dotenv.config();

let pool = null;
let useMock = process.env.USE_MOCK_DB === 'true';

// In-Memory Database Store for robust offline demonstration
const inMemoryStore = {
  users: [
    {
      id: 'usr_demo_001',
      email: 'demo@jaroos.edu',
      password_hash: '$2a$10$7EqJtq98hPqEX7fNZaFWoOhtBznVjW3GkPnEev2f8yQJqXz8iZlI.', // 'password123'
      child_name: 'Aarav',
      child_age: 5,
      avatar: 'star_hero',
      favorite_subject: 'animals',
      created_at: new Date()
    }
  ],
  progress: [
    {
      user_id: 'usr_demo_001',
      streak_days: 4,
      total_coins: 280,
      overall_percentage: 42.5,
      completed_lessons: 26,
      total_quizzes_attempted: 5,
      average_quiz_score: 96.0,
      module_progress: {
        alphabet: 30.8,
        numbers: 30.0,
        colors: 40.0,
        shapes: 37.5,
        animals: 41.7,
        fruits: 33.3,
        stories: 33.3,
        rhymes: 37.5,
        quiz: 40.0,
        progress: 40.0
      },
      completed_modules: ['alphabet_lvl1', 'colors_intro'],
      last_active_date: new Date()
    }
  ],
  quizResults: [
    {
      id: 1,
      user_id: 'usr_demo_001',
      quiz_category: 'Animals',
      score_percentage: 100.0,
      stars_earned: 3,
      coins_earned: 15,
      total_questions: 5,
      correct_answers: 5,
      attempted_at: new Date()
    }
  ],
  parentSettings: [
    {
      user_id: 'usr_demo_001',
      parent_pin: '1234',
      daily_time_limit_minutes: 30,
      math_gate_enabled: false,
      speech_rate: 0.5,
      speech_pitch: 1.0,
      allowed_modules: {
        alphabet: true,
        numbers: true,
        colors: true,
        shapes: true,
        animals: true,
        fruits: true,
        stories: true,
        rhymes: true,
        quiz: true,
        progress: true
      },
      weekly_activity_minutes: {
        Mon: 25,
        Tue: 30,
        Wed: 20,
        Thu: 35,
        Fri: 28,
        Sat: 40,
        Sun: 15
      }
    }
  ],
  achievements: [
    { id: 1, user_id: 'usr_demo_001', badge_id: 'badge_alphabet', title: 'ABC Explorer', is_unlocked: true, reward_coins: 25 },
    { id: 2, user_id: 'usr_demo_001', badge_id: 'badge_numbers', title: 'Number Wizard', is_unlocked: true, reward_coins: 30 },
    { id: 3, user_id: 'usr_demo_001', badge_id: 'badge_quiz_master', title: 'Quiz Superstar', is_unlocked: true, reward_coins: 50 },
    { id: 4, user_id: 'usr_demo_001', badge_id: 'badge_streak', title: 'Daily Champion', is_unlocked: false, reward_coins: 60 }
  ]
};

async function initDb() {
  if (useMock) {
    console.log('⚡ [JAROOS DB] Running with In-Memory Mock Database (Viva Demo Ready)');
    return;
  }

  try {
    const mysql = require('mysql2/promise');
    pool = mysql.createPool({
      host: process.env.DB_HOST || 'localhost',
      port: Number(process.env.DB_PORT) || 3306,
      user: process.env.DB_USER || 'root',
      password: process.env.DB_PASSWORD || '',
      database: process.env.DB_NAME || 'jaroos_db',
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0
    });

    const connection = await pool.getConnection();
    console.log('✅ [JAROOS DB] Connected successfully to MySQL database!');
    connection.release();
  } catch (err) {
    console.warn('⚠️ [JAROOS DB] MySQL connection failed. Gracefully falling back to In-Memory store:', err.message);
    useMock = true;
  }
}

module.exports = {
  initDb,
  getPool: () => pool,
  isMock: () => useMock,
  inMemoryStore
};
