import 'dart:async';

import '../database/dao/attendance_dao.dart';
import '../network/api_exceptions.dart';
import '../network/dio_client.dart';
import '../constants/api_endpoints.dart';
import 'sync_result.dart';

/// Contract for syncing pending attendance events to the server.
abstract class SyncService {
  Future<SyncResult> syncPendingEvents();
}

class SyncServiceImpl implements SyncService {
  final AttendanceDao _attendanceDao;
  final DioClient _dioClient;
  bool _isSyncing = false;

  SyncServiceImpl({
    required AttendanceDao attendanceDao,
    required DioClient dioClient,
  })  : _attendanceDao = attendanceDao,
        _dioClient = dioClient;

  @override
  Future<SyncResult> syncPendingEvents() async {
    // Prevent concurrent syncs.
    if (_isSyncing) return const SyncResult();
    _isSyncing = true;

    try {
      final pending = await _attendanceDao.getPendingEvents();
      if (pending.isEmpty) return const SyncResult();

      int synced = 0;
      int rejected = 0;
      int failed = 0;

      for (final event in pending) {
        try {
          // Mark as syncing.
          await _attendanceDao.markSyncing(event.id);

          final response = await _dioClient.post(
            ApiEndpoints.attendanceEvents,
            idempotencyKey: event.eventId,
            data: {
              'eventId': event.eventId,
              'employeeId': event.employeeId,
              'eventType': event.eventType,
              'timestamp': event.eventTimestamp.toIso8601String(),
              'latitude': event.latitude,
              'longitude': event.longitude,
              'officeDistanceMeters': event.officeDistanceMeters,
              'companyDate': event.companyDate,
            },
          );

          final responseData = response.data is Map<String, dynamic>
              ? response.data as Map<String, dynamic>
              : <String, dynamic>{};
          final dataObj = responseData['data'];
          final serverId = dataObj is Map ? dataObj['attendanceId']?.toString() ?? '' : '';
          await _attendanceDao.markSynced(event.id, serverId);
          synced++;
        } on ConflictException catch (e) {
          // 409 — duplicate / conflict → mark REJECTED.
          await _attendanceDao.markRejected(event.id, e.message);
          rejected++;
        } on ValidationException catch (e) {
          // 422 — business validation error → mark REJECTED.
          await _attendanceDao.markRejected(event.id, e.message);
          rejected++;
        } on TimeoutException {
          // Timeout — do NOT regenerate eventId, increment retry, keep PENDING.
          await _attendanceDao.incrementRetryCount(event.id);
          failed++;
          break; // Don't hang on subsequent items if connection is timing out
        } on ServerException {
          // 5xx — transient, increment retry, keep PENDING.
          await _attendanceDao.incrementRetryCount(event.id);
          failed++;
        } on NetworkException {
          // No network — stop trying further events.
          await _attendanceDao.incrementRetryCount(event.id);
          failed++;
          break;
        } catch (_) {
          await _attendanceDao.incrementRetryCount(event.id);
          failed++;
          break;
        }
      }

      return SyncResult(
        synced: synced,
        rejected: rejected,
        failed: failed,
        total: pending.length,
      );
    } finally {
      _isSyncing = false;
    }
  }
}
