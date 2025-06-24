import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class CoreThemeBuilder {
  final Color error;
  final MaterialColor primary;
  final Brightness brightness;

  CoreThemeBuilder({
    required this.primary,
    required this.brightness,
    this.error = Colors.redAccent,
  });

  TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      /// Body text styles
      bodyLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        decoration: TextDecoration.none,
      ),
      bodyMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.25,
        decoration: TextDecoration.none,
      ),
      bodySmall: TextStyle(
        color: colorScheme.onSurface.withAlpha(200),
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        decoration: TextDecoration.none,
      ),
      displayLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 96.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.5,
        decoration: TextDecoration.none,
      ),
      displayMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 60.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        decoration: TextDecoration.none,
      ),
      displaySmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 48.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        decoration: TextDecoration.none,
      ),
      headlineLarge: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 40.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.25,
        decoration: TextDecoration.none,
      ),
      headlineMedium: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 34.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.25,
        decoration: TextDecoration.none,
      ),
      headlineSmall: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        decoration: TextDecoration.none,
      ),

      /// Label styles
      labelLarge: TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.25,
        decoration: TextDecoration.none,
      ),
      labelMedium: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        decoration: TextDecoration.none,
      ),
      labelSmall: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
        decoration: TextDecoration.none,
      ),

      /// Title styles
      titleLarge: TextStyle(
        fontSize: 18.sp,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
        decoration: TextDecoration.none,
      ),
      titleMedium: TextStyle(
        fontSize: 16.sp,
        letterSpacing: 0.15,
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
        decoration: TextDecoration.none,
      ),
      titleSmall: TextStyle(
        fontSize: 14.sp,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
        decoration: TextDecoration.none,
      ),
    );
  }

  ThemeData buildTheme() {
    final colorScheme = ColorScheme.fromSwatch(
      errorColor: error,
      primarySwatch: primary,
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(colorScheme),
    );
  }
}
