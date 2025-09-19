import 'package:dio/dio.dart';

import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/services/external/secure_storage_service.dart';

/// Handles server-side errors and cleans up tokens on certain cases
class ErrorHandlerInterceptor extends Interceptor {
  final SecureStorageService _secureStorage;

  ErrorHandlerInterceptor(this._secureStorage);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    switch (err.response?.statusCode) {
      case 401:
        // Refresh handled by RefreshTokenInterceptor
        break;

      case 403:
        // Forbidden: clear tokens to force re-login
        await _secureStorage.deleteMultiple([
          SecureStorageConfig.tokenKey,
          SecureStorageConfig.refreshKey,
        ]);
        break;

      case 500:
        err = err.copyWith(error: 'Server error. Please try again later.');
        break;

      case 503:
        err = err.copyWith(
          error: 'Service unavailable. Please try again later.',
        );
        break;
    }

    // Always attach a human-readable message
    err = err.copyWith(error: _formatErrorMessage(err));

    handler.next(err);
  }

  String _formatErrorMessage(DioException err) {
    // Customize error messages if server sends details
    final serverMessage = err.response?.data is Map<String, dynamic>
        ? (err.response?.data['message'] ?? '')
        : '';

    if (serverMessage.isNotEmpty) return serverMessage;
    return err.message ?? 'An unknown error occurred';
  }
}
