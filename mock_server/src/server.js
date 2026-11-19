const express = require('express');
const cors = require('cors');
const config = require('./config');
const logger = require('./middleware/logger');
const delay = require('./middleware/delay');
const errorHandler = require('./middleware/errorHandler');
const { resetStore } = require('./database/store');
const { getCurrentScenario, setScenario, VALID_SCENARIOS } = require('./scenarios');

// Routes
const employeeRoutes = require('./routes/employee');
const attendanceRoutes = require('./routes/attendance');
const leaveRoutes = require('./routes/leave');

const app = express();

// Global middleware
app.use(cors());
app.use(express.json());
app.use(logger);

// Apply delay middleware to API routes (not to scenario/reset endpoints)
app.use('/employee', delay, employeeRoutes);
app.use('/attendance', delay, attendanceRoutes);
app.use('/leave', delay, leaveRoutes);

// --- Scenario endpoints (no delay) ---
app.get('/scenarios/current', (req, res) => {
  res.json({
    success: true,
    data: { scenario: getCurrentScenario(), available: VALID_SCENARIOS },
    message: 'Current scenario',
    error: null,
  });
});

app.post('/scenarios/set', (req, res) => {
  const { scenario } = req.body;
  if (!scenario) {
    return res.status(400).json({
      success: false,
      data: null,
      message: 'Missing scenario field',
      error: { code: 'VALIDATION_ERROR', message: 'Request body must include "scenario"' },
    });
  }

  const result = setScenario(scenario);
  if (!result.valid) {
    return res.status(400).json({
      success: false,
      data: null,
      message: 'Invalid scenario',
      error: { code: 'INVALID_SCENARIO', message: `Valid scenarios: ${result.scenarios.join(', ')}` },
    });
  }

  res.json({
    success: true,
    data: { scenario: result.scenario },
    message: `Scenario set to "${result.scenario}"`,
    error: null,
  });
});

// --- Reset endpoint ---
app.post('/reset', (req, res) => {
  resetStore();
  res.json({
    success: true,
    data: null,
    message: 'All data reset to initial state',
    error: null,
  });
});

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Error handler
app.use(errorHandler);

// Start server
const PORT = process.env.PORT || config.port || 3000;
app.listen(PORT, () => {
  console.log(`\n🚀 REBS HRMS Mock Server running on port ${PORT}`);
  console.log(`   Scenario: ${getCurrentScenario()}`);
  console.log(`   Endpoints:`);
  console.log(`     GET  /employee/me`);
  console.log(`     GET  /attendance?month=YYYY-MM`);
  console.log(`     POST /attendance/events`);
  console.log(`     GET  /leave/balance`);
  console.log(`     GET  /leave/requests`);
  console.log(`     POST /leave/requests`);
  console.log(`     GET  /scenarios/current`);
  console.log(`     POST /scenarios/set`);
  console.log(`     POST /reset`);
  console.log(`     GET  /health\n`);
});
