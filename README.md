# REBS HRMS Employee Workspace

An offline-first, production-quality Flutter mobile application for employee HRMS workspace management. Built with clean architecture, Drift (SQLite) persistent outbox pattern, BLoC/Cubit state management, geofenced GPS validation, idempotent network synchronization, and a dedicated Node.js Express mock backend with switchable test scenarios.

---

## 1. Project Overview

- **Project Name:** REBS HRMS Employee Workspace
- **Target Platforms:** Android & iOS
- **Architecture:** Clean Architecture (Domain, Data, Presentation layers)
- **State Management:** `flutter_bloc` & `Cubit`
- **Persistence:** `drift` with SQLite (Offline-First Outbox Pattern)
- **Networking:** `dio` with custom interceptors, typed exceptions & Idempotency-Key
- **GPS / Geofencing:** `geolocator` with Haversine distance calculation (200m office radius)
- **Timezone:** Asia/Kolkata
- **Preconfigured Employee:** Ajith Babu (`REBS-EMP-001`, Engineering, Flutter Developer)

---

## 2. Screenshots & Screen Captures

Instructions to capture screenshots during live review:
1. **Home / Dashboard:** Launch app with mock server running; view employee profile, live elapsed timer, today attendance card, leave balances, and recent records.
2. **Attendance History:** Navigate to Attendance tab; browse records grouped by date with monthly filter (prev/next month).
3. **Leave Management & Application:** Navigate to Leave tab; view balance breakdown, tap "Apply Leave", fill date range, check calculated calendar days, and submit.
4. **Offline Mode & Outbox:** Toggle Wi-Fi / airplane mode; perform check-in; observe "Check-in saved offline. It will sync when internet is available" banner and orange `Pending Sync` badge.
5. **App Force-Stop & Restart:** Close app completely, reopen; observe offline pending attendance event persists from SQLite.
6. **Sync Now:** Reconnect network; tap `Sync Now` or observe automatic background sync; event updates to green `Synced` badge.
7. **Debug Simulation Panel:** Navigate to Profile > `Open Debug Simulation Panel` to simulate GPS coordinates (Inside vs Outside 200m) and switch mock server scenarios.

---

## 3. Features Implemented

- [x] **Preconfigured Employee Profile:** Name, ID, Designation, Department, Avatar initials loaded from API and cached in SQLite.
- [x] **Today's Attendance Status:** Dynamic states (`Not Checked In`, `Checked In`, `Checked Out`).
- [x] **Live Working Duration Timer:** Periodic timer updating elapsed duration every second while app is active.
- [x] **Single-Tap Prevention:** Action buttons disabled during in-flight asynchronous requests.
- [x] **Geofenced GPS Validation:** Strict 200m radius validation from office coordinates (`10.0159, 76.3419`) using Haversine formula.
- [x] **Offline-First Outbox Pattern:** Attendance events stored in SQLite before network submission with unique UUID.
- [x] **Strict Event Ordering:** Local sequence ordering (`localSequence: 1` for check-in, `2` for check-out); check-out is never synced if check-in is pending or rejected.
- [x] **Idempotent Network Retries:** Client-side UUID sent in payload and `Idempotency-Key` HTTP header. Re-submitting on timeout does not duplicate records.
- [x] **Automatic & Manual Synchronization:** Auto-sync on network reconnect via `connectivity_plus` stream; manual "Sync Now" action with sync lock to prevent concurrent runs.
- [x] **Leave Balance & Application:** Casual Leave (10 days) and Sick Leave (8 days); dynamic calendar days calculation.
- [x] **Comprehensive Leave Validation:**
  - Start date cannot be in the past.
  - End date cannot precede start date.
  - Reason must have at least 10 non-whitespace characters.
  - Requested days cannot exceed remaining balance.
  - Overlap validation against Pending/Approved leave requests (Rejected leaves do not block).
  - Strict network requirement: leave submission blocked when offline with clear user guidance.
