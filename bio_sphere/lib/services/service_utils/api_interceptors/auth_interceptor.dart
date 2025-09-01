import 'dart:async';

import 'package:dio/dio.dart';

import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/services/external/secure_storage_service.dart';

/// Adds the access token to requests unless explicitly skipped
class AuthInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  AuthInterceptor(this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.read(SecureStorageConfig.tokenKey);

    // Attach token only if available and not marked to skip auth
    if (token != null && !_shouldSkipAuth(options)) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  bool _shouldSkipAuth(RequestOptions options) {
    return options.extra['skip_auth'] == true;
  }
}
