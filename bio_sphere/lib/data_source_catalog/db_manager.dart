import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DbManager {
  final _instances = <String, Isar>{};
  final Map<String, List<CollectionSchema>> moduleSchemas;

  DbManager(this.moduleSchemas);

  /// Open Isar with module schemas.
  Future<Isar> getModule(String moduleName) async {
    if (_instances.containsKey(moduleName)) return _instances[moduleName]!;

    final schemas = moduleSchemas[moduleName];

    if (schemas == null) {
      throw Exception("Module $moduleName not registered");
    }

    final dir = await getApplicationDocumentsDirectory();
    final isar = await Isar.open(
      schemas,
      name: moduleName,
      directory: dir.path,
    );

    _instances[moduleName] = isar;

    return isar;
  }

  /// Close DB
  Future<void> close(String moduleName) async {
    final instance = _instances.remove(moduleName);

    if (instance != null && instance.isOpen) {
      await instance.close();
    }
  }

  Future<void> closeAll() async {
    for (final instance in _instances.values) {
      if (instance.isOpen) await instance.close();
    }

    _instances.clear();
  }
}
