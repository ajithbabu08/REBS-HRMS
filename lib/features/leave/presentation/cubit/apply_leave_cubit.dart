import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/usecases/apply_leave_usecase.dart';
import 'apply_leave_state.dart';

class ApplyLeaveCubit extends Cubit<ApplyLeaveState> {
  final ApplyLeaveUseCase _applyLeaveUseCase;

  ApplyLeaveCubit({required ApplyLeaveUseCase applyLeaveUseCase})
      : _applyLeaveUseCase = applyLeaveUseCase,
        super(const ApplyLeaveInitial());

  Future<void> submit({
    required String employeeId,
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    if (state is ApplyLeaveSubmitting) return;
    emit(const ApplyLeaveSubmitting());

    try {
      final request = await _applyLeaveUseCase.execute(
        employeeId: employeeId,
        leaveType: leaveType,
        startDate: startDate,
        endDate: endDate,
        reason: reason,
      );

      emit(ApplyLeaveSuccess(request: request));
    } on AppException catch (e) {
      emit(ApplyLeaveFailure(e.message));
    } catch (e) {
      emit(ApplyLeaveFailure(e.toString()));
    }
  }

  void reset() => emit(const ApplyLeaveInitial());
}
