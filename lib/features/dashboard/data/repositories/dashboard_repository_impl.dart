import '../../../../core/network/connectivity_service.dart';
import '../../../attendance/domain/entities/attendance_record.dart';
import '../../../attendance/domain/repositories/attendance_repository.dart';
import '../../../leave/domain/entities/leave_balance.dart';
import '../../../leave/domain/repositories/leave_repository.dart';
import '../datasources/dashboard_local_datasource.dart';
import '../datasources/dashboard_remote_datasource.dart';
import '../../domain/entities/dashboard_data.dart';
import '../../domain/entities/employee.dart';
import '../../domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardLocalDataSource _localDataSource;
  final DashboardRemoteDataSource _remoteDataSource;
  final AttendanceRepository _attendanceRepository;
  final LeaveRepository _leaveRepository;
  final ConnectivityService _connectivityService;

  static const _defaultEmployee = Employee(
    employeeId: 'REBS-EMP-001',
    name: 'Ajith Babu',
    department: 'Engineering',
    designation: 'Flutter Developer',
    email: 'ajith.babu@rebs.com',
    joinDate: '2024-01-15',
    officeLocation: OfficeLocation(
      latitude: 10.0303,
      longitude: 76.3358,
      radiusMeters: 200,
      address: 'Teqbae Innovations & Solutions India Pvt Ltd, AKL Heights, Kakkanad',
    ),
    companyTimezone: 'Asia/Kolkata',
  );

  DashboardRepositoryImpl({
    required DashboardLocalDataSource localDataSource,
    required DashboardRemoteDataSource remoteDataSource,
    required AttendanceRepository attendanceRepository,
    required LeaveRepository leaveRepository,
    required ConnectivityService connectivityService,
  })  : _localDataSource = localDataSource,
        _remoteDataSource = remoteDataSource,
        _attendanceRepository = attendanceRepository,
        _leaveRepository = leaveRepository,
        _connectivityService = connectivityService;

  @override
  Future<Employee> getEmployeeProfile(String employeeId) async {
    final cached = await _localDataSource.getEmployee();
    if (cached != null) return cached;

    final isConnected = await _connectivityService.isConnected;
    if (isConnected) {
      try {
        final remote = await _remoteDataSource.getEmployeeProfile();
        await _localDataSource.saveEmployee(remote);
        return remote;
      } catch (_) {
        // Fall back to preconfigured default
      }
    }

    return _defaultEmployee;
  }

  @override
  Future<DashboardData> getLocalDashboardData(
      String employeeId, String todayDate) async {
    final isConnected = await _connectivityService.isConnected;

    // 1. Employee from local cache
    final cachedEmp = await _localDataSource.getEmployee();
    final employee = cachedEmp ?? _defaultEmployee;

    // 2. Today's attendance from local DB
    final todayAttendance = await _attendanceRepository.getTodayAttendance(
      employeeId,
      todayDate,
    );

    // 3. Leave balance from local cache
    LeaveBalance leaveBalance;
    try {
      leaveBalance = await _leaveRepository.getLeaveBalance(employeeId);
    } catch (_) {
      leaveBalance = const LeaveBalance(casual: 2, sick: 3);
    }

    // 4. Recent attendance from local DB
    final recent = await _attendanceRepository.getRecentAttendance(
      employeeId,
      limit: 5,
    );

    // 5. Pending sync count
    final pendingCount = await _attendanceRepository.getPendingCount();

    return DashboardData(
      employee: employee,
      todayAttendance: todayAttendance,
      leaveBalance: leaveBalance,
      recentAttendance: recent,
      pendingEventsCount: pendingCount,
      isOffline: !isConnected,
    );
  }

  @override
  Future<DashboardData?> refreshDashboardData(
      String employeeId, String todayDate) async {
    final isConnected = await _connectivityService.isConnected;
    if (!isConnected) return null;

    try {
      final month = todayDate.length >= 7 ? todayDate.substring(0, 7) : todayDate;
      // Execute remote fetches in parallel with short timeout to prevent UI freezes
      await Future.wait([
        _remoteDataSource.getEmployeeProfile().then((emp) async {
          await _localDataSource.saveEmployee(emp);
        }).catchError((_) {}),
        _leaveRepository.getLeaveBalance(employeeId).catchError((_) => const LeaveBalance(casual: 2, sick: 3)),
        _attendanceRepository.getAttendanceHistory(employeeId, month).catchError((_) => <AttendanceRecord>[]),
      ]).timeout(const Duration(seconds: 4), onTimeout: () => []);
    } catch (_) {
      // Ignore network errors on refresh; local cache continues to be served
    }

    return getLocalDashboardData(employeeId, todayDate);
  }

  @override
  Future<DashboardData> getDashboardData(
      String employeeId, String todayDate) async {
    // 1. Load instantly from SQLite cache (<5ms)
    final localData = await getLocalDashboardData(employeeId, todayDate);

    // 2. Refresh in the background if connected
    final isConnected = await _connectivityService.isConnected;
    if (isConnected) {
      // Trigger background refresh without blocking
      refreshDashboardData(employeeId, todayDate);
    }

    return localData;
  }

  @override
  Stream<DashboardData> watchDashboardData(
      String employeeId, String todayDate) {
    // Watch local database changes reactively (NO remote HTTP calls in stream!)
    return _attendanceRepository
        .watchTodayAttendance(employeeId, todayDate)
        .asyncMap((_) => getLocalDashboardData(employeeId, todayDate));
  }
}
