import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/sync/sync_manager.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';
import '../widgets/attendance_action_button.dart';
import '../widgets/employee_info_card.dart';
import '../widgets/leave_balance_card.dart';
import '../widgets/recent_attendance_list.dart';
import '../widgets/today_attendance_card.dart';

class DashboardPage extends StatefulWidget {
  final String employeeId;
  final VoidCallback? onNavigateToAttendance;
  final VoidCallback? onNavigateToLeave;

  const DashboardPage({
    super.key,
    required this.employeeId,
    this.onNavigateToAttendance,
    this.onNavigateToLeave,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isManualSyncing = false;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isRefreshing = true);
    await context.read<DashboardCubit>().loadDashboard(employeeId: widget.employeeId);
    if (mounted) {
      setState(() => _isRefreshing = false);
    }
  }

  Future<void> _triggerSync() async {
    setState(() => _isManualSyncing = true);
    final syncManager = sl<SyncManager>();
    final result = await syncManager.syncNow();
    if (mounted) {
      setState(() => _isManualSyncing = false);
      _load();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.total == 0
                ? 'No pending events to sync.'
                : 'Sync complete: ${result.synced} synced, ${result.rejected} rejected, ${result.failed} failed.',
          ),
          backgroundColor: result.hasErrors
              ? Colors.red.shade700
              : Colors.green.shade700,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REBS HRMS Workspace'),
        actions: [
          IconButton(
            icon: _isManualSyncing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.sync),
            onPressed: _isManualSyncing ? null : _triggerSync,
            tooltip: 'Sync Now',
          ),
          IconButton(
            icon: _isRefreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
            onPressed: (_isRefreshing || _isManualSyncing) ? null : _load,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardInitial || state is DashboardLoading) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      'Fetching workplace data...',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is DashboardError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: _load,
            );
          }

          if (state is DashboardLoaded) {
            final data = state.data;

            return Column(
              children: [
                if (_isRefreshing || _isManualSyncing)
                  const LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: Colors.transparent,
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _load,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Offline Banner
                          OfflineBanner(
                            isOffline: data.isOffline,
                            onRetry: _load,
                          ),

                          // Pending sync alert card
                          if (data.pendingEventsCount > 0)
                            Container(
                              margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange.shade300),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.cloud_upload_outlined,
                                      color: Colors.orange.shade900),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      '${data.pendingEventsCount} attendance event${data.pendingEventsCount > 1 ? 's' : ''} pending sync',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange.shade900,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: _isManualSyncing ? null : _triggerSync,
                                    style: TextButton.styleFrom(
                                      foregroundColor: Colors.orange.shade900,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    child: _isManualSyncing
                                        ? const SizedBox(
                                            width: 14,
                                            height: 14,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.orange,
                                            ),
                                          )
                                        : const Text(
                                            'Sync Now',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                  ),
                                ],
                              ),
                            ),

                          // Employee Profile
                          EmployeeInfoCard(employee: data.employee),

                          // Today's Attendance Status Card
                          TodayAttendanceCard(record: data.todayAttendance),

                          // Attendance Action Button (Check In / Check Out)
                          AttendanceActionButton(
                            employeeId: data.employee.employeeId,
                            todayRecord: data.todayAttendance,
                          ),

                          // Leave Balance Card
                          LeaveBalanceCard(
                            balance: data.leaveBalance,
                            onApplyLeave: widget.onNavigateToLeave,
                          ),

                          // Recent Attendance List
                          RecentAttendanceList(
                            records: data.recentAttendance,
                            onViewAll: widget.onNavigateToAttendance,
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
