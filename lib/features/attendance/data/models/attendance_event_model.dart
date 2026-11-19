import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../domain/entities/attendance_event.dart';

class AttendanceEventModel {
  static AttendanceEvent fromEntry(AttendanceEntry entry) {
    return AttendanceEvent(
      id: entry.id,
      eventId: entry.eventId,
      employeeId: entry.employeeId,
      eventType: entry.eventType,
      eventTimestamp: entry.eventTimestamp,
      latitude: entry.latitude,
      longitude: entry.longitude,
      officeDistanceMeters: entry.officeDistanceMeters,
      companyDate: entry.companyDate,
      localSequence: entry.localSequence,
      createdAt: entry.createdAt,
      syncStatus: entry.syncStatus,
      retryCount: entry.retryCount,
      lastAttemptAt: entry.lastAttemptAt,
      lastError: entry.lastError,
      serverAttendanceId: entry.serverAttendanceId,
    );
  }

  static AttendanceTableCompanion toCompanion(AttendanceEvent event) {
    return AttendanceTableCompanion.insert(
      eventId: event.eventId,
      employeeId: event.employeeId,
      eventType: event.eventType,
      eventTimestamp: event.eventTimestamp,
      latitude: event.latitude,
      longitude: event.longitude,
      officeDistanceMeters: event.officeDistanceMeters,
      companyDate: event.companyDate,
      localSequence: event.localSequence,
      createdAt: event.createdAt,
      syncStatus: Value(event.syncStatus),
      retryCount: Value(event.retryCount),
      lastAttemptAt: Value(event.lastAttemptAt),
      lastError: Value(event.lastError),
      serverAttendanceId: Value(event.serverAttendanceId),
    );
  }

  static AttendanceEvent fromJson(Map<String, dynamic> json) {
    return AttendanceEvent(
      eventId: json['eventId'] as String,
      employeeId: json['employeeId'] as String,
      eventType: json['eventType'] as String,
      eventTimestamp: DateTime.parse(json['timestamp'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      officeDistanceMeters: (json['officeDistanceMeters'] as num).toDouble(),
      companyDate: json['companyDate'] as String,
      localSequence: json['localSequence'] as int? ?? 1,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      syncStatus: json['syncStatus'] as String? ?? 'SYNCED',
      serverAttendanceId: json['serverAttendanceId'] as String?,
    );
  }

  static Map<String, dynamic> toJson(AttendanceEvent event) {
    return {
      'eventId': event.eventId,
      'employeeId': event.employeeId,
      'eventType': event.eventType,
      'timestamp': event.eventTimestamp.toIso8601String(),
      'latitude': event.latitude,
      'longitude': event.longitude,
      'officeDistanceMeters': event.officeDistanceMeters,
      'companyDate': event.companyDate,
      'localSequence': event.localSequence,
    };
  }
}
