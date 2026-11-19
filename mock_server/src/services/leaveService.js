const { readStore, writeStore } = require('../database/store');
const crypto = require('crypto');
const uuidv4 = () => crypto.randomUUID();

function getLeaveBalance() {
  const store = readStore();
  const balance = { ...store.leaveBalance };

  // Deduct approved and pending leaves
  const activeLeaves = store.leaveRequests.filter((r) => r.status === 'APPROVED' || r.status === 'PENDING');
  for (const leave of activeLeaves) {
    const days = calculateDays(leave.startDate, leave.endDate);
    const lType = (leave.leaveType || '').toLowerCase();
    if (lType === 'casual' && balance.casual > 0) {
      balance.casual = Math.max(0, balance.casual - days);
    } else if (lType === 'sick' && balance.sick > 0) {
      balance.sick = Math.max(0, balance.sick - days);
    }
  }

  return {
    status: 200,
    body: {
      success: true,
      data: balance,
      message: 'Leave balance retrieved',
      error: null,
    },
  };
}

function getLeaveRequests() {
  const store = readStore();
  return {
    status: 200,
    body: {
      success: true,
      data: store.leaveRequests,
      message: `Found ${store.leaveRequests.length} leave requests`,
      error: null,
    },
  };
}

function submitLeaveRequest(body) {
  const store = readStore();
  const scenario = store.scenario || 'normal';

  const { employeeId, leaveType, startDate, endDate, reason } = body;

  // Validation
  if (!employeeId || !leaveType || !startDate || !endDate) {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Missing required fields',
        error: { code: 'VALIDATION_ERROR', message: 'employeeId, leaveType, startDate, and endDate are required' },
      },
    };
  }

  const normType = String(leaveType).toLowerCase().trim();
  if (!['casual', 'sick'].includes(normType)) {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Invalid leave type',
        error: { code: 'VALIDATION_ERROR', message: 'leaveType must be casual or sick' },
      },
    };
  }

  // Validate dates
  const start = new Date(startDate);
  const end = new Date(endDate);
  if (isNaN(start.getTime()) || isNaN(end.getTime())) {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Invalid dates',
        error: { code: 'VALIDATION_ERROR', message: 'startDate and endDate must be valid dates' },
      },
    };
  }

  if (end < start) {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Invalid date range',
        error: { code: 'VALIDATION_ERROR', message: 'endDate must be on or after startDate' },
      },
    };
  }

  // Scenario: leave_rejection
  if (scenario === 'leave_rejection') {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Leave request rejected',
        error: { code: 'LEAVE_REJECTED', message: 'Leave request rejected by policy (scenario forced)' },
      },
    };
  }

  // Scenario: server_error
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

  // Check for overlap
  const overlap = store.leaveRequests.find((r) => {
    if (r.status === 'REJECTED' || r.status === 'CANCELLED') return false;
    const rStart = new Date(r.startDate);
    const rEnd = new Date(r.endDate);
    return start <= rEnd && end >= rStart;
  });

  if (overlap) {
    return {
      status: 409,
      body: {
        success: false,
        data: null,
        message: 'Leave dates overlap with existing request',
        error: { code: 'OVERLAP', message: `Overlaps with leave request ${overlap.id || overlap.leaveRequestId} (${overlap.startDate} to ${overlap.endDate})` },
      },
    };
  }

  // Check balance
  const days = calculateDays(startDate, endDate);
  const balanceResult = getLeaveBalance();
  const currentBalance = balanceResult.body.data;

  if ((currentBalance[normType] || 0) < days) {
    return {
      status: 422,
      body: {
        success: false,
        data: null,
        message: 'Insufficient leave balance',
        error: { code: 'INSUFFICIENT_BALANCE', message: `Requested ${days} days but only ${currentBalance[normType] || 0} ${normType} leave(s) remaining` },
      },
    };
  }

  const reqId = uuidv4();
  const nowIso = new Date().toISOString();

  // Create the request
  const leaveRequest = {
    id: reqId,
    leaveRequestId: reqId,
    employeeId,
    leaveType: normType.toUpperCase(),
    startDate,
    endDate,
    numberOfDays: days,
    reason: reason || '',
    status: 'PENDING',
    createdAt: nowIso,
    submittedAt: nowIso,
  };

  store.leaveRequests.push(leaveRequest);
  writeStore(store);

  return {
    status: 201,
    body: {
      success: true,
      data: leaveRequest,
      message: 'Leave request submitted successfully (Pending Approval)',
      error: null,
    },
  };
}

function calculateDays(startDate, endDate) {
  const start = new Date(startDate);
  const end = new Date(endDate);
  const diffTime = Math.abs(end - start);
  return Math.ceil(diffTime / (1000 * 60 * 60 * 24)) + 1;
}

module.exports = { getLeaveBalance, getLeaveRequests, submitLeaveRequest };
