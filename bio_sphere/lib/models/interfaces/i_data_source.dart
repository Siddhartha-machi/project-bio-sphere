import 'package:bio_sphere/models/service_models/data_service/service_request.dart';
import 'package:bio_sphere/models/service_models/data_service/service_response.dart';

abstract class IDataSource<T> {
  Future<ServiceResponse<T>> getItem(ServiceRequest request);
  Future<ServiceResponse<List<T>>> getList(ServiceRequest request);
  Future<ServiceResponse<T>> createItem(ServiceRequest request);
  Future<ServiceResponse<T>> updateItem(ServiceRequest request);
  Future<ServiceResponse<void>> deleteItem(ServiceRequest request);
}
