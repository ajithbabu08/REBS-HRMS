# REBS HRMS Mock Server

A Node.js Express mock backend for the REBS HRMS Flutter application.

## Setup

```bash
cd mock_server
npm install
node src/server.js
```

Server starts on `http://localhost:3000` (configurable via `PORT` env var).

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/employee/me` | Get employee profile |
| GET | `/attendance?month=YYYY-MM` | Get attendance records for a month |
| POST | `/attendance/events` | Submit check-in/check-out event |
| GET | `/leave/balance` | Get remaining leave balance |
| GET | `/leave/requests` | List all leave requests |
| POST | `/leave/requests` | Submit a new leave request |
| GET | `/scenarios/current` | Get active scenario |
| POST | `/scenarios/set` | Switch scenario |
| POST | `/reset` | Reset all data to defaults |
| GET | `/health` | Health check |

## Scenarios

Switch via `POST /scenarios/set` with body `{ "scenario": "<name>" }`:

| Scenario | Behavior |
|----------|----------|
| `normal` | Everything works normally |
| `slow` | 3-second delay on all API responses |
| `timeout` | 30-second delay; event is saved before delay (tests idempotent retry) |
| `server_error` | Returns 500 on all API endpoints |
| `duplicate_conflict` | Returns 409 for attendance events |
| `leave_rejection` | Rejects leave requests with validation error |
| `idempotency_test` | Normal behavior but logs idempotent replays |

## Idempotency

POST `/attendance/events` supports idempotency via:
- `Idempotency-Key` request header, or
- `eventId` in the request body

Duplicate requests with the same key return the cached response without re-processing.

## Data Persistence

Data is stored in `data/store.json`. Use `POST /reset` to restore defaults.

Pre-seeded data:
- Attendance records for weekdays in the first 15 days of the current month
- Leave balance: 10 casual, 8 sick
