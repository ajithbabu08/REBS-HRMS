const express = require('express');
const { readStore } = require('../database/store');

const router = express.Router();

router.get('/me', (req, res) => {
  const store = readStore();

  if (store.scenario === 'server_error') {
    return res.status(500).json({
      success: false,
      data: null,
      message: 'Internal server error',
      error: { code: 'INTERNAL_ERROR', message: 'Server error (scenario forced)' },
    });
  }

  res.json({
    success: true,
    data: store.employee,
    message: 'Employee profile retrieved',
    error: null,
  });
});

module.exports = router;
