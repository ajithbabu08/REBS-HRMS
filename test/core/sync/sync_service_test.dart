import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rebs_hrms/core/database/app_database.dart';
import 'package:rebs_hrms/core/database/dao/attendance_dao.dart';
import 'package:rebs_hrms/core/network/api_exceptions.dart';
import 'package:rebs_hrms/core/network/dio_client.dart';
import 'package:rebs_hrms/core/sync/sync_service.dart';

class MockAttendanceDao extends Mock implements AttendanceDao {}

class MockDioClient extends Mock implements DioClient {}

void main() {
  late SyncServiceImpl syncService;
  late MockAttendanceDao mockAttendanceDao;
  late MockDioClient mockDioClient;

  setUp(() {
    mockAttendanceDao = MockAttendanceDao();
    mockDioClient = MockDioClient();
    syncService = SyncServiceImpl(
      attendanceDao: mockAttendanceDao,
      dioClient: mockDioClient,
    );
  });

  group('SyncService & Outbox Ordering', () {
    final checkInEntry = AttendanceEntry(
      id: 1,
      eventId: 'event-uuid-in',
      employeeId: 'REBS-EMP-001',
      eventType: 'CHECK_IN',
      eventTimestamp: DateTime.parse('2026-11-19 09:00:00'),
      latitude: 10.0159,
      longitude: 76.3419,
      officeDistanceMeters: 10.0,
      companyDate: '2026-11-19',
      localSequence: 1,
      createdAt: DateTime.now(),
      syncStatus: 'PENDING',
      retryCount: 0,
    );

    final checkOutEntry = AttendanceEntry(
      id: 2,
      eventId: 'event-uuid-out',
      employeeId: 'REBS-EMP-001',
      eventType: 'CHECK_OUT',
      eventTimestamp: DateTime.parse('2026-11-19 18:00:00'),
      latitude: 10.0159,
      longitude: 76.3419,
      officeDistanceMeters: 10.0,
      companyDate: '2026-11-19',
      localSequence: 2,
      createdAt: DateTime.now(),
      syncStatus: 'PENDING',
      retryCount: 0,
    );

    test('Pending events are synced in deterministic sequence (check-in first, then check-out)', () async {
      // Returned ordered by DAO
      when(() => mockAttendanceDao.getPendingEvents())
          .thenAnswer((_) async => [checkInEntry, checkOutEntry]);

      when(() => mockAttendanceDao.markSyncing(any())).thenAnswer((_) async => 1);
      when(() => mockAttendanceDao.markSynced(any(), any())).thenAnswer((_) async => 1);

      final callOrder = <String>[];

      when(() => mockDioClient.post(
            any(),
            idempotencyKey: any(named: 'idempotencyKey'),
            data: any(named: 'data'),
          )).thenAnswer((inv) async {
        final data = inv.namedArguments[#data] as Map<String, dynamic>;
        callOrder.add(data['eventType'] as String);
        return Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 201,
          data: {
            'success': true,
            'data': {'attendanceId': 'srv-${data['eventType']}'},
          },
        );
      });

      final result = await syncService.syncPendingEvents();

      expect(result.synced, 2);
      expect(result.rejected, 0);
      expect(result.failed, 0);

      // Verify strict chronological sequence
      expect(callOrder, ['CHECK_IN', 'CHECK_OUT']);
      verify(() => mockDioClient.post(
            any(),
            idempotencyKey: 'event-uuid-in',
            data: any(named: 'data'),
          )).called(1);
      verify(() => mockDioClient.post(
            any(),
            idempotencyKey: 'event-uuid-out',
            data: any(named: 'data'),
          )).called(1);
    });

    test('Server 409 conflict marks event as REJECTED with reason', () async {
      when(() => mockAttendanceDao.getPendingEvents())
          .thenAnswer((_) async => [checkInEntry]);
      when(() => mockAttendanceDao.markSyncing(1)).thenAnswer((_) async => 1);
      when(() => mockAttendanceDao.markRejected(1, any())).thenAnswer((_) async => 1);

      when(() => mockDioClient.post(
            any(),
            idempotencyKey: any(named: 'idempotencyKey'),
            data: any(named: 'data'),
          )).thenThrow(const ConflictException(
        'Attendance already exists for this date.',
        statusCode: 409,
      ));

      final result = await syncService.syncPendingEvents();

      expect(result.synced, 0);
      expect(result.rejected, 1);
      expect(result.failed, 0);
      verify(() => mockAttendanceDao.markRejected(
            1,
            'Attendance already exists for this date.',
          )).called(1);
    });

    test('Timeout preserves event as PENDING and increments retryCount without regenerating eventId', () async {
      when(() => mockAttendanceDao.getPendingEvents())
          .thenAnswer((_) async => [checkInEntry]);
      when(() => mockAttendanceDao.markSyncing(1)).thenAnswer((_) async => 1);
      when(() => mockAttendanceDao.incrementRetryCount(1)).thenAnswer((_) async => {});

      when(() => mockDioClient.post(
            any(),
            idempotencyKey: any(named: 'idempotencyKey'),
            data: any(named: 'data'),
          )).thenThrow(const TimeoutException('Request timed out'));

      final result = await syncService.syncPendingEvents();

      expect(result.synced, 0);
      expect(result.rejected, 0);
      expect(result.failed, 1);
      verify(() => mockAttendanceDao.incrementRetryCount(1)).called(1);
      verifyNever(() => mockAttendanceDao.markRejected(any(), any()));
      verifyNever(() => mockAttendanceDao.markSynced(any(), any()));
    });
  });
}
