import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../domain/usecases/check_in_usecase.dart';
import '../../domain/usecases/check_out_usecase.dart';
import 'attendance_state.dart';

class AttendanceCubit extends Cubit<AttendanceState> {
  final CheckInUseCase _checkInUseCase;
  final CheckOutUseCase _checkOutUseCase;

  AttendanceCubit({
    required CheckInUseCase checkInUseCase,
    required CheckOutUseCase checkOutUseCase,
  })  : _checkInUseCase = checkInUseCase,
        _checkOutUseCase = checkOutUseCase,
        super(const AttendanceInitial());

  Future<void> checkIn({
    required String employeeId,
    required String companyDate,
  }) async {
    if (state is AttendanceActionInProgress) return;
    emit(const AttendanceActionInProgress('Recording check-in...'));

    try {
      final event = await _checkInUseCase.execute(
        employeeId: employeeId,
        companyDate: companyDate,
      );

      final msg = event.isSynced
          ? 'Check-in successful & synced with server!'
          : 'Check-in saved offline. It will sync when internet is available.';

      emit(AttendanceActionSuccess(event: event, message: msg));
    } on LocationServiceDisabledException catch (e) {
      emit(AttendanceActionFailure(
        e.message,
        isLocationDisabled: true,
      ));
    } on LocationPermissionDeniedException catch (e) {
      emit(AttendanceActionFailure(
        e.message,
        isPermissionPermanentlyDenied: e.isPermanent,
      ));
    } on AppException catch (e) {
      emit(AttendanceActionFailure(e.message));
    } catch (e) {
      emit(AttendanceActionFailure(e.toString()));
    }
  }

  Future<void> checkOut({
    required String employeeId,
    required String companyDate,
  }) async {
    if (state is AttendanceActionInProgress) return;
    emit(const AttendanceActionInProgress('Recording check-out...'));

    try {
      final event = await _checkOutUseCase.execute(
        employeeId: employeeId,
        companyDate: companyDate,
      );

      final msg = event.isSynced
          ? 'Check-out successful & synced with server!'
          : 'Check-out saved offline. It will sync when internet is available.';

      emit(AttendanceActionSuccess(event: event, message: msg));
    } on LocationServiceDisabledException catch (e) {
      emit(AttendanceActionFailure(
        e.message,
        isLocationDisabled: true,
      ));
    } on LocationPermissionDeniedException catch (e) {
      emit(AttendanceActionFailure(
        e.message,
        isPermissionPermanentlyDenied: e.isPermanent,
      ));
    } on AppException catch (e) {
      emit(AttendanceActionFailure(e.message));
    } catch (e) {
      emit(AttendanceActionFailure(e.toString()));
    }
  }

  void reset() => emit(const AttendanceInitial());
}
