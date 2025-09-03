class PaginationContext {
  final int? perPage;
  final bool hasMore;
  final dynamic cursor; // for cursor-based systems (Firestore, GraphQL)
  final int? totalPages;
  final int? totalItems;
  final int? currentPage;

  const PaginationContext({
    this.cursor,
    this.perPage,
    this.totalPages,
    this.totalItems,
    this.currentPage,
    required this.hasMore,
  });

  PaginationContext copyWith({
    int? perPage,
    bool? hasMore,
    String? cursor,
    int? totalPages,
    int? totalItems,
    int? currentPage,
  }) {
    return PaginationContext(
      cursor: cursor ?? this.cursor,
      perPage: perPage ?? this.perPage,
      hasMore: hasMore ?? this.hasMore,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  String toString() =>
      'PaginationContext:\n\tpage: $currentPage\n\tper page: $perPage\n\ttotalPages: $totalPages\n\tcursor: $cursor\n\thasMore: $hasMore)';
}
