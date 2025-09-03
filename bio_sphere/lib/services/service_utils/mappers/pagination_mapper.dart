import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/constants/catalog_constants.dart';
import 'package:bio_sphere/models/service_models/pagination_context.dart';

class PaginationMapper {
  static PaginationContext _offsetLimitPaginationMapper(dynamic response) {
    final total = response['total'] as int;
    final limit = response['limit'] as int;
    final offset = response['offset'] as int;

    return PaginationContext(
      perPage: limit,
      totalItems: total,
      hasMore: (offset + limit) < total,
      totalPages: (total / limit).ceil(),
      currentPage: (offset ~/ limit) + 1,
    );
  }

  static PaginationContext _localDbPaginationMapper(dynamic response) {
    final total = response['total'] as int;
    final limit = response['limit'] as int;
    final offset = response['offset'] as int;

    return PaginationContext(
      perPage: limit,
      totalItems: total,
      hasMore: (offset + limit) < total,
      totalPages: (total / limit).ceil(),
      currentPage: (offset ~/ limit) + 1,
    );
  }

  static PaginationContext _cursorPaginationMapper(dynamic response) {
    /// TODO
    // final snapshot = response as QuerySnapshot;

    // return PaginationContext(
    //   currentPage: null, // no concept of page
    //   totalPages: null,
    //   totalItems: null, // requires an extra count query
    //   perPage: snapshot.docs.length,
    //   hasMore: snapshot.docs.isNotEmpty,
    //   cursor: snapshot.docs.isNotEmpty ? snapshot.docs.last : null,
    // );
    throw Exception('Mapper not supported.');
  }

  static PaginationContext mapTo(Backend type, dynamic response) {
    switch (type) {
      case Backend.api:
        return _offsetLimitPaginationMapper(response);
      case Backend.localDB:
        return _localDbPaginationMapper(response);
      default:
        throw UnsupportedError('Unsupported pagination type: $type');
    }
  }
}
