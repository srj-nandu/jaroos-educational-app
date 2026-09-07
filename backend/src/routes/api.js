const express = require('express');
const router = express.Router();

const { authenticateToken } = require('../middleware/authMiddleware');
const authController = require('../controllers/authController');
const progressController = require('../controllers/progressController');
const parentController = require('../controllers/parentController');

// 1. Health & Server Status Check
router.get('/health', (req, res) => {
  res.json({
    status: 'online',
    app: 'JAROOS Backend API',
    version: '1.0.0',
    mode: process.env.USE_MOCK_DB === 'true' ? 'Mock/Viva Mode' : 'Production MySQL',
    timestamp: new Date().toISOString()
  });
});

// 2. Authentication Routes
router.post('/auth/register', authController.register);
router.post('/auth/login', authController.login);
router.get('/auth/profile', authenticateToken, authController.getProfile);

// 3. Learning Progress & Quiz Routes
router.get('/progress', authenticateToken, progressController.getProgress);
router.post('/progress/sync', authenticateToken, progressController.syncProgress);
router.post('/progress/quiz', authenticateToken, progressController.saveQuizResult);
router.get('/progress/achievements', authenticateToken, progressController.getAchievements);

// 4. Parental Dashboard & Safety Routes
router.get('/parent/settings', authenticateToken, parentController.getParentSettings);
router.put('/parent/settings', authenticateToken, parentController.updateParentSettings);
router.post('/parent/verify-pin', authenticateToken, parentController.verifyPin);

module.exports = router;
