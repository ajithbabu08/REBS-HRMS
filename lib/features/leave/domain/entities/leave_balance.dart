import 'package:equatable/equatable.dart';

class LeaveBalance extends Equatable {
  final int casual;
  final int sick;

  const LeaveBalance({
    required this.casual,
    required this.sick,
  });

  int get total => casual + sick;

  @override
  List<Object?> get props => [casual, sick];
}
