import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../cubit/attendance_history_cubit.dart';
import '../cubit/attendance_history_state.dart';
import '../widgets/attendance_record_tile.dart';

class AttendanceHistoryPage extends StatefulWidget {
  final String employeeId;

  const AttendanceHistoryPage({super.key, required this.employeeId});

  @override
  State<AttendanceHistoryPage> createState() => _AttendanceHistoryPageState();
}

class _AttendanceHistoryPageState extends State<AttendanceHistoryPage> {
  late DateTime _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = DateTime.now();
    _fetchHistory();
  }

  void _fetchHistory() {
    final monthStr = DateFormat('yyyy-MM').format(_selectedMonth);
    context.read<AttendanceHistoryCubit>().loadHistory(
          employeeId: widget.employeeId,
          month: monthStr,
        );
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
    _fetchHistory();
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
    _fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    final monthDisplay = DateFormat('MMMM yyyy').format(_selectedMonth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Month Selector Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                  tooltip: 'Previous Month',
                ),
                Text(
                  monthDisplay,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                  tooltip: 'Next Month',
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Content
          Expanded(
            child: BlocBuilder<AttendanceHistoryCubit, AttendanceHistoryState>(
              builder: (context, state) {
                if (state is AttendanceHistoryLoading) {
                  return const LoadingWidget(message: 'Loading attendance records...');
                }

                if (state is AttendanceHistoryError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: _fetchHistory,
                  );
                }

                if (state is AttendanceHistoryLoaded) {
                  return Column(
                    children: [
                      OfflineBanner(isOffline: state.isOffline, onRetry: _fetchHistory),
                      if (state.records.isEmpty)
                        Expanded(
                          child: EmptyStateWidget(
                            message: 'No attendance records found for $monthDisplay.',
                            icon: Icons.calendar_today_outlined,
                            action: OutlinedButton.icon(
                              onPressed: _fetchHistory,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: RefreshIndicator(
                            onRefresh: () async => _fetchHistory(),
                            child: ListView.builder(
                              itemCount: state.records.length,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemBuilder: (context, index) {
                                return AttendanceRecordTile(
                                  record: state.records[index],
                                );
                              },
                            ),
                          ),
                        ),
                    ],
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
