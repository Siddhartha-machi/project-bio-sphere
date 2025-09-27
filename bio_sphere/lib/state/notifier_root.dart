import 'package:isar/isar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bio_sphere/state/state_defs/core_config.dart';
import 'package:bio_sphere/data_source_catalog/db_manager.dart';
import 'package:bio_sphere/state/notifiers/config_notifier.dart';
import 'package:bio_sphere/data_source_catalog/data_sources_catalog.dart';
import 'package:bio_sphere/data_source_catalog/model_mapper_registry.dart';
import 'package:bio_sphere/state/notifiers/resource_registry_notifier.dart';

typedef ConfigProviderType = StateNotifierProvider<ConfigNotifier, CoreConfig>;

/// Centralized namespace for all Riverpod providers used across the app.
class Providers {
  static final config = ConfigProviderType((ref) {
    return ConfigNotifier(
      CoreConfig(
        dbManager: DbManager({}),
        catalog: DataSourceCatalog(ModelMapperRegistry()),
      ),
    );
  });

  /// Global registry provider
  /// Gives the ability to do CRUD operations on "a" data model
  static final resourceRegistryProvider = Provider<ResourceRegistryNotifier>((
    ref,
  ) {
    return ResourceRegistryNotifier(ref);
  });

  /// Global catalog provider (bootstrapped once on app load)
  static final dbProvider = Provider<Isar?>((ref) {
    return null;
  });
}
