import 'package:equatable/equatable.dart';
import 'attendance_event.dart';

class AttendanceRecord extends Equatable {
  final String date; // YYYY-MM-DD
  final AttendanceEvent? checkIn;
  final AttendanceEvent? checkOut;

  const AttendanceRecord({
    required this.date,
    this.checkIn,
    this.checkOut,
  });

  bool get isCheckedIn => checkIn != null && checkOut == null;
  bool get isCheckedOut => checkIn != null && checkOut != null;
  bool get isNotCheckedIn => checkIn == null;

  String get attendanceStatus {
    if (isCheckedOut) return 'Checked Out';
    if (isCheckedIn) return 'Checked In';
    return 'Not Checked In';
  }

  String get syncStatus {
    if (checkOut != null) return checkOut!.syncStatus;
    if (checkIn != null) return checkIn!.syncStatus;
    return 'SYNCED';
  }

  Duration get workingDuration {
    if (checkIn == null) return Duration.zero;
    if (checkOut != null) {
      final diff = checkOut!.eventTimestamp.difference(checkIn!.eventTimestamp);
      return diff.isNegative ? Duration.zero : diff;
    }
    // Only calculate elapsed duration if today's shift is currently in progress
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    if (date == todayStr) {
      final diff = now.difference(checkIn!.eventTimestamp);
      return diff.isNegative ? Duration.zero : diff;
    }
    return Duration.zero;
  }

  @override
  List<Object?> get props => [date, checkIn, checkOut];
}
