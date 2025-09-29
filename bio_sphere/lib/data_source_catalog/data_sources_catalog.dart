import 'package:bio_sphere/constants/catalog_constants.dart';
import 'package:bio_sphere/services/external/api_service.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/data_sources/generic_data_source_manager.dart';
import 'package:bio_sphere/models/catalog_models/data_source_config.dart';
import 'package:bio_sphere/data_source_catalog/model_mapper_registry.dart';

class DataSourceCatalog {
  bool _isInitialized = false;
  final List<Backend> backendOrder;
  final ModelMapperRegistry mapperRegistry;
  final Map<String, DataSourceConfig> _configCatalog = {};
  final Map<String, GenericDataSourceManager> _dataSourceCache = {};

  DataSourceCatalog(
    this.mapperRegistry, {
    this.backendOrder = const [Backend.api],
  });

  /// Makes a API request to catalog service to get all working services list
  Future<List<dynamic>> _fetchCatalogData() async {
    List<dynamic> catalogData = [];
    final apiClient = ApiService('/catalog');

    try {
      final result = await apiClient.request();

      if (result.isSuccess) catalogData = result.rawData;
    } catch (e) {
      /// TODO : It's better to keep error object and custom error
      /// Consider using a custom exception class
      throw Exception('Failed to fetch data source catalog');
    }

    return catalogData;
  }

  /// Transforms raw json into DataSourceConfig objects
  _buildConfigCatalog(List<dynamic> json) {
    for (final item in json) {
      final config = DataSourceConfig.fromJson(item);
      final transformer = mapperRegistry.getFactory(config.id);

      _configCatalog[config.id] = config.copyWith(transformer);
    }
  }

  Future<void> _initAsync() async {
    if (_isInitialized) return;

    /// Make an API call to catalog service to get available services
    /// so we can fallback to other backends if any service is unavailable.
    final rawConfig = await _fetchCatalogData();

    /// Builds the catalog with
    _buildConfigCatalog(rawConfig);

    _isInitialized = true;
  }

  /// Public methods
  Future<GenericDataSourceManager<T>?>
  getService<T extends IDataModel>() async {
    final id = T.toString();

    if (!_isInitialized) await _initAsync();

    var oDataSrc = _dataSourceCache[id] as GenericDataSourceManager<T>?;

    /// Cache miss
    if (oDataSrc == null) {
      final config = _configCatalog[id];

      /// Update cache
      if (config != null) {
        oDataSrc = GenericDataSourceManager(config: config);

        _dataSourceCache[id] = oDataSrc;
      }
    }

    return oDataSrc;
  }

  /// Public Utils
  DataSourceCatalog copyWith(List<Backend> backendOrder) {
    return DataSourceCatalog(mapperRegistry, backendOrder: backendOrder);
  }
}
