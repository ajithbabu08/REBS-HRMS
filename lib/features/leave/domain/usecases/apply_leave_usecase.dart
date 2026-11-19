import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/connectivity_service.dart';
import '../entities/leave_request.dart';
import '../repositories/leave_repository.dart';

class ApplyLeaveUseCase {
  final LeaveRepository _repository;
  final ConnectivityService _connectivityService;

  ApplyLeaveUseCase({
    required LeaveRepository repository,
    required ConnectivityService connectivityService,
  })  : _repository = repository,
        _connectivityService = connectivityService;

  /// Calculate total calendar days between start and end (inclusive).
  static int calculateDays(DateTime start, DateTime end) {
    final s = DateTime(start.year, start.month, start.day);
    final e = DateTime(end.year, end.month, end.day);
    return e.difference(s).inDays + 1;
  }

  Future<LeaveRequest> execute({
    required String employeeId,
    required String leaveType, // 'CASUAL' or 'SICK'
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    // 1. Connectivity check: leave applications require internet connectivity
    final isConnected = await _connectivityService.isConnected;
    if (!isConnected) {
      throw const NetworkException(
        'Leave applications require an internet connection. Your existing leave requests are still available offline.',
      );
    }

    // 2. Date validation: Start date cannot be before current date
    final today = DateTime.now();
    final todayDateOnly = DateTime(today.year, today.month, today.day);
    final startDateOnly = DateTime(startDate.year, startDate.month, startDate.day);
    final endDateOnly = DateTime(endDate.year, endDate.month, endDate.day);

    if (startDateOnly.isBefore(todayDateOnly)) {
      throw const ValidationException('Start date cannot be in the past.');
    }

    // 3. End date cannot be before start date
    if (endDateOnly.isBefore(startDateOnly)) {
      throw const ValidationException('End date cannot be before start date.');
    }

    // 4. Reason must contain at least 10 non-whitespace characters
    final trimmedReason = reason.replaceAll(RegExp(r'\s+'), '');
    if (trimmedReason.length < 10) {
      throw const ValidationException(
        'Reason must contain at least 10 characters (excluding whitespace).',
      );
    }

    // 5. Balance check
    final requestedDays = calculateDays(startDate, endDate);
    final balance = await _repository.getLeaveBalance(employeeId);

    final normalizedType = leaveType.toUpperCase();
    if (normalizedType == 'CASUAL') {
      if (requestedDays > balance.casual) {
        throw ValidationException(
          'Requested $requestedDays day(s) exceeds your available Casual Leave balance of ${balance.casual}.',
        );
      }
    } else if (normalizedType == 'SICK') {
      if (requestedDays > balance.sick) {
        throw ValidationException(
          'Requested $requestedDays day(s) exceeds your available Sick Leave balance of ${balance.sick}.',
        );
      }
    } else {
      throw ValidationException('Invalid leave type: $leaveType');
    }

    // 6. Overlap check with PENDING or APPROVED leaves
    final overlapping = await _repository.getOverlappingLeaves(
      employeeId: employeeId,
      startDate: startDateOnly,
      endDate: endDateOnly,
    );

    if (overlapping.isNotEmpty) {
      final active = overlapping.firstWhere(
        (l) => l.isPending || l.isApproved,
        orElse: () => overlapping.first,
      );
      throw ValidationException(
        'Requested dates overlap with an existing ${active.status} leave request (${active.leaveType}).',
      );
    }

    // 7. Submit to server
    return _repository.submitLeaveRequest(
      employeeId: employeeId,
      leaveType: normalizedType,
      startDate: startDateOnly,
      endDate: endDateOnly,
      reason: reason.trim(),
    );
  }
}
