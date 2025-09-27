import 'package:bio_sphere/data_source_catalog/db_manager.dart';
import 'package:bio_sphere/data_source_catalog/data_sources_catalog.dart';

class CoreConfig {
  final DbManager dbManager;
  final DataSourceCatalog catalog;
  final Map<String, dynamic> featureFlags;

  CoreConfig({
    required this.catalog,
    required this.dbManager,
    this.featureFlags = const {},
  });

  CoreConfig copyWith({
    DbManager? dbManager,
    DataSourceCatalog? catalog,
    Map<String, dynamic>? featureFlags,
  }) {
    return CoreConfig(
      catalog: catalog ?? this.catalog,
      dbManager: dbManager ?? this.dbManager,
      featureFlags: featureFlags ?? this.featureFlags,
    );
  }
}
