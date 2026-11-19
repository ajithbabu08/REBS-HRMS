import 'dart:async';

import 'package:flutter/foundation.dart';

import '../network/connectivity_service.dart';
import 'sync_result.dart';
import 'sync_service.dart';

/// Sync state exposed to the UI.
enum SyncState { idle, syncing, synced, error, offline }

/// Manages automatic and manual syncing of pending events.
///
/// Listens to connectivity changes and auto-triggers sync when
/// the device comes back online.
class SyncManager {
  final SyncService _syncService;
  final ConnectivityService _connectivityService;

  final _stateController = StreamController<SyncState>.broadcast();
  StreamSubscription<bool>? _connectivitySub;
  bool _isSyncing = false;

  SyncManager({
    required SyncService syncService,
    required ConnectivityService connectivityService,
  })  : _syncService = syncService,
        _connectivityService = connectivityService {
    _connectivitySub =
        _connectivityService.onConnectivityChanged.listen(_onConnectivityChanged);
  }

  /// Stream of sync state changes.
  Stream<SyncState> get stateStream => _stateController.stream;

  /// Manually trigger a sync cycle.
  Future<SyncResult> syncNow() async {
    if (_isSyncing) return const SyncResult();

    _isSyncing = true;
    _stateController.add(SyncState.syncing);

    try {
      final result = await _syncService.syncPendingEvents();

      if (result.hasErrors) {
        _stateController.add(SyncState.error);
      } else if (result.total == 0) {
        _stateController.add(SyncState.idle);
      } else {
        _stateController.add(SyncState.synced);
      }

      return result;
    } catch (e) {
      debugPrint('SyncManager error: $e');
      _stateController.add(SyncState.error);
      return const SyncResult();
    } finally {
      _isSyncing = false;
    }
  }

  void _onConnectivityChanged(bool isConnected) {
    if (isConnected) {
      syncNow();
    } else {
      _stateController.add(SyncState.offline);
    }
  }

  /// Clean up resources.
  void dispose() {
    _connectivitySub?.cancel();
    _stateController.close();
  }
}
