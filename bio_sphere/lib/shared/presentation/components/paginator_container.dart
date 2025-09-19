import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Generic pagination state
class PaginationState<T> {
  final bool hasMore;
  final List<T> items;
  final String? error;
  final bool isLoading;

  PaginationState({
    this.error,
    this.hasMore = true,
    required this.items,
    this.isLoading = false,
  });

  PaginationState<T> copyWith({
    String? error,
    bool? hasMore,
    List<T>? items,
    bool? isLoading,
  }) {
    return PaginationState<T>(
      error: error,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Pagination controller using Riverpod's StateNotifier
class PaginationController<T, F> extends StateNotifier<PaginationState<T>> {
  final Future<List<T>> Function(int page, int pageSize, F? filters) fetchPage;
  final int pageSize;

  int _currentPage = 0;
  F? _filters;

  PaginationController({required this.fetchPage, this.pageSize = 20})
    : super(PaginationState<T>(items: []));

  Future<void> loadNextPage() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await fetchPage(_currentPage, pageSize, _filters);

      state = state.copyWith(
        isLoading: false,
        items: [...state.items, ...items],
        hasMore: items.length == pageSize,
      );

      if (items.isNotEmpty) _currentPage++;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void refresh() {
    _currentPage = 0;
    state = PaginationState<T>(items: []);
    loadNextPage();
  }

  void updateFilters(F filters) {
    _filters = filters;
    refresh();
  }
}

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class PaginatedListView<T> extends ConsumerWidget {
  final AutoDisposeStateNotifierProvider<
    PaginationController<T, dynamic>,
    PaginationState<T>
  >
  provider;
  final ItemWidgetBuilder<T> itemBuilder;

  const PaginatedListView({
    super.key,
    required this.provider,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final controller = ref.read(provider.notifier);

    if (state.items.isEmpty && state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.items.isEmpty) {
      return Center(child: Text("Error: ${state.error}"));
    }

    return RefreshIndicator(
      onRefresh: () async => controller.refresh(),
      child: ListView.builder(
        itemCount: state.items.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.items.length) {
            controller.loadNextPage();
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return itemBuilder(context, state.items[index]);
        },
      ),
    );
  }
}
