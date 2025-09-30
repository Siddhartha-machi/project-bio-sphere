import 'package:bio_sphere/types/callback_typedefs.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/models/interfaces/i_data_source.dart';
import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/services/external/i_external_service.dart';
import 'package:bio_sphere/services/service_utils/mappers/error_mapper.dart';
import 'package:bio_sphere/models/service_models/data_service/service_response.dart';
import 'package:bio_sphere/models/service_models/data_service/service_request.dart';
import 'package:bio_sphere/models/service_models/external/backend_service_models.dart';

/// Concrete Data Source that uses an external service.
class GenericDataSource<T extends IDataModel> implements IDataSource<T> {
  final FromJson<T> fromJson;
  final IExternalService<T> _service;

  const GenericDataSource(this._service, this.fromJson);

  ServiceResponse<R> _resolveRequest<R>(BackendResponse response) {
    try {
      if (response.isSuccess) {
        R? transformedData;

        if (response.rawData == null) {
          // In case of delete, there would be no data
          transformedData = null;
        } else if (response.rawData is List) {
          transformedData =
              (response.rawData as List)
                      .cast<Map<String, dynamic>>()
                      .map(fromJson)
                      .toList()
                  as R;
        } else {
          transformedData = fromJson(response.rawData) as R;
        }

        // Explicitly return typed ServiceResponse<R>
        return ServiceResponse<R>.success(
          transformedData as R,

          /// Disabled pagination
          // pagination: PaginationMapper.mapTo(Backend.api, response),
        );
      } else {
        return ServiceResponse<R>.error(ErrorMapper.mapAPIError(response));
      }
    } catch (e) {
      return ServiceResponse<R>.error(
        ServiceError(
          raw: e,
          code: AppErrorCodes.data.codeErr,
          message: 'Failed to transform data.',
        ),
      );
    }
  }

  @override
  Future<ServiceResponse<T>> getItem(ServiceRequest request) async {
    final id = request.filters!['id'];

    final response = await _service.request(path: '/$id');

    return _resolveRequest<T>(response);
  }

  @override
  Future<ServiceResponse<List<T>>> getList(ServiceRequest request) async {
    /// TODO add other filters
    final response = await _service.request(queryParams: request.filters);

    return _resolveRequest<List<T>>(response);
  }

  @override
  Future<ServiceResponse<T>> createItem(ServiceRequest request) async {
    final response = await _service.request(
      method: HttpMethod.post,
      data: request.item!.toJson(),
    );

    return _resolveRequest(response) as ServiceResponse<T>;
  }

  @override
  Future<ServiceResponse<T>> updateItem(ServiceRequest request) async {
    final response = await _service.request(
      method: HttpMethod.put,
      data: request.item!.toJson(),
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
