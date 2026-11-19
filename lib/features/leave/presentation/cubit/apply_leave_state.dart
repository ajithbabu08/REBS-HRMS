import 'package:equatable/equatable.dart';
import '../../domain/entities/leave_request.dart';

abstract class ApplyLeaveState extends Equatable {
  const ApplyLeaveState();

  @override
  List<Object?> get props => [];
}

class ApplyLeaveInitial extends ApplyLeaveState {
  const ApplyLeaveInitial();
}

class ApplyLeaveSubmitting extends ApplyLeaveState {
  const ApplyLeaveSubmitting();
}

class ApplyLeaveSuccess extends ApplyLeaveState {
  final LeaveRequest request;
  final String message;

  const ApplyLeaveSuccess({
    required this.request,
    this.message = 'Leave application submitted successfully!',
  });

  @override
  List<Object?> get props => [request, message];
}

class ApplyLeaveFailure extends ApplyLeaveState {
  final String errorMessage;

  const ApplyLeaveFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}
