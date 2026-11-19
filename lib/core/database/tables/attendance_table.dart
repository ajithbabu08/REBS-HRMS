import 'package:drift/drift.dart';

/// Attendance events table — offline-first with sync status tracking.
@DataClassName('AttendanceEntry')
class AttendanceTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get eventId => text().unique()();
  TextColumn get employeeId => text()();
  TextColumn get eventType => text()(); // CHECK_IN or CHECK_OUT
  DateTimeColumn get eventTimestamp => dateTime()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get officeDistanceMeters => real()();
  TextColumn get companyDate => text()(); // YYYY-MM-DD
  IntColumn get localSequence => integer()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('PENDING'))(); // PENDING/SYNCING/SYNCED/REJECTED
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  TextColumn get serverAttendanceId => text().nullable()();
}
