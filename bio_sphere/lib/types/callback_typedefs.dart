import 'package:bio_sphere/models/interfaces/i_data_model.dart';

/// Mappers
typedef FromJson<T extends IDataModel> = T Function(Map<String, dynamic> json);
