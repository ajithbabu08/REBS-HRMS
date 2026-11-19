function errorHandler(err, req, res, _next) {
  console.error(`[error] ${err.stack || err.message}`);
  res.status(500).json({
    success: false,
    data: null,
    message: 'Internal server error',
    error: {
      code: 'INTERNAL_ERROR',
      message: err.message || 'An unexpected error occurred',
    },
  });
}

module.exports = errorHandler;
