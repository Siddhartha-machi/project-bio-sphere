class Path {
  final String _root;
  final String _path;

  const Path(this._root, this._path);
  const Path.simple(this._root) : _path = '';

  /// Path relative to the parent, with dynamic parameters
  String get path => _normalizePath(_path.isEmpty ? _root : _path);

  /// Full path, e.g., for GoRouter's `path` property
  String get absolutePath => _normalizePath('$_root$_path');

  /// Builds a path with ID and query params injected
  static String _buildUrl(
    String path,
    Map<String, dynamic> idParams,
    Map<String, dynamic> queryParams,
  ) {
    final replacedPath = _replaceIds(path, idParams);
    return _appendQueryParams(replacedPath, queryParams);
  }

  /// Replace :id placeholders with actual values
  static String _replaceIds(String path, Map<String, dynamic> idParams) {
    idParams.forEach((key, value) {
      if (value != null && path.contains(':$key')) {
        path = path.replaceAll(':$key', Uri.encodeComponent(value.toString()));
      }
    });
    return path;
  }

  /// Append query parameters (?key=value)
  static String _appendQueryParams(String path, Map<String, dynamic> qParams) {
    final filtered = qParams.entries.where((e) => e.value != null).toList();

    if (filtered.isEmpty) return path;

    final queryString = filtered
        .expand((entry) {
          final key = Uri.encodeQueryComponent(entry.key);
          final value = entry.value;

          if (value is List) {
            return value.map(
              (v) => '$key=${Uri.encodeQueryComponent(v.toString())}',
            );
          } else {
            return ['$key=${Uri.encodeQueryComponent(value.toString())}'];
          }
        })
        .join('&');

    return path.contains('?') ? '$path&$queryString' : '$path?$queryString';
  }

  /// Utility to normalize paths (removes double slashes)
  static String _normalizePath(String path) =>
      path.replaceAll(RegExp(r'//+'), '/');

  /// ------------------ Public methods ------------------ ///
  /// Utility to parse query parameters from a full path
  static Map<String, String> parseQuery(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters;
  }

  /// Injects ID and query params into relative path
  String paramsInjectedPath(
    Map<String, dynamic> idParams, [
    Map<String, dynamic> qParams = const {},
  ]) {
    return _buildUrl(path, idParams, qParams);
  }

  /// Injects ID and query params into absolute path
  String paramsInjectedAbsolutePath(
    Map<String, dynamic> idParams, [
    Map<String, dynamic> qParams = const {},
  ]) {
    return _buildUrl(absolutePath, idParams, qParams);
  }
}