- [x] **Attendance History:** Monthly filter (`GET /attendance?month=YYYY-MM`), cached locally in SQLite.
- [x] **Debug Simulation Panel (Debug builds only):**
  - Simulate Inside Office (~10m).
  - Simulate Outside Office (>200m).
  - Clear location override (Real GPS).
  - Switch mock backend scenarios (`normal`, `slow`, `timeout`, `server_error`, `duplicate_conflict`, `leave_rejection`).
  - Reset mock server data.
  - Manual sync trigger with detailed result logs.

---

## 4. Architecture

```
lib/
├── main.dart                          # App entry point & initialization
├── app/
│   ├── app.dart                       # MaterialApp & routing setup
│   ├── main_shell.dart                # Scaffold with NavigationBar (IndexedStack)
│   ├── router.dart                    # Route definitions
│   ├── config/
│   │   ├── app_config.dart            # Configuration singleton & dart-defines
│   │   └── environment.dart           # Environment enum & Office coordinates
│   └── theme/
│       ├── app_colors.dart            # Color palette (Navy primary, status colors)
│       └── app_theme.dart             # Material 3 ThemeData definition
├── core/
│   ├── constants/                     # API endpoints, sync & attendance statuses
│   ├── database/                      # Drift database, tables, DAOs & generated code
│   │   ├── app_database.dart
│   │   ├── tables/                    # Employee, Attendance, Leave tables
│   │   └── dao/                       # EmployeeDao, AttendanceDao, LeaveDao
│   ├── di/
│   │   └── service_locator.dart       # GetIt dependency injection setup
│   ├── location/
│   │   ├── distance_calculator.dart   # Haversine distance calculator
│   │   └── location_service.dart      # Geolocator wrapper with debug override
│   ├── network/
│   │   ├── dio_client.dart            # Dio wrapper with Idempotency-Key header
│   │   ├── api_exceptions.dart        # Typed AppException hierarchy
│   │   └── connectivity_service.dart  # Reactive network connectivity listener
│   ├── sync/
│   │   ├── sync_manager.dart          # Synchronization orchestrator & lock
│   │   ├── sync_service.dart          # Outbox sync implementation
│   │   └── sync_result.dart           # Synced, rejected, failed counters
│   └── widgets/                       # Reusable widgets (Loading, Error, OfflineBanner, Badges)
└── features/
    ├── dashboard/                     # Domain, Data, Presentation (Cubits, Pages, Widgets)
    ├── attendance/                    # Domain, Data, Presentation (Cubits, Pages, Widgets)
    ├── leave/                         # Domain, Data, Presentation (Cubits, Pages, Widgets)
    └── settings/                      # Profile & Debug Simulation Panel
```

---

## 5. Offline-First Outbox Pattern & Sync Flow

```
[ User Action: Check In / Out ]
              │
              ▼
   [ Geofence & Business Validation ]
              │
              ▼
   [ Generate Stable Client UUID ]
              │
              ▼
  [ Insert into SQLite Attendance Table ]
      (syncStatus: 'PENDING')
              │
      ┌───────┴───────┐
      │               │
  [ Online? ]     [ Offline? ]
      │               │
     Yes              No
      │               │
      ▼               ▼
[ Post with UUID ]  [ Retain PENDING in SQLite ]
[ Idempotency-Key ] [ Show Offline Banner ]
      │               │
   ┌──┴──────────┐    │
   │             │    │ (Internet Restores or
Success     409 / 422 │  User taps "Sync Now")
   │             │    │
   ▼             ▼    ▼
Mark SYNCED  Mark REJECTED ──▶ [ SyncManager executes ]
                           ──▶ [ Sequenced Chronological Sync ]
```

### Event Ordering Rule
1. Check-in events always have `localSequence: 1`.
2. Check-out events always have `localSequence: 2`.
3. Outbox queries order by `companyDate ASC, localSequence ASC, eventTimestamp ASC`.
4. If a check-in event fails or is rejected, the corresponding check-out event is never uploaded.

---

## 6. Idempotency & Timeout Handling

