import 'package:isar/isar.dart';

import 'package:bio_sphere/models/interfaces/i_data_model.dart';
import 'package:bio_sphere/models/service_models/external/backend_service_models.dart';

/// Generic DB service that behaves like ApiService but for local storage.
class DBService<T extends IDataModel> {
  final Isar _isar;

  const DBService(this._isar);

  IsarCollection<T> get _collection => _isar.collection<T>();

  /// Create or update item
  Future<BackendResponse<T>> createItem(T item) async {
    try {
      await _isar.writeTxn(() async {
        await _collection.put(item);
      });

      return BackendResponse.success(item);
    } catch (e) {
      return BackendResponse.error(
        BackendError(code: 'DB_WRITE_FAILED', message: e.toString(), raw: e),
      );
    }
  }

  /// Get item by ID
  Future<BackendResponse<T?>> getItem(Id id) async {
    try {
      final result = await _collection.get(id);

      return BackendResponse.success(result);
    } catch (e) {
      return BackendResponse.error(
        BackendError(code: 'DB_READ_FAILED', message: e.toString(), raw: e),
      );
    }
  }

  /// Get list with optional filters
  Future<BackendResponse<List<T>>> getList({
    Future<List<T>> Function(IsarCollection<T> col)? filter,
  }) async {
    /// TODO apply filters
    try {
      List<T> results;
      if (filter != null) {
        results = await filter(_collection);
      } else {
        results = await _collection.where().findAll();
      }
      return BackendResponse.success(results);
    } catch (e) {
      return BackendResponse.error(
        BackendError(code: 'DB_QUERY_FAILED', message: e.toString(), raw: e),
      );
    }
  }

  /// Delete item by ID
  Future<BackendResponse<void>> deleteItem(Id id) async {
    try {
      await _isar.writeTxn(() async {
        await _collection.delete(id);
      });
      return BackendResponse.success(null);
    } catch (e) {
      return BackendResponse.error(
        BackendError(code: 'DB_DELETE_FAILED', message: e.toString(), raw: e),
      );
    }
  }

  /// Clear all items in the collection
  Future<BackendResponse<void>> clear() async {
    try {
      await _isar.writeTxn(() async {
        await _collection.clear();
      });
      return BackendResponse.success(null);
    } catch (e) {
      return BackendResponse.error(
        BackendError(code: 'DB_CLEAR_FAILED', message: e.toString(), raw: e),
      );
    }
  }
}
