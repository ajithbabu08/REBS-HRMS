import 'package:equatable/equatable.dart';

class OfficeLocation extends Equatable {
  final double latitude;
  final double longitude;
  final double radiusMeters;
  final String address;

  const OfficeLocation({
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.address,
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusMeters, address];
}

class Employee extends Equatable {
  final String employeeId;
  final String name;
  final String department;
  final String designation;
  final String email;
  final String joinDate;
  final OfficeLocation officeLocation;
  final String companyTimezone;

  const Employee({
    required this.employeeId,
    required this.name,
    required this.department,
    required this.designation,
    required this.email,
    required this.joinDate,
    required this.officeLocation,
    this.companyTimezone = 'Asia/Kolkata',
  });

  @override
  List<Object?> get props => [
        employeeId,
        name,
        department,
        designation,
        email,
        joinDate,
        officeLocation,
        companyTimezone,
      ];
}
