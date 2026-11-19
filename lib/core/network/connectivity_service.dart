import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Contract for checking network connectivity.
abstract class ConnectivityService {
  /// Stream of connectivity changes (true = connected, false = offline).
  Stream<bool> get onConnectivityChanged;

  /// Current connectivity status.
  Future<bool> get isConnected;

  /// Dispose resources.
  void dispose();
}

/// Implementation using [connectivity_plus].
///
/// Note: `connectivity_plus` checks the network interface, not actual
/// internet reachability.
class ConnectivityServiceImpl implements ConnectivityService {
  final Connectivity _connectivity;
  late final StreamController<bool> _controller;
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  ConnectivityServiceImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity() {
    _controller = StreamController<bool>.broadcast();
    _subscription =
        _connectivity.onConnectivityChanged.listen((results) {
      _controller.add(_hasConnection(results));
    });
  }

  @override
  Stream<bool> get onConnectivityChanged => _controller.stream;

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) => r != ConnectivityResult.none);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();
  }
}
