import 'package:bio_sphere/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:go_router/go_router.dart';

import 'package:bio_sphere/core/routing/path_registry.dart';
import 'package:bio_sphere/core/routing/app_route_factory.dart';
import 'package:bio_sphere/shared/presentation/fallbacks/route_fallback.dart';

final GoRouter appRoutes = GoRouter(
  initialLocation: PathRegistry.core.root.absolutePath,
  debugLogDiagnostics: kDebugMode, // Enables debug logs for routing
  routes: [
    // Authentication Routes
    AppRouteFactory.groupedRoutes(
      root: PathRegistry.auth.root.path,
      rootBuilder: (context, state) => RouteFallback(state),
      nestedRoutes: [
        AppRouteFactory.simpleRoute(path: PathRegistry.auth.signIn.path),
        AppRouteFactory.simpleRoute(path: PathRegistry.auth.signUp.path),
        AppRouteFactory.simpleRoute(
          path: PathRegistry.auth.personalDetails.path,
        ),
        AppRouteFactory.simpleRoute(
          path: PathRegistry.auth.changePassword.path,
        ),
        AppRouteFactory.simpleRoute(
          path: PathRegistry.auth.forgotPassword.path,
        ),
      ],
    ),

    // Core routes
    AppRouteFactory.groupedRoutes(
      root: PathRegistry.core.root.path,
      rootBuilder: (context, state) => App(),
      nestedRoutes: [
        AppRouteFactory.simpleRoute(path: PathRegistry.core.root.path),
        // Extension info Routes
        AppRouteFactory.groupedRoutes(
          root: PathRegistry.core.extensionList.path,
          rootBuilder: (context, state) => RouteFallback(state),
          nestedRoutes: [
            AppRouteFactory.simpleRoute(
              path: PathRegistry.core.extensionDetail.path,
            ),
          ],
        ),

        AppRouteFactory.groupedRoutes(
          root: PathRegistry.extension.root.path,
          rootBuilder: (context, state) => RouteFallback(state),
          nestedRoutes: [
            /// Todo Extension
            AppRouteFactory.groupedRoutes(
              rootBuilder: (context, state) => RouteFallback(state),
              root: PathRegistry.extension.todo.root.path,
              nestedRoutes: [
                AppRouteFactory.simpleRoute(
                  path: PathRegistry.extension.todo.stats.path,
                ),
                AppRouteFactory.simpleRoute(
                  path: PathRegistry.extension.todo.settings.path,
                ),
                AppRouteFactory.parameterizedRoute(
                  path: PathRegistry.extension.todo.detail.path,
                  builder: (context, state) => RouteFallback(state),
                ),
                AppRouteFactory.parameterizedRoute(
                  path: PathRegistry.extension.todo.addOrUpdate.path,
                  builder: (context, state) => RouteFallback(state),
                ),
              ],
            ),
          ],
        ),

        AppRouteFactory.simpleRoute(path: PathRegistry.core.profile.path),

        AppRouteFactory.simpleRoute(path: PathRegistry.core.settings.path),
      ],
    ),

    // Error Route
    AppRouteFactory.errorRoute(
      path: '/error',
      builder: (ctx, state) =>
          Scaffold(body: Center(child: Text("Error: ${state.uri}"))),
    ),
  ],
);
