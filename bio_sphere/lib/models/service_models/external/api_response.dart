/// Standardized REST API response wrapper.
/// Encapsulates both success and error cases in a type-safe way.
class APIResponse {
  /// Parsed data (already mapped into a model).
  final dynamic data;

  /// Whether the request succeeded (true for HTTP 2xx).
  final bool isSuccess;

  /// Error details (only available when [isSuccess] is false).
  final APIError? error;

  /// Pagination metadata (if the API response is paginated).
  final APIPagination? pagination;

  const APIResponse({
    this.data,
    this.error,
    this.pagination,
    required this.isSuccess,
  });

  /// Creates a successful response.
  factory APIResponse.success(dynamic data, {APIPagination? pagination}) {
    return APIResponse(isSuccess: true, data: data, pagination: pagination);
  }

  /// Creates a failed response.
  factory APIResponse.error(APIError error) {
    return APIResponse(isSuccess: false, error: error);
  }

  /// Convenience getter: whether pagination exists.
  bool get hasPagination => pagination != null;
}

/// Standard REST API error representation.
/// Provides consistent error handling across services.
class APIError {
  /// HTTP status code (e.g., 400, 401, 500).
  final int statusCode;

  /// A short, backend-defined error code (optional).
  final String? code;

  /// Human-readable error message.
  final String message;

  /// Raw JSON body from the backend for debugging or custom mapping.
  final Map<String, dynamic>? raw;

  const APIError({
    this.raw,
    this.code,
    required this.message,
    required this.statusCode,
  });

  @override
  String toString() =>
      'RestApiError(statusCode: $statusCode, code: $code, message: $message)';
}

/// REST API pagination metadata.
/// Supports both offset-based and page-based pagination styles.
class APIPagination {
  /// Current page number (page-based APIs).
  final int? currentPage;

  /// Total number of pages (if provided by backend).
  final int? totalPages;

  /// Total number of items (if provided).
  final int? totalItems;

  /// Limit or per-page size.
  final int? perPage;

  /// Offset (for offset-based pagination).
  final int? offset;

  /// Whether more pages exist.
  final bool hasMore;

  const APIPagination({
    this.offset,
    this.perPage,
    this.totalItems,
    this.totalPages,
    this.currentPage,
    this.hasMore = false,
  });

  @override
  String toString() =>
      'Pagination(currentPage: $currentPage, totalPages: $totalPages, '
      'totalItems: $totalItems, perPage: $perPage, offset: $offset, hasMore: $hasMore)';
}
