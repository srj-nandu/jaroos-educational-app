/**
 * Automated Verification Script for JAROOS Backend REST API
 * Tests health, auth, progress sync, and parent gate controls.
 */

const assert = require('assert');
const { app, startServer } = require('../src/server');

const PORT = 5055;
process.env.PORT = PORT;
process.env.USE_MOCK_DB = 'true';

let server;

function makeRequest(method, path, body = null, headers = {}) {
  const http = require('http');
  return new Promise((resolve, reject) => {
    const dataString = body ? JSON.stringify(body) : null;
    const reqOptions = {
      hostname: 'localhost',
      port: PORT,
      path,
      method,
      headers: {
        'Content-Type': 'application/json',
        ...(dataString ? { 'Content-Length': Buffer.byteLength(dataString) } : {}),
        ...headers
      }
    };

    const req = http.request(reqOptions, (res) => {
      let responseBody = '';
      res.on('data', (chunk) => { responseBody += chunk; });
      res.on('end', () => {
        try {
          const parsed = JSON.parse(responseBody);
          resolve({ status: res.statusCode, body: parsed });
        } catch {
          resolve({ status: res.statusCode, body: responseBody });
        }
      });
    });

    req.on('error', reject);
    if (dataString) req.write(dataString);
    req.end();
  });
}

async function runTests() {
  console.log('🧪 [JAROOS Backend Test] Starting automated API suite...\n');

  // 1. Health Check
  const healthRes = await makeRequest('GET', '/api/health');
  assert.strictEqual(healthRes.status, 200);
  assert.strictEqual(healthRes.body.status, 'online');
  console.log('✅ GET /api/health passed');

  // 2. Auth Login (Demo User)
  const loginRes = await makeRequest('POST', '/api/auth/login', {
    email: 'demo@jaroos.edu',
    password: 'password123'
  });
  assert.strictEqual(loginRes.status, 200);
  assert.ok(loginRes.body.token, 'Token should be returned');
  assert.strictEqual(loginRes.body.user.childName, 'Aarav');
  const token = loginRes.body.token;
  console.log('✅ POST /api/auth/login passed (JWT issued)');

  const authHeaders = { Authorization: `Bearer ${token}` };

  // 3. User Profile
  const profileRes = await makeRequest('GET', '/api/auth/profile', null, authHeaders);
  assert.strictEqual(profileRes.status, 200);
  assert.strictEqual(profileRes.body.user.email, 'demo@jaroos.edu');
  console.log('✅ GET /api/auth/profile passed');

  // 4. Learning Progress
  const progRes = await makeRequest('GET', '/api/progress', null, authHeaders);
  assert.strictEqual(progRes.status, 200);
  assert.ok(progRes.body.progress.total_coins >= 100);
  console.log('✅ GET /api/progress passed');

  // 5. Quiz Result Submission
  const quizRes = await makeRequest('POST', '/api/progress/quiz', {
    quizCategory: 'Numbers',
    scorePercentage: 100,
    starsEarned: 3,
    coinsEarned: 15,
    totalQuestions: 5,
    correctAnswers: 5
  }, authHeaders);
  assert.strictEqual(quizRes.status, 201);
  assert.strictEqual(quizRes.body.success, true);
  console.log('✅ POST /api/progress/quiz passed');

  // 6. Parent Settings & PIN Verification
  const parentRes = await makeRequest('GET', '/api/parent/settings', null, authHeaders);
  assert.strictEqual(parentRes.status, 200);
  console.log('✅ GET /api/parent/settings passed');

  const pinRes = await makeRequest('POST', '/api/parent/verify-pin', { pin: '1234' }, authHeaders);
  assert.strictEqual(pinRes.status, 200);
  assert.strictEqual(pinRes.body.isValid, true);
  console.log('✅ POST /api/parent/verify-pin (valid PIN) passed');

  const badPinRes = await makeRequest('POST', '/api/parent/verify-pin', { pin: '9999' }, authHeaders);
  assert.strictEqual(badPinRes.body.isValid, false);
  console.log('✅ POST /api/parent/verify-pin (invalid PIN) passed');

  console.log('\n🎉 ALL 6 BACKEND API TESTS PASSED SUCCESSFULLY!\n');
}

const { initDb } = require('../src/config/db');
initDb().then(() => {
  server = app.listen(PORT, async () => {
    try {
      await runTests();
      server.close();
      process.exit(0);
    } catch (err) {
      console.error('❌ Backend test assertion failed:', err);
      server.close();
      process.exit(1);
    }
  });
});