Each attendance event generates a stable UUID once on the client (`Uuid.v4()`).
- The UUID is submitted both inside the JSON payload (`eventId`) and in the `Idempotency-Key` HTTP header.
- If a network request times out after the server processes the record:
  1. The client catches `TimeoutException`.
  2. The local record retains its original `eventId` and increments `retryCount`.
  3. On the next sync attempt, the exact same `eventId` is resent.
  4. The mock server detects the existing processed `eventId` and returns the previously generated attendance record with HTTP 200 (no duplicate record is created).

---

## 7. Mock Server & Repeatable Scenarios

The mock server is an Express.js backend located in `/mock_server`.

### Setup & Startup
```bash
cd mock_server
npm install
node src/server.js
```
The server runs by default on `http://localhost:3000`.

### Scenarios
Scenarios can be switched via:
- The in-app **Debug Simulation Panel** (tap scenario chip).
- HTTP POST request: `POST http://localhost:3000/scenarios/set` with body `{"scenario": "<name>"}`.

| Scenario | Behavior | Verified In App |
|---|---|---|
| `normal` | Immediate 200/201 responses | Normal online check-in, leave application |
| `slow` | 3-second delay on all requests | Loading states, progress indicators |
| `timeout` | 30-second delay on attendance submission | Client timeout, event retained as pending |
| `server_error` | Returns HTTP 500 | Transient error handling, retry count incremented |
| `duplicate_conflict` | Returns HTTP 409 Conflict | Attendance event marked REJECTED |
| `leave_rejection` | Returns HTTP 422 Unprocessable | Displays server rejection message |
| `idempotency_test` | Normal execution with replay logging | Verify duplicate submissions return original record |

Reset data to initial state: `POST http://localhost:3000/reset`

---

## 8. Network & Device Configuration (Including ngrok)

### Android Emulator
The Android emulator maps the host machine's `localhost` to `10.0.2.2`.
The default configuration in `lib/app/config/environment.dart` is preconfigured to:
```
http://10.0.2.2:3000
```

### Physical Android / iOS Device (LAN IP)
Find your computer's local IP address (e.g. `192.168.1.150` via `ipconfig` on Windows or `ifconfig` on macOS/Linux).
Run Flutter with:
```bash
flutter run --dart-define=API_BASE_URL=http://192.168.1.150:3000
```

### ngrok Setup for Remote / Demonstration
1. Start your mock server:
   ```bash
   cd mock_server && node src/server.js
   ```
2. Start ngrok tunnel in another terminal:
   ```bash
   ngrok http 3000
   ```
3. Copy the forwarding URL (e.g. `https://xxxx-xx-xx-xx.ngrok-free.app`).
4. Run or build Flutter with the ngrok URL:
   ```bash
   flutter run --dart-define=API_BASE_URL=https://xxxx-xx-xx-xx.ngrok-free.app
   ```
5. Ensure the ngrok tunnel remains active during your demonstration.

---

## 9. Automated Tests

All automated tests use `mocktail` and `flutter_test`. 23 tests pass with 0 failures:

```bash
flutter test
```

### Test Coverage Highlights
- **DistanceCalculator:** Haversine formula distance verification, boundary tests at 0m, 10m, and exactly at 200m limit, rejection outside 200m.
- **CheckInUseCase:** Successful check-in, rejection of duplicate check-in on same company date, rejection outside office radius.
- **CheckOutUseCase:** Rejection of check-out without check-in, rejection of duplicate check-out, proper `localSequence: 2` generation.
- **ApplyLeaveUseCase:** Rejection of past dates, end date preceding start date, reasons < 10 characters, balance exceeded, overlapping pending/approved leaves, non-blocking rejected leaves, and offline submission rejection.
- **SyncService:** Chronological sequencing (check-in first, check-out second), 409 conflict handling, timeout handling with preserved idempotency key.
- **Widget Tests:** `SyncStatusBadge` visual verification across `Pending Sync`, `Synced`, and `Rejected` states.

---

