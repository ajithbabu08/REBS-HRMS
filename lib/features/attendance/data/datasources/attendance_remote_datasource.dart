import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../models/attendance_event_model.dart';
import '../../domain/entities/attendance_event.dart';

abstract class AttendanceRemoteDataSource {
  Future<String> submitEvent(AttendanceEvent event);
  Future<List<Map<String, dynamic>>> getMonthlyAttendance(String month);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  final DioClient _dioClient;

  AttendanceRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<String> submitEvent(AttendanceEvent event) async {
    final response = await _dioClient.post(
      ApiEndpoints.attendanceEvents,
      idempotencyKey: event.eventId,
      data: AttendanceEventModel.toJson(event),
    );

    final map = response.data is Map ? response.data as Map : {};
    final dataObj = map['data'] is Map ? map['data'] as Map : {};
    return dataObj['attendanceId']?.toString() ?? '';
  }

  @override
  Future<List<Map<String, dynamic>>> getMonthlyAttendance(String month) async {
    final response = await _dioClient.get(
      ApiEndpoints.attendance,
      queryParameters: {'month': month},
    );

    final map = response.data is Map ? response.data as Map : {};
    final list = map['data'] is List ? map['data'] as List : [];
    return list.cast<Map<String, dynamic>>();
  }
}
