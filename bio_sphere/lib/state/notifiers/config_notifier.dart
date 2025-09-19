import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:bio_sphere/dev_utils/logging/app_logger.dart';
import 'package:bio_sphere/state/state_defs/core_config.dart';
import 'package:bio_sphere/data_source_catalog/data_sources_catalog.dart';
import 'package:bio_sphere/data_source_catalog/model_mapper_registry.dart';

class ConfigNotifier extends StateNotifier<CoreConfig> {
  final AppLogger _logger;

  ConfigNotifier(ModelMapperRegistry registry, this._logger)
    : super(CoreConfig(catalog: DataSourceCatalog(registry))) {
    _logger.info('ConfigNotifier created');
  }

  /// Register a mapper (can be done anytime, even after init).
  void updateMapperRegistry(Function(ModelMapperRegistry) updateFn) {
    _logger.debug('Registering mapper...');
    updateFn(state.catalog.mapperRegistry);
  }

  /// Update feature flags without touching catalog.
  void updateFeatureFlags(Map<String, dynamic> flags) {
    _logger.debug('Updating feature flags: $flags');
    state = state.copyWith(featureFlags: {...state.featureFlags, ...flags});
  }

  /// Replace catalog (rarely needed, but possible).
  void replaceCatalog(DataSourceCatalog newCatalog) {
    _logger.warning('Replacing catalog with new instance');
    state = state.copyWith(catalog: newCatalog);
  }
}
