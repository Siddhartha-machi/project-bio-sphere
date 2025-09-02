/* 
|------------------------------|
  BackendResponse
    - Standardized Backend response wrapper.
    - Holds raw backend data (untyped), leaving mapping to service layer.
|------------------------------|
*/

class BackendResponse {
  /// Raw data (JSON map, Firestore snapshot, SQL rows, etc.)
  final dynamic rawData;

  /// Whether the request succeeded.
  final bool isSuccess;

  /// Error details (present when [isSuccess] is false).
  final BackendError? error;

  /// Pagination or streaming metadata.
  final BackendPagination? pagination;

  const BackendResponse({
    this.rawData,
    this.error,
    this.pagination,
    required this.isSuccess,
  });

  /// Successful response with raw data.
  factory BackendResponse.success(
    dynamic rawData, {
    BackendPagination? pagination,
  }) {
    return BackendResponse(
      isSuccess: true,
      rawData: rawData,
      pagination: pagination,
    );
  }

  /// Failed response with error info.
  factory BackendResponse.error(BackendError error) {
    return BackendResponse(isSuccess: false, error: error);
  }

  bool get hasPagination => pagination != null;

  @override
  String toString() =>
      'BackendResponse(success: $isSuccess, rawData: $rawData, '
      'error: $error, pagination: $pagination)';
}

/* 
|------------------------------|
  BackendError
    - Unified backend error representation.
    - Works for REST, Firebase, gRPC, Local DB, etc.
|------------------------------|
*/

class BackendError {
  /// Numeric code (HTTP status, gRPC code, or custom DB code).
  final int? statusCode;

  /// Short, backend-defined error code (optional).
  final String? code;

  /// Human-readable message.
  final String message;

  /// Raw error object from the backend.
  final dynamic raw;

  const BackendError({
    this.statusCode,
    this.code,
    required this.message,
    this.raw,
  });

  @override
  String toString() =>
      'BackendError(statusCode: $statusCode, code: $code, message: $message, raw: $raw)';
}

/* 
|------------------------------|
  BackendError
    - Unified pagination metadata.
    - Can represent page, offset, cursor, or streaming style pagination.
|------------------------------|
*/

class BackendPagination {
  /// Page-based APIs.
  final int? currentPage;
  final int? totalPages;

  /// Item counts.
  final int? totalItems;
  final int? perPage;

  /// Offset-based APIs.
  final int? offset;

  /// Cursor/token-based APIs (GraphQL, Firebase).
  final String? nextCursor;

  /// True if more results are available.
  final bool hasMore;

  const BackendPagination({
    this.currentPage,
    this.totalPages,
    this.totalItems,
    this.perPage,
    this.offset,
    this.nextCursor,
    this.hasMore = false,
  });

  @override
  String toString() =>
      'BackendPagination(currentPage: $currentPage, totalPages: $totalPages, '
      'totalItems: $totalItems, perPage: $perPage, offset: $offset, '
      'nextCursor: $nextCursor, hasMore: $hasMore)';
}
