const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { getPool, isMock, inMemoryStore } = require('../config/db');
const { JWT_SECRET } = require('../middleware/authMiddleware');

/**
 * Register a new parent & child profile
 */
async function register(req, res) {
  try {
    const { email, password, childName, childAge, avatar = 'star_hero', favoriteSubject = 'animals' } = req.body;

    if (!email || !password || !childName || !childAge) {
      return res.status(400).json({
        success: false,
        message: 'Please provide email, password, childName, and childAge.'
      });
    }

    const salt = await bcrypt.genSalt(10);
    const passwordHash = await bcrypt.hash(password, salt);
    const userId = 'usr_' + Date.now();

    if (isMock()) {
      const existing = inMemoryStore.users.find(u => u.email.toLowerCase() === email.toLowerCase());
      if (existing) {
        return res.status(409).json({ success: false, message: 'Email is already registered.' });
      }

      const newUser = {
        id: userId,
        email: email.toLowerCase(),
        password_hash: passwordHash,
        child_name: childName,
        child_age: Number(childAge),
        avatar,
        favorite_subject: favoriteSubject,
        created_at: new Date()
      };
      inMemoryStore.users.push(newUser);

      // Create initial progress record
      inMemoryStore.progress.push({
        user_id: userId,
        streak_days: 1,
        total_coins: 100,
        overall_percentage: 0.0,
        completed_lessons: 0,
        total_quizzes_attempted: 0,
        average_quiz_score: 0.0,
        module_progress: {},
        completed_modules: [],
        last_active_date: new Date()
      });

      // Create initial parent settings
      inMemoryStore.parentSettings.push({
        user_id: userId,
        parent_pin: '1234',
        daily_time_limit_minutes: 30,
        math_gate_enabled: false,
        speech_rate: 0.5,
        speech_pitch: 1.0,
        allowed_modules: { alphabet: true, numbers: true, colors: true, shapes: true },
        weekly_activity_minutes: { Mon: 10, Tue: 15, Wed: 0, Thu: 0, Fri: 0, Sat: 0, Sun: 0 }
      });

      const token = jwt.sign({ userId, email }, JWT_SECRET, { expiresIn: '7d' });
      return res.status(201).json({
        success: true,
        message: 'Account created successfully!',
        token,
        user: {
          id: userId,
          email,
          childName,
          childAge: Number(childAge),
          avatar,
          favoriteSubject
        }
      });
    }

    // Live MySQL Execution
    const pool = getPool();
    const [existing] = await pool.query('SELECT id FROM users WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(409).json({ success: false, message: 'Email is already registered.' });
    }

    await pool.query(
      'INSERT INTO users (id, email, password_hash, child_name, child_age, avatar, favorite_subject) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [userId, email, passwordHash, childName, childAge, avatar, favoriteSubject]
    );

    await pool.query(
      'INSERT INTO progress (user_id, streak_days, total_coins, overall_percentage) VALUES (?, 1, 100, 0.0)',
      [userId]
    );

    await pool.query(
      'INSERT INTO parent_settings (user_id, parent_pin, daily_time_limit_minutes) VALUES (?, ?, ?)',
      [userId, '1234', 30]
    );

    const token = jwt.sign({ userId, email }, JWT_SECRET, { expiresIn: '7d' });
    res.status(201).json({
      success: true,
      message: 'Account created successfully!',
      token,
      user: { id: userId, email, childName, childAge, avatar, favoriteSubject }
    });
  } catch (err) {
    console.error('Registration error:', err);
    res.status(500).json({ success: false, message: 'Internal server error during registration.' });
  }
}

/**
 * Login existing user & issue JWT
 */
async function login(req, res) {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ success: false, message: 'Please provide email and password.' });
    }

    if (isMock()) {
      const user = inMemoryStore.users.find(u => u.email.toLowerCase() === email.toLowerCase());
      if (!user) {
        return res.status(401).json({ success: false, message: 'Invalid email or password.' });
      }

      // Check password using bcrypt or accept demo password
      const match = await bcrypt.compare(password, user.password_hash) || password === 'password123';
      if (!match) {
        return res.status(401).json({ success: false, message: 'Invalid email or password.' });
      }

      const token = jwt.sign({ userId: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });
      return res.json({
        success: true,
        message: 'Login successful!',
        token,
        user: {
          id: user.id,
          email: user.email,
          childName: user.child_name,
          childAge: user.child_age,
          avatar: user.avatar,
          favoriteSubject: user.favorite_subject
        }
      });
    }

    // Live MySQL Execution
    const pool = getPool();
    const [rows] = await pool.query('SELECT * FROM users WHERE email = ?', [email]);
    if (rows.length === 0) {
      return res.status(401).json({ success: false, message: 'Invalid email or password.' });
    }

    const user = rows[0];
    const match = await bcrypt.compare(password, user.password_hash);
    if (!match) {
      return res.status(401).json({ success: false, message: 'Invalid email or password.' });
    }

    const token = jwt.sign({ userId: user.id, email: user.email }, JWT_SECRET, { expiresIn: '7d' });
    res.json({
      success: true,
      message: 'Login successful!',
      token,
      user: {
        id: user.id,
        email: user.email,
        childName: user.child_name,
        childAge: user.child_age,
        avatar: user.avatar,
        favoriteSubject: user.favorite_subject
      }
    });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ success: false, message: 'Internal server error during login.' });
  }
}

/**
 * Get current authenticated user profile
 */
async function getProfile(req, res) {
  try {
    const { userId } = req.user;

    if (isMock()) {
      const user = inMemoryStore.users.find(u => u.id === userId);
      if (!user) {
        return res.status(404).json({ success: false, message: 'User not found.' });
      }
      return res.json({
        success: true,
        user: {
          id: user.id,
          email: user.email,
          childName: user.child_name,
          childAge: user.child_age,
          avatar: user.avatar,
          favoriteSubject: user.favorite_subject
        }
      });
    }

    const pool = getPool();
    const [rows] = await pool.query(
      'SELECT id, email, child_name, child_age, avatar, favorite_subject FROM users WHERE id = ?',
      [userId]
    );

    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'User not found.' });
    }

    const u = rows[0];
    res.json({
      success: true,
      user: {
        id: u.id,
        email: u.email,
        childName: u.child_name,
        childAge: u.child_age,
        avatar: u.avatar,
        favoriteSubject: u.favorite_subject
      }
    });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to fetch user profile.' });
  }
}

module.exports = {
  register,
  login,
  getProfile
};
