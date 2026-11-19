const config = require('../config');
const { readStore } = require('../database/store');

function delay(req, res, next) {
  const store = readStore();
  const scenario = store.scenario || 'normal';

  let delayMs = 0;
  if (scenario === 'slow') {
    delayMs = config.delays.slow;
  } else if (scenario === 'timeout') {
    delayMs = config.delays.timeout;
  }

  if (delayMs > 0) {
    console.log(`[delay] Scenario "${scenario}": delaying ${delayMs}ms`);
    setTimeout(() => next(), delayMs);
  } else {
    next();
  }
}

module.exports = delay;
