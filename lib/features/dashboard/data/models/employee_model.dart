import '../../domain/entities/employee.dart';
import '../../../../core/database/app_database.dart';

class EmployeeModel {
  static Employee fromJson(Map<String, dynamic> json) {
    final officeJson = json['officeLocation'] as Map<String, dynamic>? ?? {};
    return Employee(
      employeeId: json['employeeId'] as String? ?? 'REBS-EMP-001',
      name: json['name'] as String? ?? 'Ajith Babu',
      department: json['department'] as String? ?? 'Engineering',
      designation: json['designation'] as String? ?? 'Flutter Developer',
      email: json['email'] as String? ?? 'ajith.babu@rebs.com',
      joinDate: json['joinDate'] as String? ?? '2024-01-15',
      officeLocation: OfficeLocation(
        latitude: (officeJson['latitude'] as num?)?.toDouble() ?? 10.0159,
        longitude: (officeJson['longitude'] as num?)?.toDouble() ?? 76.3419,
        radiusMeters: (officeJson['radiusMeters'] as num?)?.toDouble() ?? 200.0,
        address: officeJson['address'] as String? ?? 'REBS Technologies, Kochi',
      ),
      companyTimezone: json['companyTimezone'] as String? ?? 'Asia/Kolkata',
    );
  }

  static Employee fromEntry(EmployeeEntry entry) {
    return Employee(
      employeeId: entry.employeeId,
      name: entry.name,
      department: entry.department,
      designation: entry.designation,
      email: entry.email,
      joinDate: entry.joinDate,
      officeLocation: OfficeLocation(
        latitude: entry.officeLatitude,
        longitude: entry.officeLongitude,
        radiusMeters: entry.officeRadiusMeters,
        address: 'Company Office',
      ),
      companyTimezone: entry.companyTimezone,
    );
  }

  static EmployeeTableCompanion toCompanion(Employee employee) {
    return EmployeeTableCompanion.insert(
      employeeId: employee.employeeId,
      name: employee.name,
      department: employee.department,
      designation: employee.designation,
      email: employee.email,
      joinDate: employee.joinDate,
      officeLatitude: employee.officeLocation.latitude,
      officeLongitude: employee.officeLocation.longitude,
      officeRadiusMeters: employee.officeLocation.radiusMeters,
      lastUpdated: DateTime.now(),
    );
  }
}
