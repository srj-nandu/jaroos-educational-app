const { getPool, isMock, inMemoryStore } = require('../config/db');

/**
 * Fetch parental settings & safety parameters
 */
async function getParentSettings(req, res) {
  try {
    const { userId } = req.user;

    if (isMock()) {
      let settings = inMemoryStore.parentSettings.find(s => s.user_id === userId);
      if (!settings) {
        settings = inMemoryStore.parentSettings[0];
      }
      return res.json({ success: true, settings });
    }

    const pool = getPool();
    const [rows] = await pool.query('SELECT * FROM parent_settings WHERE user_id = ?', [userId]);

    if (rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Parent settings not found.' });
    }

    const s = rows[0];
    res.json({
      success: true,
      settings: {
        userId: s.user_id,
        parentPin: s.parent_pin,
        dailyTimeLimitMinutes: s.daily_time_limit_minutes,
        mathGateEnabled: Boolean(s.math_gate_enabled),
        speechRate: Number(s.speech_rate),
        speechPitch: Number(s.speech_pitch),
        allowedModules: typeof s.allowed_modules === 'string' ? JSON.parse(s.allowed_modules) : s.allowed_modules,
        weeklyActivityMinutes: typeof s.weekly_activity_minutes === 'string' ? JSON.parse(s.weekly_activity_minutes) : s.weekly_activity_minutes
      }
    });
  } catch (err) {
    console.error('Fetch parent settings error:', err);
    res.status(500).json({ success: false, message: 'Failed to fetch parent settings.' });
  }
}

/**
 * Update parental settings
 */
async function updateParentSettings(req, res) {
  try {
    const { userId } = req.user;
    const { parentPin, dailyTimeLimitMinutes, mathGateEnabled, speechRate, speechPitch, allowedModules } = req.body;

    if (isMock()) {
      let s = inMemoryStore.parentSettings.find(p => p.user_id === userId);
      if (!s) {
        s = { user_id: userId, parent_pin: '1234', daily_time_limit_minutes: 30 };
        inMemoryStore.parentSettings.push(s);
      }

      if (parentPin !== undefined) s.parent_pin = parentPin;
      if (dailyTimeLimitMinutes !== undefined) s.daily_time_limit_minutes = Number(dailyTimeLimitMinutes);
      if (mathGateEnabled !== undefined) s.math_gate_enabled = Boolean(mathGateEnabled);
      if (speechRate !== undefined) s.speech_rate = Number(speechRate);
      if (speechPitch !== undefined) s.speech_pitch = Number(speechPitch);
      if (allowedModules) s.allowed_modules = allowedModules;

      return res.json({ success: true, message: 'Parent settings updated!', settings: s });
    }

    const pool = getPool();
    await pool.query(
      `UPDATE parent_settings SET 
        parent_pin = COALESCE(?, parent_pin),
        daily_time_limit_minutes = COALESCE(?, daily_time_limit_minutes),
        math_gate_enabled = COALESCE(?, math_gate_enabled),
        speech_rate = COALESCE(?, speech_rate),
        speech_pitch = COALESCE(?, speech_pitch),
        allowed_modules = COALESCE(?, allowed_modules)
       WHERE user_id = ?`,
      [
        parentPin,
        dailyTimeLimitMinutes,
        mathGateEnabled,
        speechRate,
        speechPitch,
        allowedModules ? JSON.stringify(allowedModules) : null,
        userId
      ]
    );

    res.json({ success: true, message: 'Parent settings updated successfully!' });
  } catch (err) {
    console.error('Update parent settings error:', err);
    res.status(500).json({ success: false, message: 'Failed to update parent settings.' });
  }
}

/**
 * Verify 4-digit parent gate PIN
 */
async function verifyPin(req, res) {
  try {
    const { userId } = req.user;
    const { pin } = req.body;

    if (!pin) {
      return res.status(400).json({ success: false, message: 'Please provide PIN.' });
    }

    let storedPin = '1234';

    if (isMock()) {
      const s = inMemoryStore.parentSettings.find(p => p.user_id === userId);
      if (s && s.parent_pin) storedPin = s.parent_pin;
    } else {
      const pool = getPool();
      const [rows] = await pool.query('SELECT parent_pin FROM parent_settings WHERE user_id = ?', [userId]);
      if (rows.length > 0 && rows[0].parent_pin) {
        storedPin = rows[0].parent_pin;
      }
    }

    const isValid = pin === storedPin;
    res.json({
      success: true,
      isValid,
      message: isValid ? 'Parent Gate unlocked!' : 'Incorrect PIN.'
    });
  } catch (err) {
    res.status(500).json({ success: false, message: 'Verification error.' });
  }
}

module.exports = {
  getParentSettings,
  updateParentSettings,
  verifyPin
};
