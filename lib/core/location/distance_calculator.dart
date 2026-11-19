import 'dart:math';

/// Utility for distance calculations using the Haversine formula.
abstract final class DistanceCalculator {
  static const double _earthRadiusMeters = 6371000.0;

  /// Calculate the distance in meters between two coordinates.
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return _earthRadiusMeters * c;
  }

  /// Whether [lat],[lon] is within [radiusMeters] of the office.
  static bool isWithinRadius(
    double lat,
    double lon,
    double officeLat,
    double officeLon,
    double radiusMeters,
  ) {
    return calculateDistance(lat, lon, officeLat, officeLon) <= radiusMeters;
  }

  static double _toRadians(double degrees) => degrees * pi / 180.0;
}
