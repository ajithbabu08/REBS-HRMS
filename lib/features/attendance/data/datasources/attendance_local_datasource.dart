import '../../../../core/database/dao/attendance_dao.dart';
import '../models/attendance_event_model.dart';
import '../../domain/entities/attendance_event.dart';

abstract class AttendanceLocalDataSource {
  Future<AttendanceEvent> insertEvent(AttendanceEvent event);
  Future<List<AttendanceEvent>> getPendingEvents();
  Future<List<AttendanceEvent>> getTodayEvents(String todayDate);
  Stream<List<AttendanceEvent>> watchTodayEvents(String todayDate);
  Future<List<AttendanceEvent>> getMonthEvents(String month);
  Future<int> getPendingCount();
  Future<void> markSyncing(int id);
  Future<void> markSynced(int id, String serverId);
  Future<void> markRejected(int id, String error);
  Future<void> incrementRetryCount(int id);
  Future<void> clearRemoteEventsForMonth(String month);
  Future<void> deleteRejectedEventsForDate(String date);
}

class AttendanceLocalDataSourceImpl implements AttendanceLocalDataSource {
  final AttendanceDao _attendanceDao;

  AttendanceLocalDataSourceImpl({required AttendanceDao attendanceDao})
      : _attendanceDao = attendanceDao;

  @override
  Future<AttendanceEvent> insertEvent(AttendanceEvent event) async {
    final companion = AttendanceEventModel.toCompanion(event);
    final id = await _attendanceDao.insertEvent(companion);
    final saved = await _attendanceDao.getByEventId(event.eventId);
    if (saved != null) {
      return AttendanceEventModel.fromEntry(saved);
    }
    return AttendanceEvent(
      id: id,
      eventId: event.eventId,
      employeeId: event.employeeId,
      eventType: event.eventType,
      eventTimestamp: event.eventTimestamp,
      latitude: event.latitude,
      longitude: event.longitude,
      officeDistanceMeters: event.officeDistanceMeters,
      companyDate: event.companyDate,
      localSequence: event.localSequence,
      createdAt: event.createdAt,
      syncStatus: event.syncStatus,
    );
  }

  @override
  Future<List<AttendanceEvent>> getPendingEvents() async {
    final entries = await _attendanceDao.getPendingEvents();
    return entries.map(AttendanceEventModel.fromEntry).toList();
  }

  @override
  Future<List<AttendanceEvent>> getTodayEvents(String todayDate) async {
    final entries = await _attendanceDao.getToday(todayDate);
    return entries.map(AttendanceEventModel.fromEntry).toList();
  }

  @override
  Stream<List<AttendanceEvent>> watchTodayEvents(String todayDate) {
    return _attendanceDao
        .watchToday(todayDate)
        .map((entries) => entries.map(AttendanceEventModel.fromEntry).toList());
  }

  @override
  Future<List<AttendanceEvent>> getMonthEvents(String month) async {
    final entries = await _attendanceDao.getByMonth(month);
    return entries.map(AttendanceEventModel.fromEntry).toList();
  }

  @override
  Future<int> getPendingCount() => _attendanceDao.getPendingCount();

  @override
  Future<void> markSyncing(int id) => _attendanceDao.markSyncing(id);

  @override
  Future<void> markSynced(int id, String serverId) =>
      _attendanceDao.markSynced(id, serverId);

  @override
  Future<void> markRejected(int id, String error) =>
      _attendanceDao.markRejected(id, error);

  @override
  Future<void> incrementRetryCount(int id) =>
      _attendanceDao.incrementRetryCount(id);

  @override
  Future<void> clearRemoteEventsForMonth(String month) async {
    await _attendanceDao.customStatement(
      "DELETE FROM attendance_table WHERE company_date LIKE '$month%' AND event_id LIKE 'remote-%'",
    );
  }

  @override
  Future<void> deleteRejectedEventsForDate(String date) =>
      _attendanceDao.deleteRejectedEventsForDate(date);
}
