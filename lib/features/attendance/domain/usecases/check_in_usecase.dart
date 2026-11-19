import 'package:uuid/uuid.dart';

import '../../../../app/config/environment.dart';
import '../../../../core/location/distance_calculator.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/network/api_exceptions.dart';
import '../entities/attendance_event.dart';
import '../repositories/attendance_repository.dart';

class CheckInUseCase {
  final AttendanceRepository _repository;
  final LocationService _locationService;
  final AppConfig _config;
  final Uuid _uuid;

  CheckInUseCase({
    required AttendanceRepository repository,
    required LocationService locationService,
    required AppConfig config,
    Uuid? uuid,
  })  : _repository = repository,
        _locationService = locationService,
        _config = config,
        _uuid = uuid ?? const Uuid();

  Future<AttendanceEvent> execute({
    required String employeeId,
    required String companyDate,
  }) async {
    // 1. Business rule: only one check-in allowed per company date
    final existingCheckIn =
        await _repository.getTodayCheckIn(employeeId, companyDate);
    if (existingCheckIn != null && existingCheckIn.syncStatus != 'REJECTED') {
      throw const ConflictException(
        'You have already checked in today.',
        statusCode: 409,
      );
    }

    // 2. Obtain current GPS coordinates & validate permissions
    final position = await _locationService.getCurrentPosition();

    // 3. Validate office radius (200m)
    final distanceMeters = DistanceCalculator.calculateDistance(
      position.latitude,
      position.longitude,
      _config.officeLatitude,
      _config.officeLongitude,
    );

    if (distanceMeters > _config.officeRadiusMeters) {
      throw OutsideOfficeRadiusException(
        distanceMeters: distanceMeters,
        maxAllowedMeters: _config.officeRadiusMeters,
      );
    }

    // 4. Generate stable UUID
    final eventId = _uuid.v4();

    // 5. Persist locally first (Outbox pattern)
    final localEvent = AttendanceEvent(
      eventId: eventId,
      employeeId: employeeId,
      eventType: 'CHECK_IN',
      eventTimestamp: DateTime.now(),
      latitude: position.latitude,
      longitude: position.longitude,
      officeDistanceMeters: distanceMeters,
      companyDate: companyDate,
      localSequence: 1,
      createdAt: DateTime.now(),
      syncStatus: 'PENDING',
    );

    final savedEvent = await _repository.recordEventLocally(localEvent);

    // 6. Attempt sync if online (returns updated event if synced, or pending if offline/transient)
    return await _repository.syncEvent(savedEvent);
  }
}
