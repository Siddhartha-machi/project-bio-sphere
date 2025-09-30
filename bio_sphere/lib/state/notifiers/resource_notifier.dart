import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bio_sphere/dev_utils/logging/app_logger.dart';
import 'package:bio_sphere/state/state_defs/core_config.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/state/state_defs/resource_state.dart';
import 'package:bio_sphere/data_sources/generic_data_source_manager.dart';
import 'package:bio_sphere/models/service_models/data_service/service_request.dart';

typedef _BaseNotifier<T> = StateNotifier<ResourceState<T>>;

/// --- Resource Notifier ---
/// TODO 1 : handle concurrent calls.
class ResourceNotifier<T extends IDataModel> extends _BaseNotifier<T> {
  final AppLogger logger;
  final CoreConfig config;

  ResourceNotifier({required this.config, required this.logger})
    : super(ResourceState<T>());

  /// Helper to resolve a service
  Future<GenericDataSourceManager<T>> _tryGetService() async {
    if (!await config.nConnect.isOnline()) {
      throw Exception('No internet connection!');
    }

    final service = await config.catalog.getService<T>();

    if (service == null) {
      throw Exception('Service could not be loaded.');
    }

    return service;
  }

  /// --- CRUD METHODS ---
  Future<void> fetchById(String id, {bool force = false}) async {
    /// Only fetch if no cached item
    if (!force && state.data?.id == id && !state.isStale()) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = await _tryGetService();

      final response = await service.getItem(
        ServiceRequest<T>(filters: {'id': id}),
      );

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(data: response.data, isLoading: false);
      } else {
        state = state.copyWith(
          error: response.error?.message ?? "Failed to fetch item",
          isLoading: false,
        );
      }
    } catch (e, st) {
      _logError("fetchById", e, st);
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> fetchList([ServiceRequest? request, bool force = false]) async {
    /// Only fetch if no cached list
    if (!force && (state.list?.isNotEmpty ?? false) && !state.isStale()) return;

    state = state.copyWith(isLoading: true, error: null);
    try {
      final service = await _tryGetService();

      final response = await service.getList(request ?? ServiceRequest());

      if (response.isSuccess && response.data != null) {
        state = state.copyWith(list: response.data, isLoading: false);
      } else {
        state = state.copyWith(
          error: response.error?.message ?? "Failed to fetch list",
          isLoading: false,
        );
      }
    } catch (e, st) {
      _logError("fetchList", e, st);
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> createItem(T item) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = await _tryGetService();

      final response = await service.createItem(ServiceRequest(item: item));

      if (response.isSuccess && response.data != null) {
        final updatedList = [...?state.list, response.data!];
        state = state.copyWith(
          data: response.data,
          list: updatedList,
          isLoading: false,
        );
      } else {
        state = state.copyWith(
          error: response.error?.message ?? "Failed to create item",
          isLoading: false,
        );
      }
    } catch (e, st) {
      _logError("createItem", e, st);
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateItem(String id, T item) async {
    final prev = state.data;

    // Optimistic update
    state = state.copyWith(data: item, error: null);

    try {
      final service = await _tryGetService();

      final response = await service.updateItem(ServiceRequest(item: item));

      if (!response.isSuccess) {
        // rollback
        state = state.copyWith(
          data: prev,
          error: response.error?.message ?? "Update failed",
        );
      }
    } catch (e, st) {
      _logError("updateItem", e, st);
      state = state.copyWith(data: prev, error: e.toString());
    }
  }

  Future<void> deleteItem(T item) async {
    final prevList = state.list;

    // Optimistic remove
    state = state.copyWith(
      error: null,
      list: state.list?.where((e) => e.id != item.id).toList(),
    );

    try {
      final service = await _tryGetService();

      final response = await service.deleteItem(ServiceRequest(item: item));

      if (!response.isSuccess) {
        // rollback
        state = state.copyWith(
          list: prevList,
          error: response.error?.message ?? "Delete failed",
        );
      }
    } catch (e, st) {
      _logError("deleteItem", e, st);
      state = state.copyWith(list: prevList, error: e.toString());
    }
  }

  /// --- Error Logger ---
  void _logError(String action, Object e, StackTrace st) {
    logger.error("ResourceNotifier<$T>.$action error", e, st);
  }
}
