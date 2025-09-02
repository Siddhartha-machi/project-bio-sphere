import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/services/external/secure_storage_service.dart';
import 'package:bio_sphere/models/service_models/external/backend_service_models.dart';
import 'package:bio_sphere/services/service_utils/api_interceptors/auth_interceptor.dart';
import 'package:bio_sphere/services/service_utils/api_interceptors/error_interceptor.dart';
import 'package:bio_sphere/services/service_utils/api_interceptors/logger_interceptor.dart';
import 'package:bio_sphere/services/service_utils/api_interceptors/token_interceptors.dart';
import 'package:bio_sphere/services/service_utils/api_interceptors/connectivity_interceptor.dart';

/* 
|------------------------------|
  ApiService
    - Centralized API service that wires up all interceptors
    - Authentication handling
    - Token refresh
    - Connectivity-aware requests
    - Error handling
    - Request/Response logging
|------------------------------|
*/

class ApiService {
  final String path;
  late final Dio _dio;
  final SecureStorageService _secureStorage = SecureStorageService();

  ApiService(this.path) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com$path',
        responseType: ResponseType.json,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(_secureStorage), // Adds access token
      RefreshTokenInterceptor(_dio, _secureStorage), // Refresh expired tokens
      ConnectivityInterceptor(Connectivity()), // Queue requests offline
      ErrorHandlerInterceptor(_secureStorage), // Handle server errors
      CustomLogInterceptor(), // Log requests/responses
    ]);
  }

  /// Core request method returning standardized BackendResponse
  Future<BackendResponse> request({
    dynamic data,
    Options? options,
    String path = '',
    Map<String, dynamic>? headers,
    String method = HttpMethod.get,
    Map<String, dynamic>? queryParams,
  }) async {
    final requestOptions = (options ?? Options()).copyWith(
      method: method,
      headers: headers,
    );

    try {
      final response = await _dio.request(
        path,
        data: data,
        options: requestOptions,
        queryParameters: queryParams,
      );

      // Extract pagination if present (common APIs put it in headers or body)
      final pagination = _extractPagination(response);

      return BackendResponse.success(
        response.data, // raw JSON
        pagination: pagination,
      );
    } on DioException catch (e) {
      return BackendResponse.error(_mapDioError(e));
    } catch (e) {
      return BackendResponse.error(
        BackendError(
          raw: e,
          code: 'UNKNOWN',
          statusCode: null,
          message: e.toString(),
        ),
      );
    }
  }

  /// Uploads one or more files with optional form fields.
  Future<BackendResponse> uploadFiles({
    required String path,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? headers,
    ProgressCallback? onSendProgress,
    required Map<String, List<File>> files,
  }) async {
    final formData = FormData();

    // Add files
    for (final entry in files.entries) {
      final fieldName = entry.key;
      for (final file in entry.value) {
        formData.files.add(
          MapEntry(
            fieldName,
            await MultipartFile.fromFile(
              file.path,
              filename: file.uri.pathSegments.last,
            ),
          ),
        );
      }
    }

    // Add extra fields
    if (fields != null) {
      formData.fields.addAll(
        fields.entries.map((e) => MapEntry(e.key, e.value.toString())),
      );
    }

    try {
      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(headers: headers, contentType: "multipart/form-data"),
      );

      return BackendResponse.success(response.data);
    } on DioException catch (e) {
      return BackendResponse.error(_mapDioError(e));
    } catch (e) {
      return BackendResponse.error(
        BackendError(
          statusCode: null,
          code: 'UNKNOWN',
          message: e.toString(),
          raw: e,
        ),
      );
    }
  }

  /// Helper to extract pagination info from API response
  BackendPagination? _extractPagination(Response response) {
    try {
      final headers = response.headers.map;
      final data = response.data;

      // Example: page-based pagination in headers
      if (headers.containsKey('x-total-count')) {
        final totalItems = int.tryParse(headers['x-total-count']?.first ?? '');
        final perPage = int.tryParse(headers['x-per-page']?.first ?? '');
        final currentPage = int.tryParse(headers['x-page']?.first ?? '');
        final totalPages = int.tryParse(headers['x-total-pages']?.first ?? '');

        return BackendPagination(
          currentPage: currentPage,
          totalPages: totalPages,
          totalItems: totalItems,
          perPage: perPage,
          hasMore: currentPage != null && totalPages != null
              ? currentPage < totalPages
              : false,
        );
      }

      // Example: cursor-based pagination in body
      if (data is Map<String, dynamic> && data.containsKey('nextCursor')) {
        return BackendPagination(
          nextCursor: data['nextCursor'] as String?,
          hasMore: data['nextCursor'] != null,
        );
      }
    } catch (_) {
      // Ignore pagination parse errors
    }
    return null;
  }

  /// Map DioException into BackendError
  BackendError _mapDioError(DioException e) {
    if (e.response != null) {
      return BackendError(
        statusCode: e.response?.statusCode,
        code: e.response?.statusMessage,
        message: e.message ?? 'Request failed',
        raw: e.response?.data,
      );
    }

    return BackendError(
      statusCode: null,
      code: e.type.name,
      message: e.message ?? 'Unexpected error',
      raw: e,
    );
  }
}
