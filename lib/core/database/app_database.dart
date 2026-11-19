import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/employee_table.dart';
import 'tables/attendance_table.dart';
import 'tables/leave_balance_table.dart';
import 'tables/leave_request_table.dart';
import 'dao/employee_dao.dart';
import 'dao/attendance_dao.dart';
import 'dao/leave_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    EmployeeTable,
    AttendanceTable,
    LeaveBalanceTable,
    LeaveRequestTable,
  ],
  daos: [
    EmployeeDao,
    AttendanceDao,
    LeaveDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// For testing — accept a custom [QueryExecutor].
  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'rebs_hrms.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
