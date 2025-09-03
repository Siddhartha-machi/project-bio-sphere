import 'package:bio_sphere/models/service_models/pagination_context.dart';

/* 
|------------------------------|
  ServiceResponse
    - Unified response from any data service (API, DB, Firebase, etc.)
    - returns data or service error
    - pagination and other data is added in meta
|------------------------------|
*/

class ServiceResponse<T> {
  /// Actual data (already mapped into models)
  final T? data;

  /// Error info if failed
  final ServiceError? error;

  /// Pagination information for list-type requests.
  final PaginationContext? pagination;

  /// Extra metadata (filters, request id, cache info, etc.)
  final Map<String, dynamic>? meta;

  const ServiceResponse({this.data, this.pagination, this.meta, this.error});

  /// Factory helpers
  factory ServiceResponse.success(
    T data, {
    Map<String, dynamic>? meta,
    PaginationContext? pagination,
  }) {
    return ServiceResponse(data: data, meta: meta, pagination: pagination);
  }

  factory ServiceResponse.error(
    ServiceError error, {
    Map<String, dynamic>? meta,
  }) {
    return ServiceResponse(error: error, meta: meta);
  }

  bool get isSuccess => data != null && error == null;
}

/// Standardized error for services
class ServiceError {
  final int? code;
  final dynamic raw;
  final String message;

  const ServiceError({this.code, required this.message, this.raw});
}
