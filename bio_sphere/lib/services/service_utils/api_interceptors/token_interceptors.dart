import 'dart:async';

import 'package:dio/dio.dart';

import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/services/external/secure_storage_service.dart';

/// Refreshes expired tokens and retries the failed request
class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;
  final SecureStorageService _secureStorage;
  final List<Completer<void>> _requestsQueue = [];

  RefreshTokenInterceptor(this._dio, this._secureStorage);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldRefresh(err)) {
      if (_isRefreshing) {
        return _queueRequest(err, handler);
      }

      _isRefreshing = true;
      try {
        await _refreshToken();
        final response = await _retryRequest(err.requestOptions);
        handler.resolve(response);

        _processQueue();
      } catch (e) {
        // Refresh failed → reject all queued requests
        await _clearTokens();
        handler.reject(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }

  bool _shouldRefresh(DioException err) {
    return err.response?.statusCode == 401 &&
        err.requestOptions.extra['skip_auth'] != true;
  }

  Future<void> _refreshToken() async {
    final refreshToken = await _secureStorage.read(
      SecureStorageConfig.refreshKey,
    );

    if (refreshToken == null) throw Exception('No refresh token');

    final response = await _dio.post(
      '/auth/refresh',
      data: {'refresh_token': refreshToken},
      options: Options(extra: {'skip_auth': true}),
    );

    final newAccessToken = response.data['access_token'];
    await _secureStorage.write(SecureStorageConfig.tokenKey, newAccessToken);
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions options) async {
    final token = await _secureStorage.read(SecureStorageConfig.tokenKey);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return _dio.fetch(options);
  }

  Future<void> _queueRequest(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final completer = Completer<void>();
    _requestsQueue.add(completer);

    try {
      await completer.future;
      final response = await _retryRequest(err.requestOptions);
      handler.resolve(response);
    } catch (_) {
      handler.reject(err);
    }
  }

  void _processQueue() {
    for (final completer in _requestsQueue) {
      if (!completer.isCompleted) completer.complete();
    }
    _requestsQueue.clear();
  }

  Future<void> _clearTokens() async {
    await _secureStorage.delete(SecureStorageConfig.tokenKey);
    await _secureStorage.delete(SecureStorageConfig.refreshKey);
  }
}
