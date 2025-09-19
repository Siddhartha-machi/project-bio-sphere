import 'package:bio_sphere/data_source_catalog/data_sources_catalog.dart';

class CoreConfig {
  final DataSourceCatalog catalog;
  final Map<String, dynamic> featureFlags;

  CoreConfig({required this.catalog, this.featureFlags = const {}});

  CoreConfig copyWith({
    DataSourceCatalog? catalog,
    Map<String, dynamic>? featureFlags,
  }) {
    return CoreConfig(
      catalog: catalog ?? this.catalog,
      featureFlags: featureFlags ?? this.featureFlags,
    );
  }
}
