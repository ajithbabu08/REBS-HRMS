const { readStore, writeStore } = require('../database/store');
const config = require('../config');

/**
 * Haversine distance in meters between two lat/lng pairs
 */
function haversineDistance(lat1, lon1, lat2, lon2) {
  const R = 6371000; // Earth radius in meters
  const toRad = (deg) => (deg * Math.PI) / 180;
  const dLat = toRad(lat2 - lat1);
  const dLon = toRad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) ** 2 +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) * Math.sin(dLon / 2) ** 2;
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

function processAttendanceEvent(body, idempotencyKey) {
  const store = readStore();
  const scenario = store.scenario || 'normal';

  const { eventId, employeeId, eventType, timestamp, latitude, longitude, officeDistanceMeters, companyDate } = body;

  // --- Validation ---
  if (!eventId || !employeeId || !eventType || !timestamp || latitude == null || longitude == null || !companyDate) {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Missing required fields',
        error: { code: 'VALIDATION_ERROR', message: 'eventId, employeeId, eventType, timestamp, latitude, longitude, and companyDate are required' },
      },
    };
  }

  if (!['CHECK_IN', 'CHECK_OUT'].includes(eventType)) {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Invalid eventType',
        error: { code: 'VALIDATION_ERROR', message: 'eventType must be CHECK_IN or CHECK_OUT' },
      },
    };
  }

  // Validate employee exists
  if (employeeId !== store.employee.employeeId) {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Employee not found',
        error: { code: 'EMPLOYEE_NOT_FOUND', message: `Employee ${employeeId} does not exist` },
      },
    };
  }

  // Validate timestamp
  const ts = new Date(timestamp);
  if (isNaN(ts.getTime())) {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Invalid timestamp',
        error: { code: 'VALIDATION_ERROR', message: 'timestamp must be a valid ISO-8601 date' },
      },
    };
  }

  // Validate office radius
  const distance = officeDistanceMeters != null
    ? officeDistanceMeters
    : haversineDistance(latitude, longitude, config.officeLocation.latitude, config.officeLocation.longitude);

  if (distance > config.officeLocation.radiusMeters) {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Outside office radius',
        error: { code: 'OUTSIDE_RADIUS', message: `Distance ${Math.round(distance)}m exceeds allowed radius of ${config.officeLocation.radiusMeters}m` },
      },
    };
  }

  // --- Scenario: duplicate_conflict ---
  if (scenario === 'duplicate_conflict') {
    return {
      status: 409,
      body: {
        success: false,
        data: null,
        message: 'Duplicate attendance conflict (scenario)',
        error: { code: 'DUPLICATE_CONFLICT', message: 'Attendance event already exists for this date (scenario forced)' },
      },
    };
  }

  // --- Scenario: server_error ---
  if (scenario === 'server_error') {
    return {
      status: 500,
      body: {
        success: false,
        data: null,
        message: 'Internal server error',
        error: { code: 'INTERNAL_ERROR', message: 'Server error (scenario forced)' },
      },
    };
  }

  // --- Idempotency check ---
  const resolvedKey = idempotencyKey || eventId;
  if (store.processedEventIds[resolvedKey]) {
    const cached = store.processedEventIds[resolvedKey];
    if (scenario === 'idempotency_test') {
      console.log(`[idempotency] Replaying cached result for eventId=${resolvedKey}`);
    }
    return { status: cached.status, body: cached.body, idempotent: true };
  }

  // --- Business logic ---
  let record = store.attendance.find((r) => r.date === companyDate && r.employeeId === employeeId);

  if (eventType === 'CHECK_IN') {
    if (record && record.checkIn) {
      return {
        status: 409,
        body: {
          success: false,
          data: null,
          message: 'Already checked in for this date',
          error: { code: 'DUPLICATE_CHECKIN', message: `Check-in already recorded for ${companyDate}` },
        },
      };
    }

    if (!record) {
      record = {
        date: companyDate,
        employeeId,
        checkIn: null,
        checkOut: null,
        status: 'CHECKED_IN',
      };
      store.attendance.push(record);
    }

    record.checkIn = { timestamp, latitude, longitude, officeDistanceMeters: Math.round(distance) };
    record.status = 'CHECKED_IN';
  } else {
    // CHECK_OUT
    if (!record || !record.checkIn) {
      return {
        status: 422,
        body: {
          success: false,
          data: null,
          message: 'Must check in before checking out',
          error: { code: 'ORDER_ERROR', message: 'No check-in found for this date. Check-in must precede check-out.' },
        },
      };
    }

    if (record.checkOut) {
      return {
        status: 409,
        body: {
          success: false,
          data: null,
          message: 'Already checked out for this date',
          error: { code: 'DUPLICATE_CHECKOUT', message: `Check-out already recorded for ${companyDate}` },
        },
      };
    }

    // Ensure check-out is after check-in
    const checkInTime = new Date(record.checkIn.timestamp);
    if (ts <= checkInTime) {
      return {
        status: 422,
        body: {
          success: false,
          data: null,
          message: 'Check-out must be after check-in',
          error: { code: 'ORDER_ERROR', message: 'Check-out timestamp must be after check-in timestamp' },
        },
      };
    }

    record.checkOut = { timestamp, latitude, longitude, officeDistanceMeters: Math.round(distance) };
    record.status = 'COMPLETED';
  }

  const result = {
    status: 201,
    body: {
      success: true,
      data: { ...record },
      message: `${eventType === 'CHECK_IN' ? 'Check-in' : 'Check-out'} recorded successfully`,
      error: null,
    },
  };

  // Cache for idempotency
  store.processedEventIds[resolvedKey] = { status: result.status, body: result.body };

  writeStore(store);

  return result;
}

function getAttendanceByMonth(monthStr) {
  const store = readStore();

  if (!monthStr || !/^\d{4}-\d{2}$/.test(monthStr)) {
    return {
      status: 400,
      body: {
        success: false,
        data: null,
        message: 'Invalid month format',
        error: { code: 'VALIDATION_ERROR', message: 'month query parameter must be in YYYY-MM format' },
      },
    };
  }

  const records = store.attendance.filter((r) => r.date.startsWith(monthStr));

  return {
    status: 200,
    body: {
      success: true,
      data: records,
      message: `Found ${records.length} attendance records for ${monthStr}`,
      error: null,
    },
  };
}

module.exports = { processAttendanceEvent, getAttendanceByMonth };
