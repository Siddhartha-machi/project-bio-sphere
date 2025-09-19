import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:bio_sphere/dev_utils/logging/app_logger.dart';
import 'package:bio_sphere/dev_utils/logging/logger_manager.dart';
import 'package:bio_sphere/shared/presentation/fallbacks/route_fallback.dart';

class AppRouteFactory {
  static AppLogger _getLogger() {
    return LoggerManager.createLogger('App Navigation');
  }

  /// Default fallback screen when no route is found
  static Widget _fallbackBuilder(BuildContext ctx, GoRouterState state) {
    _getLogger().warning(
      'Fallback triggered for path: ${state.uri.toString()}',
    );
    return RouteFallback(state);
  }

  /// Default redirect (returns `null` for no redirection)
  static String? _defaultRedirect(BuildContext ctx, GoRouterState state) {
    _getLogger().info('Checking redirect for: ${state.uri.toString()}');
    return null;
  }

  /// Helper function to build routes requiring an ID
  static GoRoute parameterizedRoute({
    required String path,
    required Widget Function(String, GoRouterState) builder,
    String? Function(BuildContext, GoRouterState)? redirect,
  }) {
    return GoRoute(
      path: path,
      redirect: redirect,
      builder: (context, state) {
        final String? id = state.pathParameters['id'];
        if (id == null || id.isEmpty) {
          _getLogger().error('Invalid or missing ID for route: $path');
          return _fallbackBuilder(context, state);
        }
        return builder(id, state);
      },
    );
  }

  /// Creates a simple route
  static GoRoute simpleRoute({
    required String path,
    Widget Function(BuildContext, GoRouterState)? builder,
    String? Function(BuildContext, GoRouterState)? redirect,
  }) {
    return GoRoute(
      path: path,
      redirect: redirect ?? _defaultRedirect,
      builder: builder ?? _fallbackBuilder,
    );
  }

  /// Creates a grouped route
  static RouteBase groupedRoutes({
    required String root,
    required List<RouteBase> nestedRoutes,
    required Widget Function(BuildContext, GoRouterState) rootBuilder,
  }) {
    return GoRoute(path: root, builder: rootBuilder, routes: nestedRoutes);
  }

  /// Error route to handle unknown paths
  static GoRoute errorRoute({
    required String path,
    Widget Function(BuildContext, GoRouterState)? builder,
  }) => GoRoute(path: path, builder: builder ?? _fallbackBuilder);
}
