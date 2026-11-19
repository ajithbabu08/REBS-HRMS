import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rebs_hrms/core/network/api_exceptions.dart';
import 'package:rebs_hrms/core/network/connectivity_service.dart';
import 'package:rebs_hrms/features/leave/domain/entities/leave_balance.dart';
import 'package:rebs_hrms/features/leave/domain/entities/leave_request.dart';
import 'package:rebs_hrms/features/leave/domain/repositories/leave_repository.dart';
import 'package:rebs_hrms/features/leave/domain/usecases/apply_leave_usecase.dart';

class MockLeaveRepository extends Mock implements LeaveRepository {}

class MockConnectivityService extends Mock implements ConnectivityService {}

void main() {
  late ApplyLeaveUseCase useCase;
  late MockLeaveRepository mockRepository;
  late MockConnectivityService mockConnectivity;

  setUp(() {
    mockRepository = MockLeaveRepository();
    mockConnectivity = MockConnectivityService();
    useCase = ApplyLeaveUseCase(
      repository: mockRepository,
      connectivityService: mockConnectivity,
    );
  });

  group('ApplyLeaveUseCase', () {
    const employeeId = 'REBS-EMP-001';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final nextWeek = today.add(const Duration(days: 7));

    test('Offline submission is rejected with NetworkException', () async {
      // Given: Offline
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => false);

      expect(
        () => useCase.execute(
          employeeId: employeeId,
          leaveType: 'CASUAL',
          startDate: tomorrow,
          endDate: tomorrow,
          reason: 'Valid reason with 10+ characters',
        ),
        throwsA(isA<NetworkException>().having(
          (e) => e.message,
          'message',
          contains('Leave applications require an internet connection'),
        )),
      );

      verifyNever(() => mockRepository.submitLeaveRequest(
            employeeId: any(named: 'employeeId'),
            leaveType: any(named: 'leaveType'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
            reason: any(named: 'reason'),
          ));
    });

    test('Start date in the past is rejected with ValidationException', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      final yesterday = today.subtract(const Duration(days: 1));

      expect(
        () => useCase.execute(
          employeeId: employeeId,
          leaveType: 'CASUAL',
          startDate: yesterday,
          endDate: today,
          reason: 'Valid reason with 10+ characters',
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.message,
          'message',
          contains('Start date cannot be in the past'),
        )),
      );
    });

    test('End date before start date is rejected with ValidationException', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);

      expect(
        () => useCase.execute(
          employeeId: employeeId,
          leaveType: 'CASUAL',
          startDate: tomorrow,
          endDate: today,
          reason: 'Valid reason with 10+ characters',
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.message,
          'message',
          contains('End date cannot be before start date'),
        )),
      );
    });

    test('Reason with less than 10 non-whitespace characters is rejected', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);

      expect(
        () => useCase.execute(
          employeeId: employeeId,
          leaveType: 'CASUAL',
          startDate: tomorrow,
          endDate: tomorrow,
          reason: 'Short   ', // only 5 characters
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.message,
          'message',
          contains('Reason must contain at least 10 characters'),
        )),
      );
    });

    test('Requested days exceeding leave balance is rejected', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      // Balance is only 2 casual leaves
      when(() => mockRepository.getLeaveBalance(employeeId))
          .thenAnswer((_) async => const LeaveBalance(casual: 2, sick: 5));

      // Request 5 days of casual leave
      final start = today.add(const Duration(days: 1));
      final end = today.add(const Duration(days: 5)); // 5 days

      expect(
        () => useCase.execute(
          employeeId: employeeId,
          leaveType: 'CASUAL',
          startDate: start,
          endDate: end,
          reason: 'Family vacation for 5 days',
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.message,
          'message',
          contains('exceeds your available Casual Leave balance'),
        )),
      );
    });

    test('Overlap with PENDING leave request is rejected', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockRepository.getLeaveBalance(employeeId))
          .thenAnswer((_) async => const LeaveBalance(casual: 10, sick: 8));

      // Existing pending leave for same range
      final pendingLeave = LeaveRequest(
        leaveRequestId: 'req-1',
        employeeId: employeeId,
        leaveType: 'CASUAL',
        startDate: tomorrow,
        endDate: nextWeek,
        reason: 'Existing pending leave',
        status: 'PENDING',
        submittedAt: now,
        numberOfDays: 7,
      );

      when(() => mockRepository.getOverlappingLeaves(
            employeeId: employeeId,
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => [pendingLeave]);

      expect(
        () => useCase.execute(
          employeeId: employeeId,
          leaveType: 'CASUAL',
          startDate: tomorrow,
          endDate: nextWeek,
          reason: 'Another application overlapping',
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.message,
          'message',
          contains('overlap with an existing PENDING leave request'),
        )),
      );
    });

    test('Overlap with REJECTED leave does NOT block new application', () async {
      when(() => mockConnectivity.isConnected).thenAnswer((_) async => true);
      when(() => mockRepository.getLeaveBalance(employeeId))
          .thenAnswer((_) async => const LeaveBalance(casual: 10, sick: 8));

      // Overlapping list returns empty because DAO filters out REJECTED requests
      when(() => mockRepository.getOverlappingLeaves(
            employeeId: employeeId,
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          )).thenAnswer((_) async => []);

      final expectedRequest = LeaveRequest(
        leaveRequestId: 'req-new',
        employeeId: employeeId,
        leaveType: 'CASUAL',
        startDate: tomorrow,
        endDate: tomorrow,
        reason: 'Fresh application on previously rejected date',
        status: 'PENDING',
        submittedAt: now,
        numberOfDays: 1,
      );

      when(() => mockRepository.submitLeaveRequest(
            employeeId: employeeId,
            leaveType: 'CASUAL',
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
            reason: any(named: 'reason'),
          )).thenAnswer((_) async => expectedRequest);

      final result = await useCase.execute(
        employeeId: employeeId,
        leaveType: 'CASUAL',
        startDate: tomorrow,
        endDate: tomorrow,
        reason: 'Fresh application on previously rejected date',
      );

      expect(result.status, 'PENDING');
      verify(() => mockRepository.submitLeaveRequest(
            employeeId: employeeId,
            leaveType: 'CASUAL',
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
            reason: any(named: 'reason'),
          )).called(1);
    });
  });
}
