/**
 * JAROOS - Educational Learning Backend Server
 * MCA Major Project
 * Tech Stack: Node.js, Express, MySQL 8.0, JWT, Bcrypt
 */

const express = require('express');
const cors = require('cors');
const dotenv = require('dotenv');

dotenv.config();

const { initDb } = require('./config/db');
const apiRoutes = require('./routes/api');

const app = express();
const PORT = process.env.PORT || 5000;

// Middlewares
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request Logging Middleware for Viva Presentation
app.use((req, res, next) => {
  console.log(`[${new Date().toLocaleTimeString()}] ${req.method} ${req.originalUrl}`);
  next();
});

// Root Welcome Route
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to JAROOS Backend API - Learn • Play • Grow 🚀',
    docs: '/api/health',
    mcaProject: true,
    version: '1.0.0'
  });
});

// Mount API Routes
app.use('/api', apiRoutes);

// 404 Fallback Handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: `API endpoint ${req.method} ${req.originalUrl} not found.`
  });
});

// Global Error Handler
app.use((err, req, res, next) => {
  console.error('Unhandled server exception:', err);
  res.status(500).json({
    success: false,
    message: 'Internal server error occurred.',
    error: process.env.NODE_ENV === 'development' ? err.message : undefined
  });
});

// Start Server
async function startServer() {
  await initDb();
  app.listen(PORT, () => {
    console.log('====================================================');
    console.log(`🚀 JAROOS API Server running on port ${PORT}`);
    console.log(`🌐 Base URL: http://localhost:${PORT}`);
    console.log(`🩺 Health check: http://localhost:${PORT}/api/health`);
    console.log(`🎓 MCA Major Project Ready for Demonstration`);
    console.log('====================================================');
  });
}

// Start if executed directly
if (require.main === module) {
  startServer();
}

module.exports = { app, startServer };
