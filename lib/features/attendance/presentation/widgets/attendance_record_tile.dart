import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/widgets/sync_status_badge.dart';
import '../../domain/entities/attendance_record.dart';

class AttendanceRecordTile extends StatelessWidget {
  final AttendanceRecord record;

  const AttendanceRecordTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    final checkIn = record.checkIn;
    final checkOut = record.checkOut;

    final inTimeStr = checkIn != null
        ? DateFormat('hh:mm a').format(checkIn.eventTimestamp)
        : '--:--';
    final outTimeStr = checkOut != null
        ? DateFormat('hh:mm a').format(checkOut.eventTimestamp)
        : '--:--';

    // Format duration
    String durationStr = '--';
    if (record.isCheckedOut) {
      final duration = record.workingDuration;
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      if (hours > 0 || minutes > 0 || duration.inSeconds > 0) {
        durationStr = '${hours}h ${minutes}m';
      }
    } else if (record.isCheckedIn) {
      final now = DateTime.now();
      final todayStr =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      if (record.date == todayStr) {
        final duration = record.workingDuration;
        final hours = duration.inHours;
        final minutes = duration.inMinutes.remainder(60);
        durationStr = '${hours}h ${minutes}m';
      }
    }

    // Format date header
    DateTime? parsedDate = DateTime.tryParse(record.date);
    final dateDisplay = parsedDate != null
        ? DateFormat('EEE, dd MMM yyyy').format(parsedDate)
        : record.date;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateDisplay,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SyncStatusBadge(status: record.syncStatus),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTimeColumn(
                  label: 'Check In',
                  time: inTimeStr,
                  icon: Icons.login,
                  color: Colors.green.shade700,
                ),
                _buildTimeColumn(
                  label: 'Check Out',
                  time: outTimeStr,
                  icon: Icons.logout,
                  color: Colors.red.shade700,
                ),
                _buildTimeColumn(
                  label: 'Duration',
                  time: durationStr,
                  icon: Icons.timer_outlined,
                  color: Colors.blue.shade800,
                ),
              ],
            ),
            if (checkIn?.lastError != null || checkOut?.lastError != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        size: 14, color: Colors.red.shade700),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        checkIn?.lastError ?? checkOut?.lastError ?? '',
                        style: TextStyle(
                            fontSize: 11, color: Colors.red.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeColumn({
    required String label,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }
}
