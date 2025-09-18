import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bio_sphere/state/state_defs/core_config.dart';
import 'package:bio_sphere/dev_utils/logging/app_logger.dart';
import 'package:bio_sphere/state/notifiers/config_notifier.dart';
import 'package:bio_sphere/data_source_catalog/model_mapper_registry.dart';
import 'package:bio_sphere/state/notifiers/resource_registry_notifier.dart';

typedef ConfigProviderType = StateNotifierProvider<ConfigNotifier, CoreConfig>;

/// Centralized namespace for all Riverpod providers used across the app.
class Providers {
  static final config = ConfigProviderType((ref) {
    final mapperRegistry = ModelMapperRegistry();
    final logger = AppLogger(tag: 'Config Provider');

    return ConfigNotifier(mapperRegistry, logger);
  });

  /// Global registry provider
  /// Gives the ability to do CRUD operations on "a" data model
  static final resourceRegistryProvider = Provider<ResourceRegistryNotifier>((
    ref,
  ) {
    return ResourceRegistryNotifier(ref);
  });
}
