import 'package:equatable/equatable.dart';

/// Base state for resources
class ResourceState<T> extends Equatable {
  final bool isLoading;
  final T? data;
  final List<T>? list;
  final String? error;

  const ResourceState({
    this.isLoading = false,
    this.data,
    this.list,
    this.error,
  });

  ResourceState<T> copyWith({
    T? data,
    String? error,
    List<T>? list,
    bool? isLoading,
  }) {
    return ResourceState<T>(
      error: error,
      list: list ?? this.list,
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [isLoading, data, list, error];
}
