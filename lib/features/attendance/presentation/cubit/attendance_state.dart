import 'package:equatable/equatable.dart';
import '../../domain/entities/attendance_event.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();

  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {
  const AttendanceInitial();
}

class AttendanceActionInProgress extends AttendanceState {
  final String action; // 'Checking in...' or 'Checking out...'

  const AttendanceActionInProgress(this.action);

  @override
  List<Object?> get props => [action];
}

class AttendanceActionSuccess extends AttendanceState {
  final AttendanceEvent event;
  final String message;

  const AttendanceActionSuccess({
    required this.event,
    required this.message,
  });

  @override
  List<Object?> get props => [event, message];
}

class AttendanceActionFailure extends AttendanceState {
  final String errorMessage;
  final bool isLocationDisabled;
  final bool isPermissionPermanentlyDenied;

  const AttendanceActionFailure(
    this.errorMessage, {
    this.isLocationDisabled = false,
    this.isPermissionPermanentlyDenied = false,
  });

  @override
  List<Object?> get props => [
        errorMessage,
        isLocationDisabled,
        isPermissionPermanentlyDenied,
      ];
}
