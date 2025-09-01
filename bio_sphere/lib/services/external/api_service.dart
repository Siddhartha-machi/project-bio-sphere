import 'dart:io';
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/services/external/secure_storage_service.dart';
import 'package:bio_sphere/models/service_models/external/api_response.dart';
import 'package:bio_sphere/services/service_utils/api_interceptors/auth_interceptor.dart';
import 'package:bio_sphere/services/service_utils/api_interceptors/error_interceptor.dart';
import 'package:bio_sphere/services/service_utils/api_interceptors/logger_interceptor.dart';
import 'package:bio_sphere/services/service_utils/api_interceptors/token_interceptors.dart';
import 'package:bio_sphere/services/service_utils/api_interceptors/connectivity_interceptor.dart';

/// Centralized API service that wires up all interceptors
/// - Authentication handling
/// - Token refresh
/// - Connectivity-aware requests
/// - Error handling
/// - Request/Response logging
class ApiService {
  late final Dio _dio;
  final SecureStorageService _secureStorage;

  ApiService(this._secureStorage) {
    _dio = Dio(
      BaseOptions(
        responseType: ResponseType.json,
        baseUrl: 'https://api.example.com',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(_secureStorage), // Add access token to requests
      RefreshTokenInterceptor(_dio, _secureStorage), // Refresh expired tokens
      ConnectivityInterceptor(Connectivity()), // Queue requests when offline
      ErrorHandlerInterceptor(_secureStorage), // Handle server errors
      CustomLogInterceptor(), // Log all requests/responses
    ]);
  }

  /// Core request method returning APIResponse
  Future<APIResponse> request(
    String path, {
    dynamic data,
    Options? options,
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

      return _transformResponse(response);
    } on DioException catch (e) {
      return _transformError(e);
    } catch (e) {
      return APIResponse.error(APIError(statusCode: -1, message: e.toString()));
    }
  }

  /// Uploads one or more files with optional form fields.
  ///
  /// [path] - API endpoint.
  /// [headers] - Optional headers.
  /// [files] - A map of fieldName -> File(s).
  /// [fields] - Additional form fields to send.
  /// [onSendProgress] - Progress callback for tracking upload progress.
  Future<APIResponse> uploadFiles({
    required String path,
    Map<String, dynamic>? fields,
    Map<String, dynamic>? headers,
    ProgressCallback? onSendProgress,
    required Map<String, List<File>> files,
  }) async {
    try {
      final formData = FormData();

      // Add multiple files
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

      // Add additional form fields
      if (fields != null) {
        formData.fields.addAll(
          fields.entries.map((e) => MapEntry(e.key, e.value.toString())),
        );
      }

      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(headers: headers, contentType: "multipart/form-data"),
      );

      return _transformResponse(response);
    } on DioException catch (e) {
      return _transformError(e);
    } catch (e) {
      return APIResponse.error(
        APIError(statusCode: -1, message: e.toString(), raw: null),
      );
    }
  }

  // --------------------------
  // Response Transformers
  // --------------------------

  APIResponse _transformResponse(Response response) {
    final data = response.data;

    final bool hasPagination =
        data is Map<String, dynamic> &&
        (data.containsKey('next_page') ||
            data.containsKey('prev_page') ||
            data.containsKey('current_page'));

    return APIResponse.success(
      data['data'] ?? data,
      pagination: hasPagination
          ? APIPagination(
              currentPage: data['current_page'],
              totalPages: data['total_pages'],
              totalItems: data['total_items'],
              perPage: data['per_page'],
              offset: data['offset'],
              hasMore: data['next_page'] != null,
            )
          : null,
    );
  }

  APIResponse _transformError(DioException e) {
    final errorData = e.response?.data;

    return APIResponse.error(
      APIError(
        statusCode: e.response?.statusCode ?? -1,
        message: errorData is Map<String, dynamic>
            ? (errorData['message'] ?? e.message ?? 'Unknown error')
            : e.message ?? 'Unknown error',
        code: errorData is Map<String, dynamic> ? errorData['code'] : null,
        raw: errorData is Map<String, dynamic> ? errorData : null,
      ),
    );
  }
}
