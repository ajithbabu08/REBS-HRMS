// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_dao.dart';

// ignore_for_file: type=lint
mixin _$LeaveDaoMixin on DatabaseAccessor<AppDatabase> {
  $LeaveBalanceTableTable get leaveBalanceTable =>
      attachedDatabase.leaveBalanceTable;
  $LeaveRequestTableTable get leaveRequestTable =>
      attachedDatabase.leaveRequestTable;
  LeaveDaoManager get managers => LeaveDaoManager(this);
}

class LeaveDaoManager {
  final _$LeaveDaoMixin _db;
  LeaveDaoManager(this._db);
  $$LeaveBalanceTableTableTableManager get leaveBalanceTable =>
      $$LeaveBalanceTableTableTableManager(
        _db.attachedDatabase,
        _db.leaveBalanceTable,
      );
  $$LeaveRequestTableTableTableManager get leaveRequestTable =>
      $$LeaveRequestTableTableTableManager(
        _db.attachedDatabase,
        _db.leaveRequestTable,
      );
}
