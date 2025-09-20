import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bio_sphere/state/notifier_root.dart';
import 'package:bio_sphere/dev_utils/logging/app_logger.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/state/state_defs/resource_state.dart';
import 'package:bio_sphere/state/notifiers/resource_notifier.dart';

typedef ResourceProviderType<T extends IDataModel> =
    StateNotifierProvider<ResourceNotifier<T>, ResourceState<T>>;

class ResourceRegistryNotifier {
  final Ref ref;
  final Map<Type, ProviderBase> _registry = {};

  ResourceRegistryNotifier(this.ref);

  /// Register a new resource provider dynamically
  void _register<T extends IDataModel>() {
    if (_registry.containsKey(T)) return; // already registered

    final provider = ResourceProviderType<T>((ref) {
      final catalog = ref.read(Providers.config).catalog;
      final logger = AppLogger(tag: 'Resource<$T>:');

      return ResourceNotifier<T>(catalog: catalog, logger: logger);
    });

    _registry[T] = provider;
  }

  /// Access an existing provider
  ResourceProviderType<T> use<T extends IDataModel>() {
    assert(
      T != IDataModel,
      'Resource must be a model extended with IDataModel.',
    );

    var provider = _registry[T];

    if (provider == null) {
      _register<T>();
      provider = _registry[T];
    }

    return provider as ResourceProviderType<T>;
  }

  /// Remove a provider
  void unregister<T>() {
    _registry.remove(T);
  }

  /// Clear all (e.g. on logout)
  void clear() {
    _registry.clear();
  }
}


/// TODO : need to figure out a way to dispose old providers if they are not
/// in use for a long time. check lab