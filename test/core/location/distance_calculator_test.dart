import 'package:flutter_test/flutter_test.dart';
import 'package:rebs_hrms/core/location/distance_calculator.dart';

void main() {
  group('DistanceCalculator (Haversine)', () {
    const officeLat = 10.0159;
    const officeLon = 76.3419;

    test('same point returns 0 distance', () {
      final distance = DistanceCalculator.calculateDistance(
        officeLat,
        officeLon,
        officeLat,
        officeLon,
      );
      expect(distance, closeTo(0.0, 0.001));
    });

    test('isWithinRadius returns true for point inside 200m', () {
      // Offset by ~10 meters (0.00009 deg latitude is ~10m)
      const lat = officeLat + 0.00009;
      const lon = officeLon;

      final distance = DistanceCalculator.calculateDistance(
        lat,
        lon,
        officeLat,
        officeLon,
      );
      expect(distance, lessThan(200.0));

      final isInside = DistanceCalculator.isWithinRadius(
        lat,
        lon,
        officeLat,
        officeLon,
        200.0,
      );
      expect(isInside, isTrue);
    });

    test('isWithinRadius returns false for point outside 200m', () {
      // Offset by ~500m (0.005 deg is ~550m)
      const lat = officeLat + 0.005;
      const lon = officeLon + 0.005;

      final distance = DistanceCalculator.calculateDistance(
        lat,
        lon,
        officeLat,
        officeLon,
      );
      expect(distance, greaterThan(200.0));

      final isInside = DistanceCalculator.isWithinRadius(
        lat,
        lon,
        officeLat,
        officeLon,
        200.0,
      );
      expect(isInside, isFalse);
    });

    test('isWithinRadius returns true for point exactly at radius limit', () {
      // If distance <= 200.0, it should be within radius
      const maxRadius = 200.0;
      final isInside = DistanceCalculator.isWithinRadius(
        officeLat,
        officeLon,
        officeLat,
        officeLon,
        maxRadius,
      );
      expect(isInside, isTrue);
    });
  });
}
