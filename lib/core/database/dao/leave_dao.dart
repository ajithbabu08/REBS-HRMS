import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/leave_balance_table.dart';
import '../tables/leave_request_table.dart';

part 'leave_dao.g.dart';

@DriftAccessor(tables: [LeaveBalanceTable, LeaveRequestTable])
class LeaveDao extends DatabaseAccessor<AppDatabase> with _$LeaveDaoMixin {
  LeaveDao(super.db);

  // ── Leave Balance ──────────────────────────────────────────────────

  /// Get the cached leave balance.
  Future<LeaveBalanceEntry?> getBalance(String employeeId) {
    return (select(leaveBalanceTable)
          ..where((t) => t.employeeId.equals(employeeId)))
        .getSingleOrNull();
  }

  /// Insert or update leave balance.
  Future<void> upsertBalance(LeaveBalanceTableCompanion entry) {
    return into(leaveBalanceTable).insertOnConflictUpdate(entry);
  }

  // ── Leave Requests ──────────────────────────────────────────────────

  /// Get all leave requests for an employee.
  Future<List<LeaveRequestEntry>> getRequests(String employeeId) {
    return (select(leaveRequestTable)
          ..where((t) => t.employeeId.equals(employeeId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.submittedAt),
          ]))
        .get();
  }

  /// Watch all leave requests for reactive UI.
  Stream<List<LeaveRequestEntry>> watchRequests(String employeeId) {
    return (select(leaveRequestTable)
          ..where((t) => t.employeeId.equals(employeeId))
          ..orderBy([
            (t) => OrderingTerm.desc(t.submittedAt),
          ]))
        .watch();
  }

  /// Insert a new leave request.
  Future<int> insertRequest(LeaveRequestTableCompanion entry) {
    return into(leaveRequestTable).insert(entry);
  }

  /// Update an existing leave request.
  Future<int> updateRequest(String leaveRequestId, LeaveRequestTableCompanion entry) {
    return (update(leaveRequestTable)
          ..where((t) => t.leaveRequestId.equals(leaveRequestId)))
        .write(entry);
  }

  /// Get overlapping leave requests for validation.
  Future<List<LeaveRequestEntry>> getOverlapping({
    required String employeeId,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return (select(leaveRequestTable)
          ..where((t) =>
              t.employeeId.equals(employeeId) &
              t.status.isNotIn(['REJECTED']) &
              t.startDate.isSmallerOrEqualValue(endDate) &
              t.endDate.isBiggerOrEqualValue(startDate)))
        .get();
  }

  /// Replace all cached leave requests (after a full sync).
  Future<void> replaceAll(
      String employeeId, List<LeaveRequestTableCompanion> entries) async {
    await transaction(() async {
      await (delete(leaveRequestTable)
            ..where((t) => t.employeeId.equals(employeeId)))
          .go();
      for (final entry in entries) {
        await into(leaveRequestTable).insert(entry);
      }
    });
  }

  /// Reset leave balances to default (casual: 2, sick: 3) and delete all cached requests (for testing resets).
  Future<void> resetLeaveData(String employeeId, {int casual = 2, int sick = 3}) async {
    await transaction(() async {
      await (delete(leaveRequestTable)
            ..where((t) => t.employeeId.equals(employeeId)))
          .go();
      await into(leaveBalanceTable).insertOnConflictUpdate(
        LeaveBalanceTableCompanion(
          employeeId: Value(employeeId),
          casual: Value(casual),
          sick: Value(sick),
          lastSyncedAt: Value(DateTime.now()),
        ),
      );
    });
  }
}
