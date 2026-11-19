import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/attendance/presentation/cubit/attendance_cubit.dart';
import '../features/attendance/presentation/cubit/attendance_history_cubit.dart';
import '../features/attendance/presentation/pages/attendance_history_page.dart';
import '../features/dashboard/presentation/cubit/dashboard_cubit.dart';
import '../features/dashboard/presentation/pages/dashboard_page.dart';
import '../features/leave/presentation/cubit/leave_cubit.dart';
import '../features/leave/presentation/pages/leave_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../core/di/service_locator.dart';

class MainShell extends StatefulWidget {
  final String employeeId;

  const MainShell({super.key, this.employeeId = 'REBS-EMP-001'});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardCubit>(
          create: (_) => DashboardCubit(repository: sl()),
        ),
        BlocProvider<AttendanceCubit>(
          create: (_) => AttendanceCubit(
            checkInUseCase: sl(),
            checkOutUseCase: sl(),
          ),
        ),
        BlocProvider<AttendanceHistoryCubit>(
          create: (_) => AttendanceHistoryCubit(
            repository: sl(),
            connectivityService: sl(),
          ),
        ),
        BlocProvider<LeaveCubit>(
          create: (_) => LeaveCubit(
            repository: sl(),
            connectivityService: sl(),
          ),
        ),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            DashboardPage(
              employeeId: widget.employeeId,
              onNavigateToAttendance: () => _onTabSelected(1),
              onNavigateToLeave: () => _onTabSelected(2),
            ),
            AttendanceHistoryPage(employeeId: widget.employeeId),
            LeavePage(employeeId: widget.employeeId),
            SettingsPage(employeeId: widget.employeeId),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabSelected,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.access_time_outlined),
              selectedIcon: Icon(Icons.access_time_filled),
              label: 'Attendance',
            ),
            NavigationDestination(
              icon: Icon(Icons.event_note_outlined),
              selectedIcon: Icon(Icons.event_note),
              label: 'Leave',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
