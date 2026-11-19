import 'package:drift/drift.dart';

/// Leave request table for local caching and offline support.
@DataClassName('LeaveRequestEntry')
class LeaveRequestTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get leaveRequestId => text().unique()();
  TextColumn get employeeId => text()();
  TextColumn get leaveType => text()(); // CASUAL or SICK
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  TextColumn get reason => text()();
  TextColumn get status =>
      text().withDefault(const Constant('PENDING'))(); // PENDING/APPROVED/REJECTED
  DateTimeColumn get submittedAt => dateTime()();
  IntColumn get numberOfDays => integer()();
  DateTimeColumn get lastUpdated => dateTime()();
}
