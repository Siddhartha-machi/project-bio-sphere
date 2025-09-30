import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkConnection {
  bool _isOnline = false;
  bool _initialized = false;
  StreamSubscription<InternetStatus>? _netSub;

  NetworkConnection();

  Future<bool> isOnline() async {
    if (_initialized) return _isOnline;

    // Subscribe to status changes
    _netSub = InternetConnection().onStatusChange.listen((status) {
      final newStatus = status == InternetStatus.connected;

      if (newStatus != _isOnline) _isOnline = newStatus;
    });

    // First connectivity check
    _isOnline = await InternetConnection().hasInternetAccess;

    _initialized = true;

    return _isOnline;
  }

  /// Clean up
  void dispose() {
    _netSub?.cancel();
  }
}
