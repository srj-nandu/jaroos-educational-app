-- ====================================================================
-- JAROOS: Interactive Educational App for Kids (MCA Major Project)
-- Relational Database Schema (MySQL 8.0+)
-- ====================================================================

CREATE DATABASE IF NOT EXISTS jaroos_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE jaroos_db;

-- 1. Users & Child Profile Table
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    child_name VARCHAR(100) NOT NULL,
    child_age INT NOT NULL CHECK (child_age >= 2 AND child_age <= 12),
    avatar VARCHAR(50) DEFAULT 'star_hero',
    favorite_subject VARCHAR(50) DEFAULT 'animals',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_user_email (email)
) ENGINE=InnoDB;

-- 2. Learner Holistic Progress Table
CREATE TABLE IF NOT EXISTS progress (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL UNIQUE,
    streak_days INT DEFAULT 1,
    total_coins INT DEFAULT 100,
    overall_percentage DECIMAL(5,2) DEFAULT 0.00,
    completed_lessons INT DEFAULT 0,
    total_quizzes_attempted INT DEFAULT 0,
    average_quiz_score DECIMAL(5,2) DEFAULT 0.00,
    module_progress JSON NULL,
    completed_modules JSON NULL,
    last_active_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_progress_user (user_id)
) ENGINE=InnoDB;

-- 3. Quiz Results & History Table
CREATE TABLE IF NOT EXISTS quiz_results (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    quiz_category VARCHAR(50) NOT NULL,
    score_percentage DECIMAL(5,2) NOT NULL,
    stars_earned INT NOT NULL CHECK (stars_earned >= 0 AND stars_earned <= 3),
    coins_earned INT NOT NULL DEFAULT 0,
    total_questions INT NOT NULL,
    correct_answers INT NOT NULL,
    attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_quiz_user (user_id)
) ENGINE=InnoDB;

-- 4. Parent Dashboard & Child Safety Controls Table
CREATE TABLE IF NOT EXISTS parent_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL UNIQUE,
    parent_pin VARCHAR(10) DEFAULT '1234',
    daily_time_limit_minutes INT DEFAULT 30,
    math_gate_enabled BOOLEAN DEFAULT FALSE,
    speech_rate DECIMAL(3,2) DEFAULT 0.50,
    speech_pitch DECIMAL(3,2) DEFAULT 1.00,
    allowed_modules JSON NULL,
    weekly_activity_minutes JSON NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_parent_user (user_id)
) ENGINE=InnoDB;

-- 5. Achievements & Badges Registry Table
CREATE TABLE IF NOT EXISTS user_achievements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(36) NOT NULL,
    badge_id VARCHAR(50) NOT NULL,
    title VARCHAR(100) NOT NULL,
    is_unlocked BOOLEAN DEFAULT FALSE,
    reward_coins INT DEFAULT 25,
    unlocked_at TIMESTAMP NULL,
    UNIQUE KEY uq_user_badge (user_id, badge_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ====================================================================
-- Initial Seed Data for Academic Viva Demonstration
-- ====================================================================

-- Demo User: demo@jaroos.edu / password123 (bcrypt hash: $2a$10$7EqJtq98hPqEX7fNZaFWoOhtBznVjW3GkPnEev2f8yQJqXz8iZlI.)
INSERT INTO users (id, email, password_hash, child_name, child_age, avatar, favorite_subject)
VALUES (
    'usr_demo_001',
    'demo@jaroos.edu',
    '$2a$10$7EqJtq98hPqEX7fNZaFWoOhtBznVjW3GkPnEev2f8yQJqXz8iZlI.',
    'Aarav',
    5,
    'star_hero',
    'animals'
) ON DUPLICATE KEY UPDATE child_name=VALUES(child_name);

-- Demo Progress
INSERT INTO progress (user_id, streak_days, total_coins, overall_percentage, completed_lessons, total_quizzes_attempted, average_quiz_score, module_progress, completed_modules)
VALUES (
    'usr_demo_001',
    4,
    280,
    42.50,
    26,
    5,
    96.00,
    JSON_OBJECT('alphabet', 30.77, 'numbers', 30.00, 'colors', 40.00, 'shapes', 37.50, 'animals', 41.67, 'fruits', 33.33, 'stories', 33.33, 'rhymes', 37.50, 'quiz', 40.00, 'progress', 40.00),
    JSON_ARRAY('alphabet_lvl1', 'colors_intro')
) ON DUPLICATE KEY UPDATE total_coins=VALUES(total_coins);

-- Demo Parent Settings
INSERT INTO parent_settings (user_id, parent_pin, daily_time_limit_minutes, math_gate_enabled, speech_rate, speech_pitch, allowed_modules, weekly_activity_minutes)
VALUES (
    'usr_demo_001',
    '1234',
    30,
    FALSE,
    0.50,
    1.00,
    JSON_OBJECT('alphabet', true, 'numbers', true, 'colors', true, 'shapes', true, 'animals', true, 'fruits', true, 'stories', true, 'rhymes', true, 'quiz', true, 'progress', true),
    JSON_OBJECT('Mon', 25, 'Tue', 30, 'Wed', 20, 'Thu', 35, 'Fri', 28, 'Sat', 40, 'Sun', 15)
) ON DUPLICATE KEY UPDATE parent_pin=VALUES(parent_pin);
