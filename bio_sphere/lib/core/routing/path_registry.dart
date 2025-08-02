import 'package:bio_sphere/core/routing/path.dart';

class _AuthPathsRegistry {
  static const String _root = '/auth';

  const _AuthPathsRegistry();

  Path get root => const Path.simple(_root);
  Path get signIn => const Path(_root, '/signIn');

  Path get signUp => const Path(_root, '/signUp');
  Path get personalDetails => const Path(_root, '/personalDetails');
  Path get forgotPassword => const Path(_root, '/forgotPassword');
  Path get changePassword => const Path(_root, '/changePassword');

  bool isAuthRoute(String path) {
    return path == signIn.path ||
        path == signUp.path ||
        path == forgotPassword.path ||
        path == changePassword.path;
  }
}

class _CorePathsRegistry {
  const _CorePathsRegistry();

  Path get root => const Path.simple('/');
  Path get profile => const Path.simple('/profile');
  Path get settings => const Path.simple('/settings');
  Path get extensionList => const Path.simple('/extension-list');
  Path get extensionDetail => const Path('/extension-list', '/:id');
}

class ExtensionPath {
  final String _root, _path;

  const ExtensionPath(this._root, this._path);

  Path get root => Path(_root, _path);
  Path get stats => Path('$_root$_path', '/stats');
  Path get settings => Path('$_root$_path', '/settings');
  Path get detail => Path('$_root$_path', '/detail/:id');
  Path get addOrUpdate => Path('$_root$_path', '/add_or_update/:id');
}

class _ExtensionPathsRegistry {
  static const _root = '/your-space';

  const _ExtensionPathsRegistry();

  Path get root => const Path.simple(_root);
  ExtensionPath get todo => const ExtensionPath(_root, '/todo');
  ExtensionPath get eTracker => const ExtensionPath(_root, '/e-tracker');
  ExtensionPath get fTracker => const ExtensionPath(_root, '/f-tracker');
}

class _Debug {
  const _Debug();

  String get root => '/debug';
}

class PathRegistry {
  static const debug = _Debug();

  static const auth = _AuthPathsRegistry();
  static const core = _CorePathsRegistry();
  static const extension = _ExtensionPathsRegistry();
}
