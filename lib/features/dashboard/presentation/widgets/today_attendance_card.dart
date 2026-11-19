import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/sync_status_badge.dart';
import '../../../attendance/domain/entities/attendance_record.dart';

class TodayAttendanceCard extends StatefulWidget {
  final AttendanceRecord record;

  const TodayAttendanceCard({super.key, required this.record});

  @override
  State<TodayAttendanceCard> createState() => _TodayAttendanceCardState();
}

class _TodayAttendanceCardState extends State<TodayAttendanceCard> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateDuration();
    if (widget.record.isCheckedIn) {
      _startTimer();
    }
  }

  @override
  void didUpdateWidget(covariant TodayAttendanceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateDuration();
    if (widget.record.isCheckedIn && _timer == null) {
      _startTimer();
    } else if (!widget.record.isCheckedIn && _timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _updateDuration();
        });
      }
    });
  }

  void _updateDuration() {
    if (widget.record.checkIn != null) {
      final end = widget.record.checkOut?.eventTimestamp ?? DateTime.now();
      _elapsed = end.difference(widget.record.checkIn!.eventTimestamp);
      if (_elapsed.isNegative) _elapsed = Duration.zero;
    } else {
      _elapsed = Duration.zero;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatElapsed() {
    final hours = _elapsed.inHours.toString().padLeft(2, '0');
    final minutes = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final checkIn = widget.record.checkIn;
    final checkOut = widget.record.checkOut;

    final inTimeStr = checkIn != null
        ? DateFormat('hh:mm:ss a').format(checkIn.eventTimestamp)
        : '--:--:--';
    final outTimeStr = checkOut != null
        ? DateFormat('hh:mm:ss a').format(checkOut.eventTimestamp)
        : '--:--:--';

    Color statusColor;
    if (widget.record.isCheckedOut) {
      statusColor = Colors.purple.shade700;
    } else if (widget.record.isCheckedIn) {
      statusColor = Colors.green.shade700;
    } else {
      statusColor = Colors.grey.shade600;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Status Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      widget.record.attendanceStatus,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                if (checkIn != null)
                  SyncStatusBadge(status: widget.record.syncStatus),
              ],
            ),
            const SizedBox(height: 20),

            // Working Timer display
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Text(
                    widget.record.isCheckedIn
                        ? 'WORKING TIME (LIVE)'
                        : 'TOTAL WORKING TIME',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatElapsed(),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: widget.record.isCheckedIn
                          ? Theme.of(context).primaryColor
                          : Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Check In / Check Out details
            Row(
              children: [
                Expanded(
                  child: _buildTimeBox(
                    label: 'Check In',
                    time: inTimeStr,
                    icon: Icons.login,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTimeBox(
                    label: 'Check Out',
                    time: outTimeStr,
                    icon: Icons.logout,
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeBox({
    required String label,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
