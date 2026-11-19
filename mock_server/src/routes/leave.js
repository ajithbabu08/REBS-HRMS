const express = require('express');
const { getLeaveBalance, getLeaveRequests, submitLeaveRequest } = require('../services/leaveService');
const { readStore } = require('../database/store');

const router = express.Router();

// GET /leave/balance
router.get('/balance', (req, res) => {
  const store = readStore();

  if (store.scenario === 'server_error') {
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Internal server error',
      error: { code: 'INTERNAL_ERROR', message: 'Server error (scenario forced)' },
    });
  }

  const result = getLeaveBalance();
  res.status(result.status).json(result.body);
});

// GET /leave/requests
router.get('/requests', (req, res) => {
  const store = readStore();

  if (store.scenario === 'server_error') {
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Internal server error',
      error: { code: 'INTERNAL_ERROR', message: 'Server error (scenario forced)' },
    });
  }

  const result = getLeaveRequests();
  res.status(result.status).json(result.body);
});

// POST /leave/requests
router.post('/requests', (req, res) => {
  const result = submitLeaveRequest(req.body);
  res.status(result.status).json(result.body);
});

module.exports = router;
