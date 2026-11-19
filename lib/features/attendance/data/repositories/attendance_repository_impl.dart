import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/connectivity_service.dart';
import '../datasources/attendance_local_datasource.dart';
import '../datasources/attendance_remote_datasource.dart';
import '../../domain/entities/attendance_event.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceLocalDataSource _localDataSource;
  final AttendanceRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;

  AttendanceRepositoryImpl({
    required AttendanceLocalDataSource localDataSource,
    required AttendanceRemoteDataSource remoteDataSource,
    required ConnectivityService connectivityService,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _connectivityService = connectivityService;

  @override
  Future<AttendanceEvent> recordEventLocally(AttendanceEvent event) async {
    return _localDataSource.insertEvent(event);
  }

  @override
  Future<AttendanceEvent> syncEvent(AttendanceEvent event) async {
    final isConnected = await _connectivityService.isConnected;
    if (!isConnected || event.id == null) {
      return event;
    }

    try {
      await _localDataSource.markSyncing(event.id!);
      final serverId = await _remoteDataSource.submitEvent(event);
      await _localDataSource.markSynced(event.id!, serverId);
      return AttendanceEvent(
        id: event.id,
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
        syncStatus: 'SYNCED',
        serverAttendanceId: serverId,
      );
    } on ConflictException catch (e) {
      await _localDataSource.markRejected(event.id!, e.message);
      return AttendanceEvent(
        id: event.id,
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
        syncStatus: 'REJECTED',
        lastError: e.message,
      );
    } on ValidationException catch (e) {
      await _localDataSource.markRejected(event.id!, e.message);
      return AttendanceEvent(
        id: event.id,
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
        syncStatus: 'REJECTED',
        lastError: e.message,
      );
    } catch (_) {
      await _localDataSource.incrementRetryCount(event.id!);
      return event;
    }
  }

  @override
  Future<AttendanceRecord> getTodayAttendance(
      String employeeId, String todayDate) async {
    final events = await _localDataSource.getTodayEvents(todayDate);
    return _eventsToRecord(todayDate, events);
  }

  @override
  Stream<AttendanceRecord> watchTodayAttendance(
      String employeeId, String todayDate) {
    return _localDataSource
        .watchTodayEvents(todayDate)
        .map((events) => _eventsToRecord(todayDate, events));
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceHistory(
      String employeeId, String month) async {
    // If online, fetch and cache remote records
    final isConnected = await _connectivityService.isConnected;
    if (isConnected) {
      try {
        final remoteRecords = await _remoteDataSource
            .getMonthlyAttendance(month)
            .timeout(const Duration(seconds: 3));

        // Clear previously cached remote events for this month to sync with latest server state
        await _localDataSource.clearRemoteEventsForMonth(month);

        for (final item in remoteRecords) {
          final date = item['date'] as String? ?? '';
          if (date.isEmpty) continue;

          // Process Check In
          if (item['checkIn'] != null) {
            final checkInObj = item['checkIn'] as Map<String, dynamic>;
            final eventId = checkInObj['eventId'] as String? ?? 'remote-in-$date';
            final existing = await _localDataSource.getMonthEvents(date);
            final hasValidIn = existing.any((e) => e.eventType == 'CHECK_IN' && e.syncStatus != 'REJECTED');
            if (!hasValidIn) {
              await _localDataSource.deleteRejectedEventsForDate(date);
              await _localDataSource.insertEvent(AttendanceEvent(
                eventId: eventId,
                employeeId: employeeId,
                eventType: 'CHECK_IN',
                eventTimestamp: DateTime.tryParse(checkInObj['timestamp']?.toString() ?? '') ?? DateTime.now(),
                latitude: (checkInObj['latitude'] as num?)?.toDouble() ?? 10.0303,
                longitude: (checkInObj['longitude'] as num?)?.toDouble() ?? 76.3358,
                officeDistanceMeters: (checkInObj['officeDistanceMeters'] as num?)?.toDouble() ?? 10.0,
                companyDate: date,
                localSequence: 1,
                createdAt: DateTime.now(),
                syncStatus: 'SYNCED',
                serverAttendanceId: item['attendanceId']?.toString(),
              ));
            }
          }

          // Process Check Out
          if (item['checkOut'] != null) {
            final checkOutObj = item['checkOut'] as Map<String, dynamic>;
            final eventId = checkOutObj['eventId'] as String? ?? 'remote-out-$date';
            final existing = await _localDataSource.getMonthEvents(date);
            final hasValidOut = existing.any((e) => e.eventType == 'CHECK_OUT' && e.syncStatus != 'REJECTED');
            if (!hasValidOut) {
              await _localDataSource.deleteRejectedEventsForDate(date);
              await _localDataSource.insertEvent(AttendanceEvent(
                eventId: eventId,
                employeeId: employeeId,
                eventType: 'CHECK_OUT',
                eventTimestamp: DateTime.tryParse(checkOutObj['timestamp']?.toString() ?? '') ?? DateTime.now(),
                latitude: (checkOutObj['latitude'] as num?)?.toDouble() ?? 10.0303,
                longitude: (checkOutObj['longitude'] as num?)?.toDouble() ?? 76.3358,
                officeDistanceMeters: (checkOutObj['officeDistanceMeters'] as num?)?.toDouble() ?? 10.0,
                companyDate: date,
                localSequence: 2,
                createdAt: DateTime.now(),
                syncStatus: 'SYNCED',
                serverAttendanceId: item['attendanceId']?.toString(),
              ));
            }
          }
        }
      } catch (_) {
        // Fall back gracefully to cache
      }
    }

    final localEvents = await _localDataSource.getMonthEvents(month);
    return _groupEventsByDate(localEvents);
  }

  @override
  Future<List<AttendanceRecord>> getRecentAttendance(String employeeId,
      {int limit = 5}) async {
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    final history = await getAttendanceHistory(employeeId, currentMonth);
    return history.take(limit).toList();
  }

  @override
  Future<int> getPendingCount() => _localDataSource.getPendingCount();

  @override
  Future<AttendanceEvent?> getTodayCheckIn(
      String employeeId, String todayDate) async {
    final events = await _localDataSource.getTodayEvents(todayDate);
    try {
      final valid = events.where((e) => e.eventType == 'CHECK_IN' && e.syncStatus != 'REJECTED');
      if (valid.isNotEmpty) return valid.first;
      return events.firstWhere((e) => e.eventType == 'CHECK_IN');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<AttendanceEvent?> getTodayCheckOut(
      String employeeId, String todayDate) async {
    final events = await _localDataSource.getTodayEvents(todayDate);
    try {
      final valid = events.where((e) => e.eventType == 'CHECK_OUT' && e.syncStatus != 'REJECTED');
      if (valid.isNotEmpty) return valid.first;
      return events.firstWhere((e) => e.eventType == 'CHECK_OUT');
    } catch (_) {
      return null;
    }
  }

  AttendanceRecord _eventsToRecord(String date, List<AttendanceEvent> events) {
    final checkIns = events.where((e) => e.eventType == 'CHECK_IN').toList();
    final checkOuts = events.where((e) => e.eventType == 'CHECK_OUT').toList();

    AttendanceEvent? inEvent;
    if (checkIns.isNotEmpty) {
      inEvent = checkIns.firstWhere(
        (e) => e.syncStatus == 'SYNCED',
        orElse: () => checkIns.firstWhere(
          (e) => e.syncStatus == 'PENDING',
          orElse: () => checkIns.last,
        ),
      );
    }

    AttendanceEvent? outEvent;
    if (checkOuts.isNotEmpty) {
      outEvent = checkOuts.firstWhere(
        (e) => e.syncStatus == 'SYNCED',
        orElse: () => checkOuts.firstWhere(
          (e) => e.syncStatus == 'PENDING',
          orElse: () => checkOuts.last,
        ),
      );
    }

    // Safety checks against mismatched records or rejected ghost events:
    if (inEvent != null && outEvent != null) {
      if (inEvent.syncStatus == 'REJECTED' && outEvent.syncStatus == 'SYNCED') {
        inEvent = null;
      } else if (outEvent.eventTimestamp.isBefore(inEvent.eventTimestamp)) {
        if (inEvent.syncStatus == 'REJECTED') {
          inEvent = null;
        } else if (outEvent.syncStatus == 'REJECTED') {
          outEvent = null;
        }
      }
    }

    return AttendanceRecord(
      date: date,
      checkIn: inEvent,
      checkOut: outEvent,
    );
  }

  List<AttendanceRecord> _groupEventsByDate(List<AttendanceEvent> events) {
    final map = <String, List<AttendanceEvent>>{};
    for (final e in events) {
      map.putIfAbsent(e.companyDate, () => []).add(e);
    }

    final records = map.entries.map((entry) {
      return _eventsToRecord(entry.key, entry.value);
    }).toList();

    // Sort newest date first
    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  @override
  Future<void> resetTodayAttendance(String todayDate) async {
    await _localDataSource.deleteEventsForDate(todayDate);
  }

  @override
  Future<void> clearAllAttendance() async {
    await _localDataSource.clearAllEvents();
  }
}
