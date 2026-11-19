const { readStore, writeStore } = require('../database/store');

const VALID_SCENARIOS = [
  'normal',
  'slow',
  'timeout',
  'server_error',
  'duplicate_conflict',
  'leave_rejection',
  'idempotency_test',
];

function getCurrentScenario() {
  const store = readStore();
  return store.scenario || 'normal';
}

function setScenario(scenario) {
  if (!VALID_SCENARIOS.includes(scenario)) {
    return { valid: false, scenarios: VALID_SCENARIOS };
  }
  const store = readStore();
  store.scenario = scenario;
  writeStore(store);
  return { valid: true, scenario };
}

module.exports = { getCurrentScenario, setScenario, VALID_SCENARIOS };
