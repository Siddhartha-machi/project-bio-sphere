import 'package:flutter/foundation.dart';

import 'package:dio/dio.dart';

import 'package:bio_sphere/dev_utils/logging/app_logger.dart';

/// Logs API requests, responses, and errors for debugging
class CustomLogInterceptor extends Interceptor {
  final AppLogger _logger = AppLogger(tag: 'API');

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.info('➡️ REQUEST[${options.method}] ${options.uri}');
      _logger.info('Headers: ${options.headers}');
      if (options.data != null) {
        _logger.info('Body: ${options.data}');
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.info(
        '✅ RESPONSE[${response.statusCode}] ${response.requestOptions.uri}',
      );
      if (response.data != null) {
        _logger.info('Data: ${response.data}');
      }
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logger.error(
        '❌ ERROR[${err.response?.statusCode}] ${err.requestOptions.uri}',
      );
      _logger.error('Message: ${err.message}');
      if (err.response != null) {
        _logger.error('Response: ${err.response?.data}');
      }
    }
    super.onError(err, handler);
  }
}
