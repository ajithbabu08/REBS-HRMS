import '../../../../core/database/dao/employee_dao.dart';
import '../models/employee_model.dart';
import '../../domain/entities/employee.dart';

abstract class DashboardLocalDataSource {
  Future<Employee?> getEmployee();
  Future<void> saveEmployee(Employee employee);
}

class DashboardLocalDataSourceImpl implements DashboardLocalDataSource {
  final EmployeeDao _employeeDao;

  DashboardLocalDataSourceImpl({required EmployeeDao employeeDao})
      : _employeeDao = employeeDao;

  @override
  Future<Employee?> getEmployee() async {
    final entry = await _employeeDao.getEmployee();
    return entry != null ? EmployeeModel.fromEntry(entry) : null;
  }

  @override
  Future<void> saveEmployee(Employee employee) {
    return _employeeDao.upsertEmployee(EmployeeModel.toCompanion(employee));
  }
}
