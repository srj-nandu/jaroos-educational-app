const { getPool, isMock, inMemoryStore } = require('../config/db');

/**
 * Get learning progress & statistics for current user
 */
async function getProgress(req, res) {
  try {
    const { userId } = req.user;

    if (isMock()) {
      let prog = inMemoryStore.progress.find(p => p.user_id === userId);
      if (!prog) {
        prog = {
          user_id: userId,
          streak_days: 1,
          total_coins: 100,
          overall_percentage: 0.0,
          completed_lessons: 0,
          total_quizzes_attempted: 0,
          average_quiz_score: 0.0,
          module_progress: {},
          completed_modules: []
        };
        inMemoryStore.progress.push(prog);
      }
      return res.json({ success: true, progress: prog });
    }

    const pool = getPool();
    const [rows] = await pool.query('SELECT * FROM progress WHERE user_id = ?', [userId]);

    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Progress record not found.' });
    }

    const row = rows[0];
    res.json({
      success: true,
      progress: {
        userId: row.user_id,
        streakDays: row.streak_days,
        totalCoins: row.total_coins,
        overallPercentage: Number(row.overall_percentage),
        completedLessons: row.completed_lessons,
        totalQuizzesAttempted: row.total_quizzes_attempted,
        averageQuizScore: Number(row.average_quiz_score),
        moduleProgress: typeof row.module_progress === 'string' ? JSON.parse(row.module_progress) : row.module_progress,
        completedModules: typeof row.completed_modules === 'string' ? JSON.parse(row.completed_modules) : row.completed_modules,
        lastActiveDate: row.last_active_date
      }
    });
  } catch (err) {
    console.error('Fetch progress error:', err);
    res.status(500).json({ success: false, message: 'Failed to fetch progress.' });
  }
}

/**
 * Sync mobile progress update to backend
 */
async function syncProgress(req, res) {
  try {
    const { userId } = req.user;
    const { streakDays, totalCoins, overallPercentage, completedLessons, moduleProgress, completedModules } = req.body;

    if (isMock()) {
      let prog = inMemoryStore.progress.find(p => p.user_id === userId);
      if (prog) {
        if (streakDays !== undefined) prog.streak_days = streakDays;
        if (totalCoins !== undefined) prog.total_coins = totalCoins;
        if (overallPercentage !== undefined) prog.overall_percentage = overallPercentage;
        if (completedLessons !== undefined) prog.completed_lessons = completedLessons;
        if (moduleProgress) prog.module_progress = moduleProgress;
        if (completedModules) prog.completed_modules = completedModules;
        prog.last_active_date = new Date();
      }
      return res.json({ success: true, message: 'Progress synchronized successfully!', progress: prog });
    }

    const pool = getPool();
    await pool.query(
      `UPDATE progress SET 
        streak_days = COALESCE(?, streak_days),
        total_coins = COALESCE(?, total_coins),
        overall_percentage = COALESCE(?, overall_percentage),
        completed_lessons = COALESCE(?, completed_lessons),
        module_progress = COALESCE(?, module_progress),
        completed_modules = COALESCE(?, completed_modules),
        last_active_date = CURRENT_TIMESTAMP
       WHERE user_id = ?`,
      [
        streakDays,
        totalCoins,
        overallPercentage,
        completedLessons,
        moduleProgress ? JSON.stringify(moduleProgress) : null,
        completedModules ? JSON.stringify(completedModules) : null,
        userId
      ]
    );

    res.json({ success: true, message: 'Progress synchronized successfully!' });
  } catch (err) {
    console.error('Sync progress error:', err);
    res.status(500).json({ success: false, message: 'Failed to sync progress.' });
  }
}

/**
 * Record a completed quiz result
 */
async function saveQuizResult(req, res) {
  try {
    const { userId } = req.user;
    const { quizCategory, scorePercentage, starsEarned, coinsEarned, totalQuestions, correctAnswers } = req.body;

    if (scorePercentage === undefined || starsEarned === undefined) {
      return res.status(400).json({ success: false, message: 'Missing quiz result metrics.' });
    }

    if (isMock()) {
      const record = {
        id: inMemoryStore.quizResults.length + 1,
        user_id: userId,
        quiz_category: quizCategory || 'General Knowledge',
        score_percentage: Number(scorePercentage),
        stars_earned: Number(starsEarned),
        coins_earned: Number(coinsEarned || 0),
        total_questions: Number(totalQuestions || 5),
        correct_answers: Number(correctAnswers || 5),
        attempted_at: new Date()
      };
      inMemoryStore.quizResults.push(record);

      // Update total coins in progress
      const prog = inMemoryStore.progress.find(p => p.user_id === userId);
      if (prog) {
        prog.total_coins = (prog.total_coins || 100) + Number(coinsEarned || 0);
        prog.total_quizzes_attempted = (prog.total_quizzes_attempted || 0) + 1;
      }

      return res.status(201).json({ success: true, message: 'Quiz result saved!', result: record });
    }

    const pool = getPool();
    await pool.query(
      `INSERT INTO quiz_results 
        (user_id, quiz_category, score_percentage, stars_earned, coins_earned, total_questions, correct_answers)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [userId, quizCategory, scorePercentage, starsEarned, coinsEarned, totalQuestions, correctAnswers]
    );

    // Increment coins and quizzes attempted in progress
    await pool.query(
      `UPDATE progress SET 
        total_coins = total_coins + ?,
        total_quizzes_attempted = total_quizzes_attempted + 1
       WHERE user_id = ?`,
      [coinsEarned || 0, userId]
    );

    res.status(201).json({ success: true, message: 'Quiz result saved!' });
  } catch (err) {
    console.error('Quiz save error:', err);
    res.status(500).json({ success: false, message: 'Failed to record quiz result.' });
  }
}

/**
 * Get achievements for user
 */
async function getAchievements(req, res) {
  try {
    const { userId } = req.user;

    if (isMock()) {
      const badges = inMemoryStore.achievements.filter(a => a.user_id === userId || a.user_id === 'usr_demo_001');
      return res.json({ success: true, achievements: badges });
    }

    const pool = getPool();
    const [rows] = await pool.query('SELECT * FROM user_achievements WHERE user_id = ?', [userId]);
    res.json({ success: true, achievements: rows });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Failed to fetch achievements.' });
  }
}

module.exports = {
  getProgress,
  syncProgress,
  saveQuizResult,
  getAchievements
};
