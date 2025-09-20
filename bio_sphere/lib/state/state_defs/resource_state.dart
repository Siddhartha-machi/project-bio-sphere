import 'package:equatable/equatable.dart';

/// Base state for resources
class ResourceState<T> extends Equatable {
  final bool isLoading;
  final T? data;
  final List<T>? list;
  final String? error;
  final DateTime? timestamp;
  final int staleAfter;

  const ResourceState({
    this.isLoading = false,
    this.data,
    this.list,
    this.error,
    this.timestamp,
    this.staleAfter = 0,
  });

  ResourceState<T> copyWith({
    T? data,
    String? error,
    List<T>? list,
    bool? isLoading,
  }) {
    DateTime? timestamp;

    if (data == null || list != null) {
      timestamp = DateTime.now();
    }
    return ResourceState<T>(
      error: error,
      timestamp: timestamp,
      list: list ?? this.list,
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [isLoading, data, list, error];

  bool isStale() {
    // We haven't updated timestamp once, i.e. data not loaded once
    if (timestamp == null) return true;

    // Check if last fetch was more than N minutes ago
    final now = DateTime.now();
    return now.difference(timestamp!).inMinutes > staleAfter;
  }
}
