import 'package:equatable/equatable.dart';
import '../../domain/entities/leave_balance.dart';
import '../../domain/entities/leave_request.dart';

abstract class LeaveState extends Equatable {
  const LeaveState();

  @override
  List<Object?> get props => [];
}

class LeaveInitial extends LeaveState {
  const LeaveInitial();
}

class LeaveLoading extends LeaveState {
  const LeaveLoading();
}

class LeaveLoaded extends LeaveState {
  final LeaveBalance balance;
  final List<LeaveRequest> requests;
  final bool isOffline;

  const LeaveLoaded({
    required this.balance,
    required this.requests,
    this.isOffline = false,
  });

  @override
  List<Object?> get props => [balance, requests, isOffline];
}

class LeaveError extends LeaveState {
  final String message;

  const LeaveError(this.message);

  @override
  List<Object?> get props => [message];
}
