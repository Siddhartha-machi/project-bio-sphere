import 'dart:async';

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Queues requests when offline and resumes when connection is restored
class ConnectivityInterceptor extends Interceptor {
  bool _isOnline = false;
  final Connectivity _connectivity;
  final List<Completer<void>> _pendingRequests = [];

  ConnectivityInterceptor(this._connectivity) {
    _initConnectivity();
  }

  void _initConnectivity() {
    // Check initial status
    _connectivity.checkConnectivity().then((result) {
      _updateStatus(result);
    });

    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      _updateStatus(result);
    });
  }

  void _updateStatus(List<ConnectivityResult> results) {
    _isOnline = results.any((r) => r != ConnectivityResult.none);
    if (_isOnline) _resumeRequests();
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isOnline) {
      // Wait until connectivity is restored
      final completer = Completer<void>();
      _pendingRequests.add(completer);
      await completer.future;
    }
    handler.next(options);
  }

  void _resumeRequests() {
    for (final completer in _pendingRequests) {
      if (!completer.isCompleted) {
        completer.complete();
      }
    }
    _pendingRequests.clear();
  }
}
