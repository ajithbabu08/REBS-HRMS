import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../network/api_exceptions.dart';
import '../../app/config/environment.dart';

/// Contract for getting the device's GPS position.
abstract class LocationService {
  /// Get the current GPS position.
  Future<Position> getCurrentPosition();

  /// Open device location settings so user can enable GPS.
  Future<bool> openLocationSettings();

  /// Open app settings so user can grant permissions.
  Future<bool> openAppSettings();

  /// Set a simulated position for debug/testing only.
  void setDebugOverride({double? latitude, double? longitude});

  /// Clear the debug override.
  void clearDebugOverride();

  /// Current debug override if any.
  (double, double)? get currentDebugOverride;
}

/// Exception when location permission is denied.
class LocationPermissionDeniedException extends AppException {
  final bool isPermanent;

  const LocationPermissionDeniedException({this.isPermanent = false})
      : super(isPermanent
            ? 'Location permission permanently denied. Enable in Settings.'
            : 'Location permission denied.');
}

/// Exception when location services are disabled.
class LocationServiceDisabledException extends AppException {
  const LocationServiceDisabledException()
      : super('Location services are disabled. Please enable GPS.');
}

/// Exception when device is outside the 200m allowed office radius.
class OutsideOfficeRadiusException extends AppException {
  final double distanceMeters;
  final double maxAllowedMeters;

  OutsideOfficeRadiusException({
    required this.distanceMeters,
    required this.maxAllowedMeters,
  }) : super(
            'You are ${(distanceMeters).toStringAsFixed(1)}m away from the office. Attendance is only permitted within ${maxAllowedMeters.toInt()}m.');
}

/// Implementation using [geolocator].
class LocationServiceImpl implements LocationService {
  final AppConfig _config;
  double? _debugLat;
  double? _debugLon;

  LocationServiceImpl({required AppConfig config}) : _config = config {
    if (kDebugMode && _config.hasDebugLocationOverride) {
      _debugLat = _config.debugLatitude;
      _debugLon = _config.debugLongitude;
    }
  }

  @override
  Future<bool> openLocationSettings() => Geolocator.openLocationSettings();

  @override
  Future<bool> openAppSettings() => Geolocator.openAppSettings();

  @override
  void setDebugOverride({double? latitude, double? longitude}) {
    if (kDebugMode) {
      _debugLat = latitude;
      _debugLon = longitude;
    }
  }

  @override
  void clearDebugOverride() {
    _debugLat = null;
    _debugLon = null;
  }

  @override
  (double, double)? get currentDebugOverride {
    if (_debugLat != null && _debugLon != null) {
      return (_debugLat!, _debugLon!);
    }
    return null;
  }

  @override
  Future<Position> getCurrentPosition() async {
    // Debug simulation bypass (only in debug mode)
    if (kDebugMode && _debugLat != null && _debugLon != null) {
      return Position(
        latitude: _debugLat!,
        longitude: _debugLon!,
        timestamp: DateTime.now(),
        accuracy: 5.0,
        altitude: 10.0,
        altitudeAccuracy: 1.0,
        heading: 0.0,
        headingAccuracy: 1.0,
        speed: 0.0,
        speedAccuracy: 0.0,
      );
    }

    // 1. Check if location services are enabled.
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const LocationServiceDisabledException();
    }

    // 2. Check / request permission.
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw const LocationPermissionDeniedException();
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw const LocationPermissionDeniedException(isPermanent: true);
    }

    // 3. Get position.
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }
}
