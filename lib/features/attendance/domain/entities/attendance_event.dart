import 'package:equatable/equatable.dart';

class AttendanceEvent extends Equatable {
  final int? id;
  final String eventId;
  final String employeeId;
  final String eventType; // CHECK_IN, CHECK_OUT
  final DateTime eventTimestamp;
  final double latitude;
  final double longitude;
  final double officeDistanceMeters;
  final String companyDate; // YYYY-MM-DD
  final int localSequence;
  final DateTime createdAt;
  final String syncStatus; // PENDING, SYNCING, SYNCED, REJECTED
  final int retryCount;
  final DateTime? lastAttemptAt;
  final String? lastError;
  final String? serverAttendanceId;

  const AttendanceEvent({
    this.id,
    required this.eventId,
    required this.employeeId,
    required this.eventType,
    required this.eventTimestamp,
    required this.latitude,
    required this.longitude,
    required this.officeDistanceMeters,
    required this.companyDate,
    required this.localSequence,
    required this.createdAt,
    this.syncStatus = 'PENDING',
    this.retryCount = 0,
    this.lastAttemptAt,
    this.lastError,
    this.serverAttendanceId,
  });

  bool get isCheckIn => eventType == 'CHECK_IN';
  bool get isCheckOut => eventType == 'CHECK_OUT';
  bool get isSynced => syncStatus == 'SYNCED';
  bool get isPending => syncStatus == 'PENDING';
  bool get isRejected => syncStatus == 'REJECTED';

  @override
  List<Object?> get props => [
        id,
        eventId,
        employeeId,
        eventType,
        eventTimestamp,
        latitude,
        longitude,
        officeDistanceMeters,
        companyDate,
        localSequence,
        createdAt,
        syncStatus,
        retryCount,
        lastAttemptAt,
        lastError,
        serverAttendanceId,
      ];
}