## 10. Building and Installing the APK

### Build Debug APK
```bash
flutter build apk --debug
```
The output file is generated at:
```
build/app/outputs/flutter-apk/app-debug.apk
```

### Install APK on Connected Device or Emulator
```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

---

## 11. Demonstration Video Script (3–5 Minutes)

### Scene 1: Dashboard & Employee Profile (0:00 - 0:45)
- Launch the application.
- Show employee card: Ajith Babu, `REBS-EMP-001`, Engineering, Flutter Developer.
- Point out today's attendance state: "Not Checked In".
- Point out leave balances: Casual Leave (10), Sick Leave (8), Total (18).
- Show recent attendance history cards.

### Scene 2: Online Check-In with Geofence Validation (0:45 - 1:30)
- Ensure mock server is running on `http://10.0.2.2:3000` (or ngrok).
- Open Settings > Debug Simulation Panel. Show that "Inside Office (~10m)" is selected.
- Return to Dashboard and tap **Check In**.
- Observe check-in records immediately, syncs with server, and status transitions to "Checked In" with green `Synced` badge.
- Observe the **Live Elapsed Working Duration** counter ticking up second by second.

### Scene 3: Geofence Rejection Demonstration (1:30 - 2:00)
- Open Debug Panel, tap "Simulate Outside Office (>200m)".
- Show that attempting to check in/out displays the error banner: "You are 550.0m away from the office. Attendance is only permitted within 200m."
- Reset location override back to "Inside Office".

### Scene 4: Offline Attendance & Persistent Outbox (2:00 - 3:00)
- Disconnect network / stop mock server / turn on Airplane Mode.
- Notice the top yellow **Offline Mode** banner appear.
- Tap **Check Out**.
- Observe the event is saved locally: snackbar displays "Check-out saved offline. It will sync when internet is available."
- Badge displays orange `Pending Sync`.
- **Force-close the app completely** and reopen it.
- Show that the pending check-out event and attendance state persisted across app termination via Drift SQLite.

### Scene 5: Automatic & Manual Synchronization (3:00 - 3:45)
- Reconnect network / restart mock server.
- Tap **Sync Now** icon on the AppBar.
- Observe synchronization indicator; badge turns green `Synced`.
- Show that the completed working duration is recorded.

### Scene 6: Leave Application & Validation (3:45 - 4:45)
- Navigate to the **Leave** tab.
- Tap **Apply Leave**.
- Demonstrate local validation:
  - Enter a short reason ("Vacation") -> Validation triggers: "Reason must contain at least 10 non-whitespace characters."
  - Try selecting 15 days -> Validation triggers: exceeds balance.
- Enter a valid request: 2 days casual leave with proper reason.
- Tap **Submit Leave Application**.
- Show request added to the list with `PENDING` badge and balance updated.

---

## 12. Engineering Trade-offs & Production Considerations

1. **Client-Side vs Server-Side GPS Validation:**
   - Client-side GPS validation provides immediate feedback to the employee without unnecessary network roundtrips.
   - In a production environment, device GPS can be spoofed; the production backend must independently perform reverse-geocoding, IP geolocation cross-referencing, and distance validation.
2. **Local Sequence Ordering:**
   - Assigning `localSequence: 1` to check-in and `localSequence: 2` to check-out guarantees that even if timestamps have slight clock drift, the database query always synchronizes check-in before check-out.
3. **Drift SQLite vs Key-Value Store:**
   - Drift provides relational integrity, ACID transactions, and typed queries for date filtering and overlap checks, which are essential for outbox queues compared to unstructured key-value stores.
4. **Idempotency Header:**
   - By attaching `Idempotency-Key: <uuid>`, network retries after dropped responses never produce duplicate attendance records.

---

## 13. AI Tools & Disclosures

- **Assistant:** Antigravity AI (Powered by Gemini / Claude models).
- **Development Effort:** ~8 hours equivalent engineering effort.
- **Scope Delimiters:** Authentication omitted as specified; preconfigured employee profile used.
