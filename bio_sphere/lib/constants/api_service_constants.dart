class HttpMethod {
  static const String get = 'GET';
  static const String post = 'POST';
  static const String put = 'PUT';
  static const String delete = 'DELETE';
}

class SecureStorageConfig {
  static const tokenKey = 'access_token';
  static const refreshKey = 'refresh_token';
}

class AppProviders {
  static const prerequisites = 'prerequisites';
  static const bloc = 'bloc';
}

/// App error codes

class _UIErrorCodes {
  int get codeErr => 90000;

  const _UIErrorCodes();
}

class _StateErrorCodes {
  int get codeErr => 80000;

  const _StateErrorCodes();
}

class _DataErrorCodes {
  int get codeErr => 70000;

  const _DataErrorCodes();
}

class _BackendErrorCodes {
  int get codeErr => 60000;

  const _BackendErrorCodes();
}

class AppErrorCodes {
  static const ui = _UIErrorCodes();
  static const data = _DataErrorCodes();
  static const state = _StateErrorCodes();
  static const backend = _BackendErrorCodes();
}
