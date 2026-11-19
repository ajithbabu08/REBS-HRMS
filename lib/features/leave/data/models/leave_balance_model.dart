import '../../../../core/database/app_database.dart';
import '../../domain/entities/leave_balance.dart';

class LeaveBalanceModel {
  static LeaveBalance fromJson(Map<String, dynamic> json) {
    return LeaveBalance(
      casual: (json['casual'] as num?)?.toInt() ?? 0,
      sick: (json['sick'] as num?)?.toInt() ?? 0,
    );
  }

  static LeaveBalance fromEntry(LeaveBalanceEntry entry) {
    return LeaveBalance(
      casual: entry.casualLeaves,
      sick: entry.sickLeaves,
    );
  }

  static LeaveBalanceTableCompanion toCompanion(
    String employeeId,
    LeaveBalance balance,
  ) {
    return LeaveBalanceTableCompanion.insert(
      employeeId: employeeId,
      casualLeaves: balance.casual,
      sickLeaves: balance.sick,
      lastUpdated: DateTime.now(),
    );
  }
}
