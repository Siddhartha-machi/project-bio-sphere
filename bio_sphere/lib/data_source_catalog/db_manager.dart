import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DbManager {
  static Isar? _isar;
  static final List<CollectionSchema> _schemas = [];

  /// Open Isar with core schemas.
  static Future<void> init({
    List<CollectionSchema> coreSchemas = const [],
  }) async {
    if (_isar != null) return; // already initialized

    final dir = await getApplicationDocumentsDirectory();

    _schemas.addAll(coreSchemas);

    _isar = await Isar.open(_schemas, directory: dir.path);
  }

  /// Register new schemas (e.g. for extensions).
  /// Note: Isar does NOT allow opening the same DB twice with different schemas,
  /// so this should be called **before** any queries.
  static Future<void> registerSchemas(List<CollectionSchema> newSchemas) async {
    if (_isar != null) {
      throw StateError(
        "Isar is already open. Register schemas before calling init().",
      );
    }
    _schemas.addAll(newSchemas);
  }

  /// Accessor for global instance
  static Isar get instance {
    if (_isar == null) {
      throw StateError(
        "DbManager not initialized. Call DbManager.init() first.",
      );
    }
    return _isar!;
  }

  /// Close DB
  static Future<void> close() async {
    await _isar?.close();

    _isar = null;

    _schemas.clear();
  }
}
