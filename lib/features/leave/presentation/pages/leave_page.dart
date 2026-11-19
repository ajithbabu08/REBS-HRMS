import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../cubit/leave_cubit.dart';
import '../cubit/leave_state.dart';
import '../widgets/leave_balance_summary.dart';
import '../widgets/leave_request_tile.dart';
import 'apply_leave_page.dart';

class LeavePage extends StatefulWidget {
  final String employeeId;

  const LeavePage({super.key, required this.employeeId});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    context.read<LeaveCubit>().loadLeaveData(widget.employeeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _load,
            tooltip: 'Refresh',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => ApplyLeavePage(employeeId: widget.employeeId),
            ),
          );
          if (result == true) {
            _load();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text('Apply Leave'),
      ),
      body: BlocBuilder<LeaveCubit, LeaveState>(
        builder: (context, state) {
          if (state is LeaveLoading) {
            return const LoadingWidget(message: 'Loading leave data...');
          }

          if (state is LeaveError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: _load,
            );
          }

          if (state is LeaveLoaded) {
            return RefreshIndicator(
              onRefresh: () async => _load(),
              child: CustomScrollView(
                slivers: [
                  if (state.isOffline)
                    SliverToBoxAdapter(
                      child: OfflineBanner(isOffline: true, onRetry: _load),
                    ),
                  SliverToBoxAdapter(
                    child: LeaveBalanceSummary(balance: state.balance),
                  ),
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        'Leave Applications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (state.requests.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: EmptyStateWidget(
                        message: 'No leave applications found.\nTap "Apply Leave" to submit a new request.',
                        icon: Icons.event_note_outlined,
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return LeaveRequestTile(
                            request: state.requests[index],
                          );
                        },
                        childCount: state.requests.length,
                      ),
                    ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80), // Fab space
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
