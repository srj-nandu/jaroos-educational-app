const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'jaroos_super_secret_jwt_key_2026_mca_project';

/**
 * Authentication Middleware
 * Validates the Bearer JWT token from the Authorization header.
 */
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Access denied. No authentication token provided.'
    });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (err) {
    return res.status(403).json({
      success: false,
      message: 'Invalid or expired token.'
    });
  }
}

module.exports = {
  authenticateToken,
  JWT_SECRET
};
