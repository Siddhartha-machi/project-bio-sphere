import 'package:bio_sphere/models/service_models/data_service/service_response.dart';
import 'package:bio_sphere/models/service_models/external/backend_service_models.dart';

class ErrorMapper {
  static ServiceError mapAPIError(BackendResponse response) {
    final BackendError oErr = response.error!;

    return ServiceError(
      raw: oErr.raw,
      code: oErr.statusCode,
      message: oErr.message,
    );
  }
}
