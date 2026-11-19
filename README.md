# REBS HRMS Employee Workspace

An offline-first, production-grade Flutter mobile application for employee workplace attendance and leave management. Built with **Clean Architecture**, **Drift (SQLite) persistent outbox pattern**, **BLoC/Cubit state management**, **geofenced GPS validation (200m)**, **idempotent network synchronization**, and a companion Node.js Express backend deployed live to the cloud.

---

## 1. Quick Review & Live Evaluation Links

* **Live Cloud Backend (Zero Setup Required):** [`https://rebs-hrms.onrender.com`](https://rebs-hrms.onrender.com)
  * Health check: [`https://rebs-hrms.onrender.com/health`](https://rebs-hrms.onrender.com/health)
* **GitHub Repository:** [`https://github.com/ajithbabu08/REBS-HRMS`](https://github.com/ajithbabu08/REBS-HRMS)
* **Company:** Teqbae Innovations & Solutions India Pvt Ltd
* **Office Location:** AKL Heights, Seaport - Airport Road, Thrikkakara, Kakkanad, Kochi, Kerala 682021
* **Office GPS Coordinates:** `10.0303° N, 76.3358° E` (200m Geofence Radius)
* **Default Employee Profile:** Ajith Babu (`REBS-EMP-001`, Engineering, Flutter Developer)

> [!NOTE]
> **Cold Start Note for Live Cloud:** The backend is deployed on Render's free tier. If it hasn't received requests in 15 minutes, the first request may take ~30–40 seconds to wake up from sleep. Subsequent requests respond in milliseconds.

---

## 2. Requirements & Compliance Checklist

All project and evaluation requirements are met and verified:

| Requirement | Implementation Detail | Status |
| :--- | :--- | :---: |
| **`package.json` contains `start` script** | `"start": "node src/server.js"` configured in `mock_server/package.json` |  |
| **Server listens on `process.env.PORT`** | `const PORT = process.env.PORT \|\| config.port \|\| 3000` |  |
| **No hardcoded localhost URL** | Parameterized via `--dart-define=API_BASE_URL=...` and live cloud default |  |
| **No passwords or secret keys uploaded** | Scanned workspace & secured `.gitignore` against `.env` and `node_modules` |  |
| **Custom App Icon & Splash Screen** | Enterprise branding with animated splash screen & multi-density mipmaps |  |
| **Offline-First Outbox Pattern** | Events saved in SQLite outbox first with UUID; deterministic sequence order |  |
| **200m Geofencing** | Haversine distance formula strictly enforced before capture |  |
| **Idempotency** | Client UUID sent in body and `Idempotency-Key` header; retries never duplicate |  |
| **All Automated Tests Pass** | 23 unit and widget tests passing (`flutter test`) |  |

---

## 3. How the Application Works

### A. Online Mode (With Internet)
* **Instant Workplace Sync:** On startup, the app loads cached data in <5ms, then synchronizes latest employee profile, leave balances, and today's attendance in the background.
* **Real-Time Attendance:** When inside the 200m office radius, tapping **Check In** or **Check Out** captures device GPS coordinates, creates an event with a unique UUID, records it locally in SQLite, and immediately syncs it with the backend (`SYNCED` green badge).
* **Live Elapsed Working Duration:** While on an active shift today, a dynamic live timer calculates and increments elapsed working time second-by-second (`00:00:00`).
* **Leave Applications:** Submits leave requests with full client-side validation (dates, non-empty reason, remaining balance check). Submissions are recorded with enterprise `PENDING` status.

### B. Offline Mode (Without Internet / Airplane Mode)
* **Persistent SQLite Outbox:** If an employee has no cellular or Wi-Fi connection, attendance can still be marked as long as they are physically within the 200m office radius.
* **Deterministic Sequencing:** 
  * Check-In is assigned `localSequence: 1`.
  * Check-Out is assigned `localSequence: 2`.
  * Check-Out is never submitted before Check-In is confirmed by the backend.
* **Visual Status:** Displays top warning: *"Offline Mode — Cached data displayed"* and an orange `Pending Sync` badge on the record card.
* **App Restart Persistence:** If the user completely closes, force-stops, or restarts the phone while offline, all un-synced events remain safely preserved in the Drift SQLite database.
* **Leave Restriction:** Offline leave applications are intentionally rejected with a clear message: *"Leave application requires an active internet connection"*, preventing desynchronized balance conflicts.

### C. Automatic & Manual Synchronization Flow
* **Reactive Auto-Sync:** When internet connectivity returns, `connectivity_plus` automatically triggers `SyncManager` in the background to flush pending outbox events chronologically.
* **Manual "Sync Now":** The user can tap **"Sync Now"** in the top banner at any time to immediately flush pending events.
* **Conflict Reconciliation:** If a local check-in conflicts with an existing server record (HTTP 409), the event is marked `REJECTED`, and the app immediately downloads the server's authoritative record to ensure zero data corruption and no negative durations.

---

## 4. Architecture Overview

Built using **Clean Architecture** with separation of concerns:

```
lib/
├── app/
│   ├── app.dart                       # MaterialApp entry & themes
│   ├── main_shell.dart                # Bottom navigation shell (IndexedStack)
│   ├── router.dart                    # App route definitions
│   ├── config/environment.dart        # Environment settings & office coordinates
│   └── theme/                         # Material 3 Navy & Emerald palette
├── core/
│   ├── database/                      # Drift SQLite database, tables & DAOs
│   ├── di/service_locator.dart        # GetIt dependency injection registry
│   ├── location/                      # Haversine DistanceCalculator & LocationService
│   ├── network/                       # DioClient with auto-fallback & typed exceptions
│   ├── sync/                          # SyncManager, SyncService & Outbox engine
│   └── widgets/                       # Sync badges, offline banners, custom tiles
└── features/
    ├── splash/                        # Animated corporate splash screen
    ├── dashboard/                     # Home workspace dashboard & live shift timer
    ├── attendance/                    # Check-In/Out use cases, history & monthly view
    ├── leave/                         # Leave balance tracking & application workflow
    └── settings/                      # Profile & Debug Simulation Panel
```

---

## 5. Testing & Evaluation Guide

You can evaluate the project using any of the following 3 backend setups:

### Option 1: Live Cloud Backend (Recommended — Zero Setup)
The app is already configured to connect to the live cloud backend:
```
https://rebs-hrms.onrender.com
```
* No local server or terminal commands required!
* Open the app on your phone or emulator and test immediately.

---

### Option 2: Local Mock Server (Offline / Local Dev)

If you prefer to run the backend locally on your computer:

1. **Start the Mock Server:**
   ```bash
   cd mock_server
   npm install
   npm start
   ```
   *The server starts on port `3000` (`http://localhost:3000`).*

2. **Choose your device connection:**
   * **Android Emulator:** Automatically routes to `http://10.0.2.2:3000`.
   * **Physical Android Phone over USB:** Run `adb reverse tcp:3000 tcp:3000`, and the phone connects via `http://127.0.0.1:3000`.
   * **Physical Android Phone over Wi-Fi (No Cable):** Ensure phone and computer are on the same Wi-Fi. In the app's **Debug Simulation Panel**, tap the **Wi-Fi (`192.168.1.8:3000`)** preset.

---

### Option 3: ngrok Tunnel

If you want to tunnel your local machine's mock server to the internet:

1. **Start your local mock server:**
   ```bash
   cd mock_server && npm start
   ```
2. **Start ngrok in a separate terminal:**
   ```bash
   ngrok http 3000
   ```
3. **Copy the generated HTTPS URL** (e.g. `https://xxxx.ngrok-free.app`).
4. **Set it in the app:**
   Open the app > go to **Profile** > tap **Open Debug Simulation Panel** > tap **Configure / Switch API URL** > paste the ngrok URL and tap **Apply**.

---

## 6. How to Test Key Features & Scenarios

### Test 1: Geofenced Attendance (Inside vs. Outside Office)
1. Open the app and navigate to **Profile > Open Debug Simulation Panel**.
2. **Test Outside Office:** Tap **Outside Office (>200m)**. Return to Home and tap **Check In**.
   * *Expected Result:* Red banner: *"You are 550.0m away from the office. Attendance is only permitted within 200m."*
3. **Test Inside Office:** Tap **Inside Office (~10m)** (or use real GPS if physically at the Kakkanad office). Return to Home and tap **Check In**.
   * *Expected Result:* Check-in succeeds, timer starts ticking, and record shows `Synced`.

---

### Test 2: Offline Attendance & Outbox Persistence
1. While checked in, turn on **Airplane Mode** (or disconnect Wi-Fi / Mobile Data).
2. The top orange banner appears: *"Offline Mode — Cached data displayed"*.
3. Tap **Check Out**.
   * *Expected Result:* Check-out succeeds locally. Status updates to *"Today's Attendance Completed"*, and the top banner shows *"1 attendance event pending sync"*.
4. **Force-close the app completely** from recent apps and reopen it.
   * *Expected Result:* The offline-recorded check-out and pending sync state are fully restored from local SQLite.
5. Turn off Airplane Mode (reconnect internet).
   * *Expected Result:* The app auto-syncs or tap **Sync Now**; the record updates to `Synced` with green indicator.

---

### Test 3: Leave Application & Validation
1. Navigate to the **Leave** tab.
2. Initial balances: **Casual Leave (2)**, **Sick Leave (3)**.
3. Tap **+ Apply**.
4. Test validation rules:
   * Select a start date in the past -> Blocked.
   * Enter a short reason like `"Sick"` (< 10 chars) -> Blocked: *"Reason must contain at least 10 non-whitespace characters"*.
   * Select days exceeding remaining balance -> Blocked: *"Requested days exceed available balance"*.
5. Submit a valid application (e.g. 1 day Casual Leave with reason: `"Family medical appointment"`).
   * *Expected Result:* Request is created with `PENDING` badge, and leave balance updates.

---

### Test 4: Mock Server Failure Scenarios (Resilience Testing)
Navigate to **Profile > Open Debug Simulation Panel**:
* **B: Slow API (3s):** Injects 3-second latency. Verifies app responsiveness and loading indicators.
* **C: Timeout Simulation:** Induces connection timeout. Verifies that the client retains the outbox event as `PENDING`, increments `retryCount`, and preserves idempotency.
* **D: Server Error (500):** Simulates transient 500 error. Verifies clean error snackbar and retry queue.
* **E: Duplicate Conflict (409):** Simulates duplicate submission. Verifies client handles conflict by reconciling with server records.
* **F: Leave Rejection (422):** Simulates business rejection. Verifies balance is protected.
* **Reset Mock Server Data:** Resets all attendance and leave records back to initial seeds.

---

## 7. Running Automated Tests

Run the test suite from the project root:

```bash
flutter test
```

### Coverage Highlights (23 Tests, 0 Failures):
* `distance_calculator_test.dart`: Haversine formula distance verification, boundary tests at 0m, 10m, and exactly at 200m limit, rejection outside 200m.
* `check_in_usecase_test.dart`: Successful check-in, duplicate prevention on the same date, radius enforcement.
* `check_out_usecase_test.dart`: Check-out without check-in validation, duplicate checkout prevention, `localSequence: 2` validation.
* `apply_leave_usecase_test.dart`: Past date rejection, invalid range, reason character length, balance checks, overlapping request prevention, offline restriction.
* `sync_service_test.dart`: Chronological sequence preservation (check-in before check-out), 409 conflict handling, timeout handling with preserved idempotency key.
* `widget_test.dart`: Visual state tests for `SyncStatusBadge` across `Pending Sync`, `Synced`, and `Rejected`.

---

## 8. Building the Android APK

### A. Recommended: Split-per-ABI Release Build (~18 MB)
```bash
flutter build apk --release --split-per-abi
```
Generates lightweight architecture-specific APKs in `build/app/outputs/flutter-apk/`:
* `app-arm64-v8a-release.apk` *(for modern 64-bit Android devices)*

### B. Direct ARM64 Debug Build
```bash
flutter build apk --debug --target-platform android-arm64
```

### C. Install on Connected Device
```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```
