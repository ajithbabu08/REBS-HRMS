import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/attendance_table.dart';

part 'attendance_dao.g.dart';

@DriftAccessor(tables: [AttendanceTable])
class AttendanceDao extends DatabaseAccessor<AppDatabase>
    with _$AttendanceDaoMixin {
  AttendanceDao(super.db);

  /// Insert a new attendance event.
  Future<int> insertEvent(AttendanceTableCompanion entry) {
    return into(attendanceTable).insert(entry);
  }

  /// Get all PENDING events ordered for sync:
  /// by employeeId, companyDate, localSequence, eventTimestamp.
  Future<List<AttendanceEntry>> getPendingEvents() {
    return (select(attendanceTable)
          ..where((t) => t.syncStatus.equals('PENDING'))
          ..orderBy([
            (t) => OrderingTerm.asc(t.employeeId),
            (t) => OrderingTerm.asc(t.companyDate),
            (t) => OrderingTerm.asc(t.localSequence),
            (t) => OrderingTerm.asc(t.eventTimestamp),
          ]))
        .get();
  }

  /// Get attendance records for a given month (YYYY-MM).
  Future<List<AttendanceEntry>> getByMonth(String yearMonth) {
    return (select(attendanceTable)
          ..where((t) => t.companyDate.like('$yearMonth%'))
          ..orderBy([
            (t) => OrderingTerm.asc(t.companyDate),
            (t) => OrderingTerm.asc(t.localSequence),
          ]))
        .get();
  }

  /// Get today's attendance events.
  Future<List<AttendanceEntry>> getToday(String todayDate) {
    return (select(attendanceTable)
          ..where((t) => t.companyDate.equals(todayDate))
          ..orderBy([
            (t) => OrderingTerm.asc(t.localSequence),
          ]))
        .get();
  }

  /// Watch today's attendance events for reactive UI.
  Stream<List<AttendanceEntry>> watchToday(String todayDate) {
    return (select(attendanceTable)
          ..where((t) => t.companyDate.equals(todayDate))
          ..orderBy([
            (t) => OrderingTerm.asc(t.localSequence),
          ]))
        .watch();
  }

  /// Get a single event by its unique eventId.
  Future<AttendanceEntry?> getByEventId(String eventId) {
    return (select(attendanceTable)
          ..where((t) => t.eventId.equals(eventId)))
        .getSingleOrNull();
  }

  /// Mark event as SYNCING.
  Future<int> markSyncing(int id) {
    return (update(attendanceTable)..where((t) => t.id.equals(id))).write(
      AttendanceTableCompanion(
        syncStatus: const Value('SYNCING'),
        lastAttemptAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark event as SYNCED with server ID.
  Future<int> markSynced(int id, String serverAttendanceId) {
    return (update(attendanceTable)..where((t) => t.id.equals(id))).write(
      AttendanceTableCompanion(
        syncStatus: const Value('SYNCED'),
        serverAttendanceId: Value(serverAttendanceId),
        lastAttemptAt: Value(DateTime.now()),
      ),
    );
  }

  /// Mark event as REJECTED with error.
  Future<int> markRejected(int id, String error) {
    return (update(attendanceTable)..where((t) => t.id.equals(id))).write(
      AttendanceTableCompanion(
        syncStatus: const Value('REJECTED'),
        lastError: Value(error),
        lastAttemptAt: Value(DateTime.now()),
      ),
    );
  }

  /// Increment retry count after a transient failure.
  Future<void> incrementRetryCount(int id) async {
    final event = await (select(attendanceTable)
          ..where((t) => t.id.equals(id)))
        .getSingle();
    await (update(attendanceTable)..where((t) => t.id.equals(id))).write(
      AttendanceTableCompanion(
        retryCount: Value(event.retryCount + 1),
        lastAttemptAt: Value(DateTime.now()),
        syncStatus: const Value('PENDING'),
      ),
    );
  }

  /// Count of pending events.
  Future<int> getPendingCount() async {
    final count = attendanceTable.id.count();
    final query = selectOnly(attendanceTable)
      ..addColumns([count])
      ..where(attendanceTable.syncStatus.equals('PENDING'));
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  /// Delete rejected events for a given companyDate.
  Future<int> deleteRejectedEventsForDate(String date) {
    return (delete(attendanceTable)
          ..where((t) =>
              t.companyDate.equals(date) &
              t.syncStatus.equals('REJECTED')))
        .go();
  }

  /// Delete all attendance events for a specific date (for testing/simulation resets).
  Future<int> deleteEventsForDate(String date) {
    return (delete(attendanceTable)
          ..where((t) => t.companyDate.equals(date)))
        .go();
  }

  /// Delete all attendance events (for full testing resets).
  Future<int> clearAllEvents() {
    return delete(attendanceTable).go();
  }
}
