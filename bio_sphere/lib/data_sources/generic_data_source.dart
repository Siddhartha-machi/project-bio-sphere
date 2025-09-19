import 'package:bio_sphere/types/callback_typedefs.dart';
import 'package:bio_sphere/constants/catalog_constants.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/models/interfaces/i_data_source.dart';
import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/data_sources/generic_api_data_source.dart';
import 'package:bio_sphere/models/catalog_models/data_source_config.dart';
import 'package:bio_sphere/models/service_models/data_service/service_request.dart';
import 'package:bio_sphere/models/service_models/data_service/service_response.dart';

class GenericDataSource<T extends IDataModel> implements IDataSource<T> {
  final DataSourceConfig config;
  final List<Backend> backendOrder;
  final List<IDataSource<T>> _dataSources = [];

  GenericDataSource({required this.config, required this.backendOrder}) {
    _init();
  }

  void _init() {
    if (config.transformer == null) return;

    for (final backend in config.backends) {
      switch (backend) {
        case Backend.api:
          _dataSources.add(
            GenericAPIDataSource<T>(
              config.path,
              config.transformer as FromJson<T>,
            ),
          );
          break;
        default:
          throw Exception('Backend type not supported.');
      }
    }
  }

  Future<ServiceResponse<R>> _tryWithFallback<R>(
    Future<ServiceResponse<R>> Function(IDataSource<T>) runner,
  ) async {
    ServiceResponse<R>? response;

    for (final source in _dataSources) {
      response = await runner(source);

      /// Incorrect check, response will fail with invalid data too.
      /// That doesn't mean service failure. Needs fix.
      if (response.isSuccess) return response;
    }

    /// All DS failed, return the last source error
    if (response != null) return response;

    /// No data source
    return ServiceResponse.error(
      ServiceError(
        code: AppErrorCodes.data.codeErr,
        message: 'Failed to reach data services.',
      ),
    );
  }

  @override
  Future<ServiceResponse<T>> getItem(ServiceRequest request) async {
    final id = request.filters?['id'];

    if (id == null) throw Exception('No id provided to fetch item');

    return await _tryWithFallback((service) => service.getItem(request));
  }

  @override
  Future<ServiceResponse<List<T>>> getList(ServiceRequest request) async {
    return await _tryWithFallback((service) => service.getList(request));
  }

  @override
  Future<ServiceResponse<T>> createItem(ServiceRequest request) async {
    return await _tryWithFallback((service) => service.createItem(request));
  }

  @override
  Future<ServiceResponse<T>> updateItem(ServiceRequest request) async {
    return await _tryWithFallback((service) => service.updateItem(request));
  }

  @override
  Future<ServiceResponse<void>> deleteItem(ServiceRequest request) async {
    return await _tryWithFallback((service) => service.deleteItem(request));
  }
}
