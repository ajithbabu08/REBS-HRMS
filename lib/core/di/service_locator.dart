import 'package:get_it/get_it.dart';

import '../../app/config/environment.dart';
import '../database/app_database.dart';
import '../database/dao/attendance_dao.dart';
import '../database/dao/employee_dao.dart';
import '../database/dao/leave_dao.dart';
import '../location/location_service.dart';
import '../network/connectivity_service.dart';
import '../network/dio_client.dart';
import '../sync/sync_manager.dart';
import '../sync/sync_service.dart';

// Feature dependencies
import '../../features/dashboard/data/datasources/dashboard_local_datasource.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';

import '../../features/attendance/data/datasources/attendance_local_datasource.dart';
import '../../features/attendance/data/datasources/attendance_remote_datasource.dart';
import '../../features/attendance/data/repositories/attendance_repository_impl.dart';
import '../../features/attendance/domain/repositories/attendance_repository.dart';
import '../../features/attendance/domain/usecases/check_in_usecase.dart';
import '../../features/attendance/domain/usecases/check_out_usecase.dart';

import '../../features/leave/data/datasources/leave_local_datasource.dart';
import '../../features/leave/data/datasources/leave_remote_datasource.dart';
import '../../features/leave/data/repositories/leave_repository_impl.dart';
import '../../features/leave/domain/repositories/leave_repository.dart';
import '../../features/leave/domain/usecases/apply_leave_usecase.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator({AppConfig? config}) async {
  // 1. Config
  final appConfig = config ?? AppConfig.dev;
  sl.registerSingleton<AppConfig>(appConfig);

  // 2. Database & DAOs
  final database = AppDatabase();
  sl.registerSingleton<AppDatabase>(database);
  sl.registerSingleton<EmployeeDao>(database.employeeDao);
  sl.registerSingleton<AttendanceDao>(database.attendanceDao);
  sl.registerSingleton<LeaveDao>(database.leaveDao);

  // 3. Network & Connectivity
  sl.registerLazySingleton<DioClient>(() => DioClient(sl<AppConfig>()));
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityServiceImpl());

  // 4. Location
  sl.registerLazySingleton<LocationService>(
      () => LocationServiceImpl(config: sl<AppConfig>()));

  // 5. Sync
  sl.registerLazySingleton<SyncService>(() => SyncServiceImpl(
        attendanceDao: sl<AttendanceDao>(),
        dioClient: sl<DioClient>(),
      ));
  sl.registerLazySingleton<SyncManager>(() => SyncManager(
        syncService: sl<SyncService>(),
        connectivityService: sl<ConnectivityService>(),
      ));

  // 6. DataSources
  // Dashboard
  sl.registerLazySingleton<DashboardLocalDataSource>(
      () => DashboardLocalDataSourceImpl(employeeDao: sl<EmployeeDao>()));
  sl.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(dioClient: sl<DioClient>()));

  // Attendance
  sl.registerLazySingleton<AttendanceLocalDataSource>(
      () => AttendanceLocalDataSourceImpl(attendanceDao: sl<AttendanceDao>()));
  sl.registerLazySingleton<AttendanceRemoteDataSource>(
      () => AttendanceRemoteDataSourceImpl(dioClient: sl<DioClient>()));

  // Leave
  sl.registerLazySingleton<LeaveLocalDataSource>(
      () => LeaveLocalDataSourceImpl(leaveDao: sl<LeaveDao>()));
  sl.registerLazySingleton<LeaveRemoteDataSource>(
      () => LeaveRemoteDataSourceImpl(dioClient: sl<DioClient>()));

  // 7. Repositories
  sl.registerLazySingleton<AttendanceRepository>(() => AttendanceRepositoryImpl(
        localDataSource: sl<AttendanceLocalDataSource>(),
        remoteDataSource: sl<AttendanceRemoteDataSource>(),
        connectivityService: sl<ConnectivityService>(),
      ));

  sl.registerLazySingleton<LeaveRepository>(() => LeaveRepositoryImpl(
        localDataSource: sl<LeaveLocalDataSource>(),
        remoteDataSource: sl<LeaveRemoteDataSource>(),
        connectivityService: sl<ConnectivityService>(),
      ));

  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(
        localDataSource: sl<DashboardLocalDataSource>(),
        remoteDataSource: sl<DashboardRemoteDataSource>(),
        attendanceRepository: sl<AttendanceRepository>(),
        leaveRepository: sl<LeaveRepository>(),
        connectivityService: sl<ConnectivityService>(),
      ));

  // 8. UseCases
  sl.registerLazySingleton<CheckInUseCase>(() => CheckInUseCase(
        repository: sl<AttendanceRepository>(),
        locationService: sl<LocationService>(),
        config: sl<AppConfig>(),
      ));

  sl.registerLazySingleton<CheckOutUseCase>(() => CheckOutUseCase(
        repository: sl<AttendanceRepository>(),
        locationService: sl<LocationService>(),
        config: sl<AppConfig>(),
      ));

  sl.registerLazySingleton<ApplyLeaveUseCase>(() => ApplyLeaveUseCase(
        repository: sl<LeaveRepository>(),
        connectivityService: sl<ConnectivityService>(),
      ));
}
