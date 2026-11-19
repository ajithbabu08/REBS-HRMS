import 'package:uuid/uuid.dart';

import '../../../../app/config/environment.dart';
import '../../../../core/location/distance_calculator.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/network/api_exceptions.dart';
import '../entities/attendance_event.dart';
import '../repositories/attendance_repository.dart';

class CheckOutUseCase {
  final AttendanceRepository _repository;
  final LocationService _locationService;
  final AppConfig _config;
  final Uuid _uuid;

  CheckOutUseCase({
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
    // 1. Business rule: Check-out requires an existing check-in
    final checkIn = await _repository.getTodayCheckIn(employeeId, companyDate);
    if (checkIn == null) {
      throw const ValidationException(
        'Cannot check out without checking in first.',
        statusCode: 422,
      );
    }

    // 2. Business rule: Cannot check out if already checked out
    final existingCheckOut =
        await _repository.getTodayCheckOut(employeeId, companyDate);
    if (existingCheckOut != null && existingCheckOut.syncStatus != 'REJECTED') {
      throw const ConflictException(
        'You have already checked out today.',
        statusCode: 409,
      );
    }

    // 3. Obtain current GPS & validate radius
    final position = await _locationService.getCurrentPosition();

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

    // 5. Persist locally first (Outbox pattern, localSequence: 2)
    final localEvent = AttendanceEvent(
      eventId: eventId,
      employeeId: employeeId,
      eventType: 'CHECK_OUT',
      eventTimestamp: DateTime.now(),
      latitude: position.latitude,
      longitude: position.longitude,
      officeDistanceMeters: distanceMeters,
      companyDate: companyDate,
      localSequence: 2,
      createdAt: DateTime.now(),
      syncStatus: 'PENDING',
    );

    final savedEvent = await _repository.recordEventLocally(localEvent);

    // 6. Attempt sync if online (Only if checkIn is not rejected)
    if (checkIn.isRejected) {
      return savedEvent;
    }

    return await _repository.syncEvent(savedEvent);
  }
}
