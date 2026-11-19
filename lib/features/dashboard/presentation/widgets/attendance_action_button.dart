import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../app/config/environment.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/location/location_service.dart';
import '../../../attendance/domain/entities/attendance_record.dart';
import '../../../attendance/presentation/cubit/attendance_cubit.dart';
import '../../../attendance/presentation/cubit/attendance_state.dart';

class AttendanceActionButton extends StatelessWidget {
  final String employeeId;
  final AttendanceRecord todayRecord;

  const AttendanceActionButton({
    super.key,
    required this.employeeId,
    required this.todayRecord,
  });

  void _showLocationDisabledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.location_off, color: Colors.amber.shade900, size: 36),
        ),
        title: const Text(
          'Location Services Disabled',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'GPS location services are turned off on your device. REBS HRMS requires GPS to verify that you are within 200 metres of the company office.\n\nPlease enable Location / GPS in your device settings.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogCtx);
              sl<LocationService>().openLocationSettings();
            },
            icon: const Icon(Icons.settings, size: 18),
            label: const Text('Open Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.security, color: Colors.red.shade900, size: 36),
        ),
        title: const Text(
          'Location Permission Required',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Location permission is permanently denied. Please grant Location permission in App Settings so REBS HRMS can verify attendance.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(dialogCtx);
              sl<LocationService>().openAppSettings();
            },
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Open App Settings'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AttendanceCubit, AttendanceState>(
      listener: (context, state) {
        if (state is AttendanceActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: state.event.isSynced
                  ? Colors.green.shade700
                  : Colors.orange.shade800,
            ),
          );
        } else if (state is AttendanceActionFailure) {
          if (state.isLocationDisabled) {
            _showLocationDisabledDialog(context);
          } else if (state.isPermissionPermanentlyDenied) {
            _showPermissionDeniedDialog(context);
          } else {
            final isRadiusError = state.errorMessage.contains('away from the office');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red.shade700,
                duration: Duration(seconds: isRadiusError ? 7 : 4),
                action: isRadiusError
                    ? SnackBarAction(
                        label: 'Simulate Inside',
                        textColor: Colors.amberAccent,
                        onPressed: () {
                          final config = sl<AppConfig>();
                          sl<LocationService>().setDebugOverride(
                            latitude: config.officeLatitude + 0.00005,
                            longitude: config.officeLongitude + 0.00005,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('✓ Simulated inside office (~10m). Tap Check In again!'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        },
                      )
                    : null,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is AttendanceActionInProgress;
        final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

        if (todayRecord.isCheckedOut) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Text(
                    "Today's Attendance Completed",
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final isCheckIn = todayRecord.isNotCheckedIn;
        final buttonColor = isCheckIn
            ? const Color(0xFF2E7D32) // Forest green
            : const Color(0xFFC62828); // Crimson red
        final buttonLabel = isCheckIn ? 'Check In' : 'Check Out';
        final buttonIcon = isCheckIn ? Icons.login : Icons.logout;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: isLoading
                  ? null
                  : () {
                      if (isCheckIn) {
                        context.read<AttendanceCubit>().checkIn(
                              employeeId: employeeId,
                              companyDate: todayDate,
                            );
                      } else {
                        context.read<AttendanceCubit>().checkOut(
                              employeeId: employeeId,
                              companyDate: todayDate,
                            );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Icon(buttonIcon, size: 22),
              label: Text(
                isLoading
                    ? (state).action
                    : buttonLabel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
