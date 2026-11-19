import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/config/environment.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/sync/sync_manager.dart';
import '../../../attendance/domain/repositories/attendance_repository.dart';
import '../../../leave/domain/repositories/leave_repository.dart';

class DebugPanelPage extends StatefulWidget {
  const DebugPanelPage({super.key});

  @override
  State<DebugPanelPage> createState() => _DebugPanelPageState();
}

class _DebugPanelPageState extends State<DebugPanelPage> {
  final LocationService _locationService = sl<LocationService>();
  final SyncManager _syncManager = sl<SyncManager>();
  final DioClient _dioClient = sl<DioClient>();
  final AppConfig _config = sl<AppConfig>();

  String _currentScenario = 'normal';
  bool _isLoadingScenario = false;
  String _statusMessage = '';
  late String _currentBaseUrl;

  @override
  void initState() {
    super.initState();
    _currentBaseUrl = _dioClient.baseUrl;
    _fetchCurrentScenario();
  }

  void _showEditBaseUrlDialog() {
    final controller = TextEditingController(text: _currentBaseUrl);
    String testStatus = '';
    bool isTesting = false;

    showDialog(
      context: context,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Row(
              children: [
                Icon(Icons.edit_road, color: Colors.indigo),
                SizedBox(width: 8),
                Text('Change Mock API URL', style: TextStyle(fontSize: 18)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select a target environment or enter custom server URL:',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.cloud_done, size: 16),
                        label: const Text('Live Cloud (Render)'),
                        onPressed: () {
                          setDialogState(() {
                            controller.text = 'https://rebs-hrms.onrender.com';
                            testStatus = '';
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.usb, size: 16),
                        label: const Text('USB / ADB (localhost:3000)'),
                        onPressed: () {
                          setDialogState(() {
                            controller.text = 'http://127.0.0.1:3000';
                            testStatus = '';
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.wifi, size: 16),
                        label: const Text('Wi-Fi (192.168.1.8:3000)'),
                        onPressed: () {
                          setDialogState(() {
                            controller.text = 'http://192.168.1.8:3000';
                            testStatus = '';
                          });
                        },
                      ),
                      ActionChip(
                        avatar: const Icon(Icons.phone_android, size: 16),
                        label: const Text('Emulator (10.0.2.2:3000)'),
                        onPressed: () {
                          setDialogState(() {
                            controller.text = 'http://10.0.2.2:3000';
                            testStatus = '';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'API Base URL',
                      hintText: 'http://192.168.1.8:3000',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (testStatus.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        testStatus,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: testStatus.contains('Successful') ? Colors.green : Colors.red,
                        ),
                      ),
                    ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: isTesting
                          ? null
                          : () async {
                              setDialogState(() {
                                isTesting = true;
                                testStatus = 'Testing connection...';
                              });
                              try {
                                final dioClient = sl<DioClient>();
                                dioClient.updateBaseUrl(controller.text.trim());
                                await dioClient.get('/health');
                                setDialogState(() {
                                  isTesting = false;
                                  testStatus = '✓ Successful! Server responded 200 OK';
                                });
                              } catch (e) {
                                setDialogState(() {
                                  isTesting = false;
                                  testStatus = '✗ Failed: $e';
                                });
                              }
                            },
                      icon: isTesting
                          ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.network_check, size: 16),
                      label: const Text('Test Connection'),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final newUrl = controller.text.trim();
                  if (newUrl.isNotEmpty) {
                    sl<DioClient>().updateBaseUrl(newUrl);
                    setState(() {
                      _currentBaseUrl = newUrl;
                      _statusMessage = 'API URL updated to: $newUrl';
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _fetchCurrentScenario() async {
    try {
      final res = await _dioClient.get(ApiEndpoints.scenariosCurrent);
      final map = res.data is Map ? res.data as Map : {};
      final data = map['data'] is Map ? map['data'] as Map : {};
      if (mounted) {
        setState(() {
          _currentScenario = data['scenario']?.toString() ?? 'normal';
        });
      }
    } catch (_) {}
  }

  Future<void> _setScenario(String scenario) async {
    setState(() => _isLoadingScenario = true);
    try {
      await _dioClient.post(
        ApiEndpoints.scenariosSet,
        data: {'scenario': scenario},
      );
      setState(() {
        _currentScenario = scenario;
        _statusMessage = 'Mock server scenario set to: $scenario';
      });
    } catch (e) {
      setState(() => _statusMessage = 'Failed to set scenario: $e');
    } finally {
      setState(() => _isLoadingScenario = false);
    }
  }

  Future<void> _resetTodayAttendance() async {
    setState(() => _isLoadingScenario = true);
    try {
      final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      await sl<AttendanceRepository>().resetTodayAttendance(todayDate);
      try {
        await _dioClient.post(ApiEndpoints.reset);
      } catch (_) {
        // Safe if offline
      }
      setState(() {
        _currentScenario = 'normal';
        _statusMessage = '✓ Today\'s attendance reset! Go to Home tab to test Check In again.';
      });
    } catch (e) {
      setState(() => _statusMessage = 'Failed to reset: $e');
    } finally {
      setState(() => _isLoadingScenario = false);
    }
  }

  Future<void> _resetLeaveBalances() async {
    setState(() => _isLoadingScenario = true);
    try {
      final employeeId = _config.defaultEmployeeId;
      await sl<LeaveRepository>().resetLeaveData(employeeId);
      try {
        await _dioClient.post(ApiEndpoints.reset);
      } catch (_) {
        // Safe if offline
      }
      setState(() {
        _statusMessage = '✓ Leave balances reset to Casual: 2, Sick: 3 & requests cleared!';
      });
    } catch (e) {
      setState(() => _statusMessage = 'Failed to reset leave: $e');
    } finally {
      setState(() => _isLoadingScenario = false);
    }
  }

  Future<void> _resetAllData() async {
    setState(() => _isLoadingScenario = true);
    try {
      await sl<AttendanceRepository>().clearAllAttendance();
      await sl<LeaveRepository>().resetLeaveData(_config.defaultEmployeeId);
      try {
        await _dioClient.post(ApiEndpoints.reset);
      } catch (_) {}
      setState(() {
        _currentScenario = 'normal';
        _statusMessage = '✓ All local & server data (attendance + leaves) reset to fresh initial seeds!';
      });
    } catch (e) {
      setState(() => _statusMessage = 'Failed to reset: $e');
    } finally {
      setState(() => _isLoadingScenario = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final override = _locationService.currentDebugOverride;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug & Simulation Panel'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status banner
            if (_statusMessage.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Text(
                  _statusMessage,
                  style: TextStyle(color: Colors.blue.shade900, fontSize: 13),
                ),
              ),

            // Backend API & Network Routing Section
            _buildSectionHeader('Backend API & Network Routing', Icons.router),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Active API Base URL: ',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Expanded(
                          child: Text(
                            _currentBaseUrl,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _showEditBaseUrlDialog,
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Configure / Switch API URL'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Location Simulation Section
            _buildSectionHeader('GPS Location Simulation', Icons.location_on),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configured Office: ${_config.officeLatitude}, ${_config.officeLongitude} (Radius: ${_config.officeRadiusMeters.toInt()}m)',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Active Override: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            override != null
                                ? '${override.$1.toStringAsFixed(4)}, ${override.$2.toStringAsFixed(4)}'
                                : 'None (Using Real GPS)',
                            style: TextStyle(
                              color: override != null ? Colors.orange.shade800 : Colors.green.shade800,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Inside office coordinates (10m from office)
                            _locationService.setDebugOverride(
                              latitude: _config.officeLatitude + 0.00005,
                              longitude: _config.officeLongitude + 0.00005,
                            );
                            setState(() {
                              _statusMessage = 'Location simulated: Inside Office (~10m)';
                            });
                          },
                          icon: const Icon(Icons.check_circle_outline, size: 16),
                          label: const Text('Inside Office (~10m)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Outside office coordinates (>200m)
                            _locationService.setDebugOverride(
                              latitude: _config.officeLatitude + 0.005, // ~550m away
                              longitude: _config.officeLongitude + 0.005,
                            );
                            setState(() {
                              _statusMessage = 'Location simulated: Outside Office (~550m)';
                            });
                          },
                          icon: const Icon(Icons.highlight_off, size: 16),
                          label: const Text('Outside Office (>200m)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        OutlinedButton(
                          onPressed: () {
                            _locationService.clearDebugOverride();
                            setState(() {
                              _statusMessage = 'Location override cleared. Using real GPS.';
                            });
                          },
                          child: const Text('Clear Override'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Mock Server Scenarios Section
            _buildSectionHeader('Mock Server Scenarios', Icons.science),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Active Server Scenario: ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            _currentScenario.toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (_isLoadingScenario)
                      const Center(child: CircularProgressIndicator())
                    else
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _scenarioChip('normal', 'A: Normal Success'),
                          _scenarioChip('slow', 'B: Slow API (3s)'),
                          _scenarioChip('timeout', 'C: Timeout Simulation'),
                          _scenarioChip('server_error', 'D: Server Error (500)'),
                          _scenarioChip('duplicate_conflict', 'E: Duplicate Conflict (409)'),
                          _scenarioChip('leave_rejection', 'F: Leave Rejection (422)'),
                        ],
                      ),
                    const Divider(height: 24),
                    const Text(
                      'Testing & Simulation Resets:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isLoadingScenario ? null : _resetTodayAttendance,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.today, size: 18),
                            label: const Text(
                              'Reset Today\'s Attendance (Test Again)',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _isLoadingScenario ? null : _resetLeaveBalances,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            icon: const Icon(Icons.beach_access, size: 18),
                            label: const Text(
                              'Reset Leave Balances (Casual: 2, Sick: 3)',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: _isLoadingScenario ? null : _resetAllData,
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red.shade700,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            icon: const Icon(Icons.restore, size: 16),
                            label: const Text(
                              'Factory Reset All Data (Attendance + Leaves)',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Outbox & Sync Controls Section
            _buildSectionHeader('Outbox & Sync Controls', Icons.sync),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Trigger immediate outbox synchronization of pending events.',
                      style: TextStyle(fontSize: 13),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final res = await _syncManager.syncNow();
                        setState(() {
                          _statusMessage =
                              'Sync Result: ${res.synced} synced, ${res.rejected} rejected, ${res.failed} failed out of ${res.total} total.';
                        });
                      },
                      icon: const Icon(Icons.cloud_upload),
                      label: const Text('Trigger Sync Now'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scenarioChip(String scenario, String label) {
    final isSelected = _currentScenario == scenario;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => _setScenario(scenario),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).primaryColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
