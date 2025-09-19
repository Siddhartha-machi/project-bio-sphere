import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'package:bio_sphere/bootstrap/bootstrapper.dart';

class DbBootstrapper implements Bootstrapper {
  Isar? _isar;
  final List<CollectionSchema> _schemas = [];

  DbBootstrapper();

  /// Open Isar with core schemas.
  @override
  Future<bool> initAsync() async {
    if (_isar != null) return true;

    final dir = await getApplicationDocumentsDirectory();

    _schemas.addAll([]);

    _isar = await Isar.open(_schemas, directory: dir.path);

    return true;
  }

  /// Register new schemas (e.g. for extensions).
  /// Note: Isar does NOT allow opening the same DB twice with different schemas,
  /// so this should be called **before** any queries.
  Future<void> registerSchemas(List<CollectionSchema> newSchemas) async {
    if (_isar != null) {
      throw StateError(
        "Isar is already open. Register schemas before calling init().",
      );
    }

    _schemas.addAll(newSchemas);
  }

  /// Accessor for global instance
  Isar get instance {
    if (_isar == null) {
      throw StateError(
        "DbManager not initialized. Call DbManager.init() first.",
      );
    }

    return _isar!;
  }

  /// Close DB
  Future<void> close() async {
    await _isar?.close();

    _isar = null;

    _schemas.clear();
  }
}
