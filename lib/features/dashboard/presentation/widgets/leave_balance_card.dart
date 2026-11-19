import 'package:flutter/material.dart';
import '../../../leave/domain/entities/leave_balance.dart';

class LeaveBalanceCard extends StatelessWidget {
  final LeaveBalance balance;
  final VoidCallback? onApplyLeave;

  const LeaveBalanceCard({
    super.key,
    required this.balance,
    this.onApplyLeave,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Leave Balance',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (onApplyLeave != null)
                  TextButton.icon(
                    onPressed: onApplyLeave,
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('Apply'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCircleMetric(
                  context,
                  label: 'Casual Leave',
                  count: balance.casual,
                  color: const Color(0xFF1E88E5),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                _buildCircleMetric(
                  context,
                  label: 'Sick Leave',
                  count: balance.sick,
                  color: const Color(0xFF43A047),
                ),
                Container(width: 1, height: 40, color: Colors.grey.shade300),
                _buildCircleMetric(
                  context,
                  label: 'Total Available',
                  count: balance.total,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleMetric(
    BuildContext context, {
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}
