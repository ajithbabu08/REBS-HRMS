import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rebs_hrms/app/config/environment.dart';
import 'package:rebs_hrms/core/location/location_service.dart';
import 'package:rebs_hrms/core/network/api_exceptions.dart';
import 'package:rebs_hrms/features/attendance/domain/entities/attendance_event.dart';
import 'package:rebs_hrms/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:rebs_hrms/features/attendance/domain/usecases/check_out_usecase.dart';

class MockAttendanceRepository extends Mock implements AttendanceRepository {}

class MockLocationService extends Mock implements LocationService {}

void main() {
  late CheckOutUseCase useCase;
  late MockAttendanceRepository mockRepository;
  late MockLocationService mockLocationService;
  late AppConfig config;

  setUpAll(() {
    registerFallbackValue(AttendanceEvent(
      eventId: 'fallback',
      employeeId: 'fallback',
      eventType: 'CHECK_OUT',
      eventTimestamp: DateTime.now(),
      latitude: 10.0159,
      longitude: 76.3419,
      officeDistanceMeters: 10.0,
      companyDate: '2026-11-19',
      localSequence: 2,
      createdAt: DateTime.now(),
    ));
  });

  setUp(() {
    mockRepository = MockAttendanceRepository();
    mockLocationService = MockLocationService();
    config = const AppConfig(
      environment: Environment.dev,
      apiBaseUrl: 'http://localhost:3000',
      officeLatitude: 10.0159,
      officeLongitude: 76.3419,
      officeRadiusMeters: 200.0,
    );
    useCase = CheckOutUseCase(
      repository: mockRepository,
      locationService: mockLocationService,
      config: config,
    );
  });

  group('CheckOutUseCase', () {
    const employeeId = 'REBS-EMP-001';
    const companyDate = '2026-11-19';

    test('Check-out without check-in is rejected (throws ValidationException)', () async {
      // Given: No check-in exists today
      when(() => mockRepository.getTodayCheckIn(employeeId, companyDate))
          .thenAnswer((_) async => null);

      // When & Then: Check-out must fail with ValidationException
      expect(
        () => useCase.execute(
          employeeId: employeeId,
          companyDate: companyDate,
        ),
        throwsA(isA<ValidationException>().having(
          (e) => e.message,
          'message',
          contains('Cannot check out without checking in first'),
        )),
      );

      verifyNever(() => mockRepository.recordEventLocally(any()));
    });

    test('Duplicate check-out is rejected (throws ConflictException)', () async {
      // Given: check-in exists AND check-out already exists
      final checkInEvent = AttendanceEvent(
        eventId: 'in-1',
        employeeId: employeeId,
        eventType: 'CHECK_IN',
        eventTimestamp: DateTime.now(),
        latitude: 10.0159,
        longitude: 76.3419,
        officeDistanceMeters: 10.0,
        companyDate: companyDate,
        localSequence: 1,
        createdAt: DateTime.now(),
        syncStatus: 'SYNCED',
      );
      final checkOutEvent = AttendanceEvent(
        eventId: 'out-1',
        employeeId: employeeId,
        eventType: 'CHECK_OUT',
        eventTimestamp: DateTime.now(),
        latitude: 10.0159,
        longitude: 76.3419,
        officeDistanceMeters: 10.0,
        companyDate: companyDate,
        localSequence: 2,
        createdAt: DateTime.now(),
        syncStatus: 'SYNCED',
      );

      when(() => mockRepository.getTodayCheckIn(employeeId, companyDate))
          .thenAnswer((_) async => checkInEvent);
      when(() => mockRepository.getTodayCheckOut(employeeId, companyDate))
          .thenAnswer((_) async => checkOutEvent);

      expect(
        () => useCase.execute(
          employeeId: employeeId,
          companyDate: companyDate,
        ),
        throwsA(isA<ConflictException>().having(
          (e) => e.message,
          'message',
          contains('already checked out today'),
        )),
      );
    });

    test('Successful check-out creates event with sequence 2 and syncs', () async {
      final checkInEvent = AttendanceEvent(
        eventId: 'in-1',
        employeeId: employeeId,
        eventType: 'CHECK_IN',
        eventTimestamp: DateTime.now(),
        latitude: 10.0159,
        longitude: 76.3419,
        officeDistanceMeters: 10.0,
        companyDate: companyDate,
        localSequence: 1,
        createdAt: DateTime.now(),
        syncStatus: 'SYNCED',
      );

      when(() => mockRepository.getTodayCheckIn(employeeId, companyDate))
          .thenAnswer((_) async => checkInEvent);
      when(() => mockRepository.getTodayCheckOut(employeeId, companyDate))
          .thenAnswer((_) async => null);

      when(() => mockLocationService.getCurrentPosition()).thenAnswer(
        (_) async => Position(
          latitude: 10.0159,
          longitude: 76.3419,
          timestamp: DateTime.now(),
          accuracy: 5.0,
          altitude: 10.0,
          altitudeAccuracy: 1.0,
          heading: 0.0,
          headingAccuracy: 1.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        ),
      );

      when(() => mockRepository.recordEventLocally(any()))
          .thenAnswer((inv) async => inv.positionalArguments[0] as AttendanceEvent);

      when(() => mockRepository.syncEvent(any()))
          .thenAnswer((inv) async => inv.positionalArguments[0] as AttendanceEvent);

      final result = await useCase.execute(
        employeeId: employeeId,
        companyDate: companyDate,
      );

      expect(result.eventType, 'CHECK_OUT');
      expect(result.localSequence, 2);
      expect(result.employeeId, employeeId);
      verify(() => mockRepository.recordEventLocally(any())).called(1);
      verify(() => mockRepository.syncEvent(any())).called(1);
    });
  });
}
