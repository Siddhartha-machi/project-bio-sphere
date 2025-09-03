/* 
|------------------------------|
  ServiceRequest
    - Holds request data util data layer
    - stores data to save, update, delete and other pagination meta data
|------------------------------|
*/

import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/models/service_models/pagination_context.dart';

class ServiceRequest<T extends IDataModel> {
  /// The primary data item being sent (for create/update/delete).
  final T? item;

  /// A collection of data items (e.g., bulk create or batch update).
  final List<T>? items;

  /// Pagination information for list-type requests.
  final PaginationContext? pagination;

  /// Filtering or search parameters.
  final Map<String, dynamic>? filters;

  /// Additional request options (like `forceRefresh`, `includeRelations`, etc.).
  final Map<String, dynamic>? options;

  const ServiceRequest({
    this.item,
    this.items,
    this.filters,
    this.options,
    this.pagination,
  });

  /// Creates a copy with updated fields.
  ServiceRequest<T> copyWith({
    T? item,
    List<T>? items,
    PaginationContext? pagination,
    Map<String, dynamic>? filters,
    Map<String, dynamic>? options,
  }) {
    return ServiceRequest<T>(
      item: item ?? this.item,
      items: items ?? this.items,
      options: options ?? this.options,
      filters: filters ?? this.filters,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  String toString() {
    return 'ServiceRequest(item: $item, items: $items, '
        'pagination: $pagination, filters: $filters, options: $options)';
  }
}
