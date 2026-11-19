import 'package:flutter/material.dart';
import '../../../attendance/domain/entities/attendance_record.dart';
import '../../../attendance/presentation/widgets/attendance_record_tile.dart';

class RecentAttendanceList extends StatelessWidget {
  final List<AttendanceRecord> records;
  final VoidCallback? onViewAll;

  const RecentAttendanceList({
    super.key,
    required this.records,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Attendance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('View All'),
                ),
            ],
          ),
        ),
        if (records.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Center(
              child: Text(
                'No recent attendance records.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            itemBuilder: (context, index) {
              return AttendanceRecordTile(record: records[index]);
            },
          ),
      ],
    );
  }
}
