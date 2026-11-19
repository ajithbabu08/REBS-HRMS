import 'package:drift/drift.dart';

/// Cached employee profile table.
@DataClassName('EmployeeEntry')
class EmployeeTable extends Table {
  TextColumn get employeeId => text()();
  TextColumn get name => text()();
  TextColumn get department => text()();
  TextColumn get designation => text()();
  TextColumn get email => text()();
  TextColumn get joinDate => text()();
  RealColumn get officeLatitude => real()();
  RealColumn get officeLongitude => real()();
  RealColumn get officeRadiusMeters => real()();
  TextColumn get companyTimezone => text().withDefault(const Constant('Asia/Kolkata'))();
  DateTimeColumn get lastUpdated => dateTime()();

  @override
  Set<Column> get primaryKey => {employeeId};
}
