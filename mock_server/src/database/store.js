const fs = require('fs');
const path = require('path');

const STORE_PATH = path.join(__dirname, '..', '..', 'data', 'store.json');

function getDefaultData() {
  return {
    employee: {
      employeeId: 'REBS-EMP-001',
      name: 'Ajith Babu',
      department: 'Engineering',
      designation: 'Flutter Developer',
      email: 'ajith.babu@rebs.com',
      joinDate: '2024-01-15',
      officeLocation: {
        latitude: 10.0303,
        longitude: 76.3358,
        radiusMeters: 200,
        address: 'Teqbae Innovations & Solutions India Pvt Ltd, Kakkanad',
      },
      companyTimezone: 'Asia/Kolkata',
    },
    attendance: [],
    leaveBalance: {
      casual: 2,
      sick: 3,
    },
    leaveRequests: [],
    processedEventIds: {},
    scenario: 'normal',
  };
}

function readStore() {
  try {
    if (fs.existsSync(STORE_PATH)) {
      const raw = fs.readFileSync(STORE_PATH, 'utf-8');
      return JSON.parse(raw);
    }
  } catch (err) {
    console.error('Error reading store, resetting to default:', err.message);
  }
  const data = getDefaultData();
  writeStore(data);
  return data;
}

function writeStore(data) {
  const dir = path.dirname(STORE_PATH);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }
  fs.writeFileSync(STORE_PATH, JSON.stringify(data, null, 2), 'utf-8');
}

function resetStore() {
  const data = getDefaultData();
  writeStore(data);
  return data;
}

module.exports = { readStore, writeStore, resetStore };
