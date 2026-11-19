import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/di/service_locator.dart';
import '../cubit/apply_leave_cubit.dart';
import '../cubit/apply_leave_state.dart';

class ApplyLeavePage extends StatelessWidget {
  final String employeeId;

  const ApplyLeavePage({super.key, required this.employeeId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ApplyLeaveCubit(applyLeaveUseCase: sl()),
      child: _ApplyLeaveView(employeeId: employeeId),
    );
  }
}

class _ApplyLeaveView extends StatefulWidget {
  final String employeeId;

  const _ApplyLeaveView({required this.employeeId});

  @override
  State<_ApplyLeaveView> createState() => _ApplyLeaveViewState();
}

class _ApplyLeaveViewState extends State<_ApplyLeaveView> {
  final _formKey = GlobalKey<FormState>();
  String _selectedLeaveType = 'CASUAL';
  DateTime? _startDate;
  DateTime? _endDate;
  final _reasonController = TextEditingController();

  int get _calculatedDays {
    if (_startDate == null || _endDate == null) return 0;
    if (_endDate!.isBefore(_startDate!)) return 0;
    return _endDate!.difference(_startDate!).inDays + 1;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _pickEndDate() async {
    final now = DateTime.now();
    final initial = _endDate ?? _startDate ?? now;
    final first = _startDate ?? now;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : initial,
      firstDate: first,
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _submit() {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date.')),
      );
      return;
    }
    if (_endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an end date.')),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<ApplyLeaveCubit>().submit(
            employeeId: widget.employeeId,
            leaveType: _selectedLeaveType,
            startDate: _startDate!,
            endDate: _endDate!,
            reason: _reasonController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplyLeaveCubit, ApplyLeaveState>(
      listener: (context, state) {
        if (state is ApplyLeaveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.green.shade700,
            ),
          );
          Navigator.pop(context, true);
        } else if (state is ApplyLeaveFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red.shade700,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state is ApplyLeaveSubmitting;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Apply for Leave'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Leave Type Selector
                  const Text(
                    'Leave Type',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedLeaveType,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.category_outlined),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'CASUAL',
                        child: Text('Casual Leave (Available: 2)'),
                      ),
                      DropdownMenuItem(
                        value: 'SICK',
                        child: Text('Sick Leave (Available: 3)'),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedLeaveType = val);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Dates
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Start Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: isSubmitting ? null : _pickStartDate,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon:
                                      const Icon(Icons.calendar_today, size: 18),
                                ),
                                child: Text(
                                  _startDate != null
                                      ? DateFormat('dd MMM yyyy')
                                          .format(_startDate!)
                                      : 'Select date',
                                  style: TextStyle(
                                    color: _startDate != null
                                        ? Colors.black87
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'End Date',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: isSubmitting ? null : _pickEndDate,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon:
                                      const Icon(Icons.calendar_today, size: 18),
                                ),
                                child: Text(
                                  _endDate != null
                                      ? DateFormat('dd MMM yyyy')
                                          .format(_endDate!)
                                      : 'Select date',
                                  style: TextStyle(
                                    color: _endDate != null
                                        ? Colors.black87
                                        : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Days calculation card
                  if (_calculatedDays > 0)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.blue.shade800, size: 20),
                          const SizedBox(width: 10),
                          Text(
                            'Total Requested: $_calculatedDays Calendar Day${_calculatedDays > 1 ? 's' : ''}',
                            style: TextStyle(
                              color: Colors.blue.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Reason field
                  const Text(
                    'Reason for Leave',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _reasonController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText:
                          'Provide reason for your leave (min. 10 characters)...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Reason is required.';
                      }
                      final nonWhitespace =
                          val.replaceAll(RegExp(r'\s+'), '');
                      if (nonWhitespace.length < 10) {
                        return 'Reason must have at least 10 non-whitespace characters.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Submitting Application...'),
                              ],
                            )
                          : const Text(
                              'Submit Leave Application',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
