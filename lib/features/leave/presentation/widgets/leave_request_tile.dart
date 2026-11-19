import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/leave_request.dart';

class LeaveRequestTile extends StatelessWidget {
  final LeaveRequest request;

  const LeaveRequestTile({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    Color statusBg;
    Color statusFg;
    IconData statusIcon;

    switch (request.status.toUpperCase()) {
      case 'APPROVED':
        statusBg = Colors.green.shade50;
        statusFg = Colors.green.shade800;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'REJECTED':
        statusBg = Colors.red.shade50;
        statusFg = Colors.red.shade800;
        statusIcon = Icons.cancel_outlined;
        break;
      case 'PENDING':
      default:
        statusBg = Colors.orange.shade50;
        statusFg = Colors.orange.shade900;
        statusIcon = Icons.hourglass_top_outlined;
        break;
    }

    final startStr = DateFormat('dd MMM yyyy').format(request.startDate);
    final endStr = DateFormat('dd MMM yyyy').format(request.endDate);
    final submittedStr = DateFormat('dd MMM yyyy').format(request.submittedAt);

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
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${request.leaveType.toUpperCase()} LEAVE',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${request.numberOfDays} Day${request.numberOfDays > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusFg.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusFg),
                      const SizedBox(width: 4),
                      Text(
                        request.status,
                        style: TextStyle(
                          color: statusFg,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Text(
                  '$startStr  →  $endStr',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              request.reason,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Applied on $submittedStr',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
