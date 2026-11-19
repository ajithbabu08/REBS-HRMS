const express = require('express');
const { processAttendanceEvent, getAttendanceByMonth } = require('../services/attendanceService');
const { readStore } = require('../database/store');
const config = require('../config');

const router = express.Router();

// GET /attendance?month=YYYY-MM
router.get('/', (req, res) => {
  const store = readStore();

  if (store.scenario === 'server_error') {
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Internal server error',
      error: { code: 'INTERNAL_ERROR', message: 'Server error (scenario forced)' },
    });
  }

  const result = getAttendanceByMonth(req.query.month);
  res.status(result.status).json(result.body);
});

// POST /attendance/events
router.post('/events', (req, res) => {
  const store = readStore();
  const scenario = store.scenario || 'normal';
  const idempotencyKey = req.headers['idempotency-key'] || req.body.eventId;

  // For timeout scenario: process the event first, THEN delay the response
  if (scenario === 'timeout') {
    // Check if this is an idempotent retry (already processed)
    if (store.processedEventIds[idempotencyKey]) {
      const cached = store.processedEventIds[idempotencyKey];
      console.log(`[idempotency] Timeout retry — returning cached result for key=${idempotencyKey}`);
      return res.status(cached.status).json(cached.body);
    }

    // Process and save immediately
    const result = processAttendanceEvent(req.body, idempotencyKey);

    // Then delay the response for 30s (client will likely timeout)
    console.log(`[timeout] Event saved, delaying response ${config.delays.timeout}ms`);
    setTimeout(() => {
      res.status(result.status).json(result.body);
    }, config.delays.timeout);
    return;
  }

  const result = processAttendanceEvent(req.body, idempotencyKey);

  if (result.idempotent && scenario === 'idempotency_test') {
    console.log(`[idempotency_test] Idempotent replay for key=${idempotencyKey}`);
  }

  res.status(result.status).json(result.body);
});

module.exports = router;
