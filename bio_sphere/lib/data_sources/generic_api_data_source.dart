import 'package:bio_sphere/constants/catalog_constants.dart';
import 'package:bio_sphere/services/external/api_service.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/models/interfaces/i_data_source.dart';
import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/services/service_utils/mappers/error_mapper.dart';
import 'package:bio_sphere/services/service_utils/mappers/pagination_mapper.dart';
import 'package:bio_sphere/models/service_models/data_service/service_response.dart';
import 'package:bio_sphere/models/service_models/data_service/service_request.dart';
import 'package:bio_sphere/models/service_models/external/backend_service_models.dart';

/// Concrete API Data Source that uses ApiService.
class GenericAPIDataSource<T extends IDataModel> implements IDataSource<T> {
  final String endPoint;
  final ApiService _service;
  final T Function(Map<String, dynamic> json) fromJson;

  GenericAPIDataSource(this.endPoint, this.fromJson)
    : _service = ApiService(endPoint);

  ServiceResponse _resolveRequest(BackendResponse response) {
    try {
      if (response.isSuccess) {
        dynamic transformedData;

        if (response.rawData == null) {
          /// Incase of delete, there would no data
          transformedData = null;
        } else if (response.rawData is List) {
          transformedData = (response.rawData as List<Map<String, dynamic>>)
              .map(fromJson)
              .toList();
        } else {
          transformedData = fromJson(response.rawData);
        }

        /// Transform backend data and pagination data to service response
        return ServiceResponse.success(
          transformedData,
          pagination: PaginationMapper.mapTo(Backend.api, response),
        );
      } else {
        return ServiceResponse.error(ErrorMapper.mapAPIError(response));
      }
    } catch (e) {
      return ServiceResponse.error(
        ServiceError(
          raw: e,
          code: AppErrorCodes.transformErr,
          message: 'Failed to transform data.',
        ),
      );
    }
  }

  @override
  Future<ServiceResponse<T>> getItem(ServiceRequest request) async {
    final response = await _service.request(path: request.item!.id);

    return _resolveRequest(response) as ServiceResponse<T>;
  }

  @override
  Future<ServiceResponse<List<T>>> getList(ServiceRequest request) async {
    /// TODO add other filters
    final response = await _service.request(queryParams: request.filters);

    return _resolveRequest(response) as ServiceResponse<List<T>>;
  }

  @override
  Future<ServiceResponse<T>> createItem(ServiceRequest request) async {
    final response = await _service.request(
      method: HttpMethod.post,
      data: request.item!.toJson,
    );

    return _resolveRequest(response) as ServiceResponse<T>;
  }

  @override
  Future<ServiceResponse<T>> updateItem(ServiceRequest request) async {
    final response = await _service.request(
      method: HttpMethod.put,
      data: request.item!.toJson,
    );

    return _resolveRequest(response) as ServiceResponse<T>;
  }

  @override
  Future<ServiceResponse<void>> deleteItem(ServiceRequest request) async {
    final response = await _service.request(
      method: HttpMethod.delete,
      path: '/${request.item!.id}',
    );

    return _resolveRequest(response);
  }
}
