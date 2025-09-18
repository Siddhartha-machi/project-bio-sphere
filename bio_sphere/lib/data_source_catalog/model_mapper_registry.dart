import 'package:bio_sphere/types/callback_typedefs.dart';
import 'package:bio_sphere/models/interfaces/i_data_model.dart';

class ModelMapperRegistry {
  final Map<String, FromJson<IDataModel>> _factories = {};

  ModelMapperRegistry();

  // Registers a factory for both type and name
  void register<T extends IDataModel>(FromJson<T> factory) {
    final key = T.toString();

    _factories[key] = factory;
  }

  // Gets a factory by type
  FromJson<T>? getFactory<T extends IDataModel>([String? key]) {
    final effKey = key ?? T.toString();

    final fn = _factories[effKey];

    return fn == null ? null : fn as FromJson<T>;
  }
}
