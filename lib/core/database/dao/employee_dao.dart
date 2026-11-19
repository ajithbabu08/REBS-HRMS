import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/employee_table.dart';

part 'employee_dao.g.dart';

@DriftAccessor(tables: [EmployeeTable])
class EmployeeDao extends DatabaseAccessor<AppDatabase>
    with _$EmployeeDaoMixin {
  EmployeeDao(super.db);

  /// Get the cached employee profile.
  Future<EmployeeEntry?> getEmployee() async {
    return (select(employeeTable)..limit(1)).getSingleOrNull();
  }

  /// Insert or replace the cached employee.
  Future<void> upsertEmployee(EmployeeTableCompanion entry) async {
    await into(employeeTable).insertOnConflictUpdate(entry);
  }

  /// Delete all cached employees.
  Future<int> clearAll() => delete(employeeTable).go();
}
