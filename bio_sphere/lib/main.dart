import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/app.dart';
import 'package:bio_sphere/config/app_config.dart';
import 'package:bio_sphere/core/theme/core_theme_builder.dart';

void main() {
  /// TODO refactor
  final themeBuilder = CoreThemeBuilder(
    primary: Colors.green,
    brightness: Brightness.light,
  );

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          home: App(),
          title: AppConfig.name,
          theme: themeBuilder.buildTheme(),
        );
      },
    ),
  );
}
