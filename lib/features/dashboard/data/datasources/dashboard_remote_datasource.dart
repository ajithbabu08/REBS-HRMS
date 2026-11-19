import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/employee_model.dart';
import '../../domain/entities/employee.dart';

abstract class DashboardRemoteDataSource {
  Future<Employee> getEmployeeProfile();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final DioClient _dioClient;

  DashboardRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Employee> getEmployeeProfile() async {
    final response = await _dioClient.get(ApiEndpoints.employeeMe);
    final map = response.data is Map ? response.data as Map : {};
    final data = map['data'] is Map ? map['data'] as Map<String, dynamic> : <String, dynamic>{};
    return EmployeeModel.fromJson(data);
  }
}
