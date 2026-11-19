import 'package:flutter/material.dart';

class SyncStatusBadge extends StatelessWidget {
  final String status; // PENDING, SYNCING, SYNCED, REJECTED

  const SyncStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    IconData icon;
    String label;

    switch (status.toUpperCase()) {
      case 'SYNCED':
        bg = Colors.green.shade50;
        fg = Colors.green.shade800;
        icon = Icons.check_circle_outline;
        label = 'Synced';
        break;
      case 'SYNCING':
        bg = Colors.blue.shade50;
        fg = Colors.blue.shade800;
        icon = Icons.sync;
        label = 'Syncing...';
        break;
      case 'REJECTED':
        bg = Colors.red.shade50;
        fg = Colors.red.shade800;
        icon = Icons.error_outline;
        label = 'Rejected';
        break;
      case 'PENDING':
      default:
        bg = Colors.orange.shade50;
        fg = Colors.orange.shade900;
        icon = Icons.cloud_upload_outlined;
        label = 'Pending Sync';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: fg.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
