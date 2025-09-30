import 'package:bio_sphere/constants/api_service_constants.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/models/service_models/external/backend_service_models.dart';

abstract class IExternalService<T extends IDataModel> {
  const IExternalService();

  Future<BackendResponse> request({
    String path = '',
    Map<String, dynamic>? data,
    String method = HttpMethod.get,
    Map<String, dynamic>? queryParams,
  });
}
