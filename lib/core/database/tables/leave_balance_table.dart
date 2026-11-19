import 'package:drift/drift.dart';

/// Leave balance cache table.
@DataClassName('LeaveBalanceEntry')
class LeaveBalanceTable extends Table {
  TextColumn get employeeId => text()();
  IntColumn get casualLeaves => integer()();
  IntColumn get sickLeaves => integer()();
  DateTimeColumn get lastUpdated => dateTime()();

  @override
  Set<Column> get primaryKey => {employeeId};
}
