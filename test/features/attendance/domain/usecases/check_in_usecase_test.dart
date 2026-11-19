import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rebs_hrms/app/config/environment.dart';
import 'package:rebs_hrms/core/location/location_service.dart';
import 'package:rebs_hrms/core/network/api_exceptions.dart';
import 'package:rebs_hrms/features/attendance/domain/entities/attendance_event.dart';
import 'package:rebs_hrms/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:rebs_hrms/features/attendance/domain/usecases/check_in_usecase.dart';

class MockAttendanceRepository extends Mock implements AttendanceRepository {}

class MockLocationService extends Mock implements LocationService {}

void main() {
  late CheckInUseCase useCase;
  late MockAttendanceRepository mockRepository;
  late MockLocationService mockLocationService;
  late AppConfig config;

  setUpAll(() {
    registerFallbackValue(AttendanceEvent(
      eventId: 'fallback',
      employeeId: 'fallback',
      eventType: 'CHECK_IN',
      eventTimestamp: DateTime.now(),
      latitude: 10.0159,
      longitude: 76.3419,
      officeDistanceMeters: 10.0,
      companyDate: '2026-11-19',
      localSequence: 1,
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
    useCase = CheckInUseCase(
      repository: mockRepository,
      locationService: mockLocationService,
      config: config,
    );
  });

  group('CheckInUseCase', () {
    const employeeId = 'REBS-EMP-001';
    const companyDate = '2026-11-19';

    test('Duplicate check-in on the same company date is rejected (throws ConflictException)', () async {
      // Given: check-in already recorded today
      final existing = AttendanceEvent(
        eventId: 'in-exist',
        employeeId: employeeId,
        eventType: 'CHECK_IN',
        eventTimestamp: DateTime.now(),
        latitude: 10.0159,
        longitude: 76.3419,
        officeDistanceMeters: 15.0,
        companyDate: companyDate,
        localSequence: 1,
        createdAt: DateTime.now(),
        syncStatus: 'SYNCED',
      );

      when(() => mockRepository.getTodayCheckIn(employeeId, companyDate))
          .thenAnswer((_) async => existing);

      // When & Then
      expect(
        () => useCase.execute(
          employeeId: employeeId,
          companyDate: companyDate,
        ),
        throwsA(isA<ConflictException>().having(
          (e) => e.message,
          'message',
          contains('already checked in today'),
        )),
      );

      verifyNever(() => mockRepository.recordEventLocally(any()));
    });

    test('Check-in outside 200m office radius is rejected (throws OutsideOfficeRadiusException)', () async {
      when(() => mockRepository.getTodayCheckIn(employeeId, companyDate))
          .thenAnswer((_) async => null);

      // Location 500m+ away
      when(() => mockLocationService.getCurrentPosition()).thenAnswer(
        (_) async => Position(
          latitude: 10.0259, // ~1.1km away
          longitude: 76.3519,
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

      expect(
        () => useCase.execute(
          employeeId: employeeId,
          companyDate: companyDate,
        ),
        throwsA(isA<OutsideOfficeRadiusException>()),
      );

      verifyNever(() => mockRepository.recordEventLocally(any()));
    });

    test('Successful check-in creates event locally and triggers sync', () async {
      when(() => mockRepository.getTodayCheckIn(employeeId, companyDate))
          .thenAnswer((_) async => null);

      // Location right at office (~10m)
      when(() => mockLocationService.getCurrentPosition()).thenAnswer(
        (_) async => Position(
          latitude: 10.01595,
          longitude: 76.34195,
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

      expect(result.eventType, 'CHECK_IN');
      expect(result.localSequence, 1);
      expect(result.syncStatus, 'PENDING');
      expect(result.officeDistanceMeters, lessThan(200.0));
      verify(() => mockRepository.recordEventLocally(any())).called(1);
      verify(() => mockRepository.syncEvent(any())).called(1);
    });
  });
}
