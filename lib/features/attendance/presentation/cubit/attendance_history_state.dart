import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_record.dart';

abstract class AttendanceHistoryState extends Equatable {
  const AttendanceHistoryState();

  @override
  List<Object?> get props => [];
}

class AttendanceHistoryInitial extends AttendanceHistoryState {
  const AttendanceHistoryInitial();
}

class AttendanceHistoryLoading extends AttendanceHistoryState {
  const AttendanceHistoryLoading();
}

class AttendanceHistoryLoaded extends AttendanceHistoryState {
  final List<AttendanceRecord> records;
  final String selectedMonth; // YYYY-MM
  final bool isOffline;

  const AttendanceHistoryLoaded({
    required this.records,
    required this.selectedMonth,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [records, selectedMonth, isOffline];
}

class AttendanceHistoryError extends AttendanceHistoryState {
  final String message;

  const AttendanceHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
