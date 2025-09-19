import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/config/app_config.dart';
import 'package:bio_sphere/core/routing/app_routes.dart';
import 'package:bio_sphere/core/theme/core_theme_builder.dart';

void main() {
  /// TODO refactor
  final themeBuilder = CoreThemeBuilder(
    primary: Colors.blue,
    brightness: Brightness.light,
  );

  runApp(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            routerDelegate: appRoutes.routerDelegate,
            routeInformationParser: appRoutes.routeInformationParser,
            routeInformationProvider: appRoutes.routeInformationProvider,
            title: AppConfig.name,
            theme: themeBuilder.buildTheme(),
          );
        },
      ),
    ),
  );
}
