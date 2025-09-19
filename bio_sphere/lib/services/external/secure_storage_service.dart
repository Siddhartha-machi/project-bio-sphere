import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:bio_sphere/dev_utils/logging/app_logger.dart';

/// A secure storage wrapper that adds prefixing, logging, and
/// convenience methods for managing sensitive key-value pairs.
class SecureStorageService {
  /// Underlying secure storage instance with platform-specific options
  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Optional prefix for namespacing stored keys.
  /// Defaults to [_defaultPrefix] if not provided.
  final String prefix;

  /// Logger instance for storage operations
  final _logger = AppLogger(tag: 'SecureStorage');

  /// Default prefix for keys if none is provided
  static const String _defaultPrefix = 'SStorage';

  SecureStorageService({this.prefix = ''});

  /// Get effective prefix key (falls back to [_defaultPrefix] if empty).
  String get _prefixKey => prefix.isEmpty ? _defaultPrefix : prefix;

  /// Internal helper to add prefix to keys.
  String _withPrefix(String key) => '${_prefixKey}_$key';

  /// Writes a value to secure storage.
  Future<void> write(String key, String value) async {
    final fullKey = _withPrefix(key);
    try {
      await _storage.write(key: fullKey, value: value);
      _logger.info('Written value for key: $fullKey');
    } catch (e) {
      _logger.error('Failed to write key: $fullKey');
      rethrow;
    }
  }

  /// Reads a value from secure storage.
  Future<String?> read(String key) async {
    final fullKey = _withPrefix(key);
    try {
      final value = await _storage.read(key: fullKey);
      _logger.info('Read key: $fullKey (exists: ${value != null})');
      return value;
    } catch (e) {
      _logger.error('Failed to read key: $fullKey');
      rethrow;
    }
  }

  /// Deletes a value from secure storage.
  Future<void> delete(String key) async {
    final fullKey = _withPrefix(key);
    try {
      await _storage.delete(key: fullKey);
      _logger.info('Deleted key: $fullKey');
    } catch (e) {
      _logger.error('Failed to delete key: $fullKey');
      rethrow;
    }
  }

  /// Deletes multiple keys at once.
  Future<void> deleteMultiple(List<String> keys) async {
    for (final key in keys) {
      await delete(key);
    }
  }

  /// Deletes all keys in secure storage (⚠️ clears everything).
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
      _logger.warning('Deleted ALL keys from storage!');
    } catch (e) {
      _logger.error('Failed to delete all keys');
      rethrow;
    }
  }

  /// Checks if a key exists in secure storage.
  Future<bool> containsKey(String key) async {
    final fullKey = _withPrefix(key);
    try {
      final exists = await _storage.containsKey(key: fullKey);
      _logger.info('Key exists [$fullKey]: $exists');
      return exists;
    } catch (e) {
      _logger.error('Failed to check existence of key: $fullKey');
      rethrow;
    }
  }
}
