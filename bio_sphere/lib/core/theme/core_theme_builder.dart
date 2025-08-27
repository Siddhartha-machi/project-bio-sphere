import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/core/theme/color_schema_builder.dart';

class CoreThemeBuilder {
  final Color error;
  final Color primary;
  final Brightness brightness;

  CoreThemeBuilder({
    required this.primary,
    required this.brightness,
    this.error = Colors.redAccent,
  });

  static _borderRadius() => 0.sp;

  TextTheme _buildTextTheme(ColorScheme colorScheme) {
    return TextTheme(
      /// Main content text (body)
      bodyLarge: GoogleFonts.sofiaSans(
        color: colorScheme.onSurface,
        fontSize: 19.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
        decoration: TextDecoration.none,
        height: 1.6,
      ),

      /// Secondary body text (subtext, details)
      bodyMedium: GoogleFonts.sofiaSans(
        color: colorScheme.onSurface.withAlpha(230),
        fontSize: 17.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.05,
        decoration: TextDecoration.none,
        height: 1.5,
      ),

      /// Caption, helper, or hint text
      bodySmall: GoogleFonts.sofiaSans(
        color: colorScheme.onSurface.withAlpha(180),
        fontSize: 14.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
        decoration: TextDecoration.none,
        height: 1.3,
      ),

      /// Large display (splash, hero, onboarding)
      displayLarge: GoogleFonts.sofiaSans(
        color: colorScheme.onSurface,
        fontSize: 44.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -1,
        decoration: TextDecoration.none,
        shadows: [
          Shadow(
            color: colorScheme.onSurface.withAlpha(30),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        height: 1.15,
      ),

      /// Page title
      displayMedium: GoogleFonts.sofiaSans(
        color: colorScheme.onSurface,
        fontSize: 32.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
        decoration: TextDecoration.none,
        height: 1.2,
      ),

      /// Section heading
      displaySmall: GoogleFonts.sofiaSans(
        color: colorScheme.onSurface,
        fontSize: 25.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
        decoration: TextDecoration.none,
        height: 1.2,
      ),

      /// Card title, section header
      headlineLarge: GoogleFonts.sofiaSans(
        color: colorScheme.primary,
        fontSize: 20.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.1,
        decoration: TextDecoration.none,
        height: 1.25,
      ),

      /// Section header
      headlineMedium: GoogleFonts.sofiaSans(
        color: colorScheme.onSurface,
        fontSize: 18.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.05,
        decoration: TextDecoration.none,
        height: 1.2,
      ),

      /// Subsection header
      headlineSmall: GoogleFonts.sofiaSans(
        color: colorScheme.onSurface,
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0,
        decoration: TextDecoration.none,
        height: 1.2,
      ),

      /// Button text
      labelLarge: GoogleFonts.sofiaSans(
        fontSize: 16.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.05,
        decoration: TextDecoration.none,
        color: colorScheme.onSurface,
        height: 1.1,
        textBaseline: TextBaseline.alphabetic,
      ),

      /// Input label
      labelMedium: GoogleFonts.sofiaSans(
        fontSize: 14.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.02,
        decoration: TextDecoration.none,
        color: colorScheme.onSurface,
        height: 1.1,
      ),

      /// Helper label
      labelSmall: GoogleFonts.sofiaSans(
        fontSize: 12.sp,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.3,
        decoration: TextDecoration.none,
        color: colorScheme.onSurface.withAlpha(180),
        height: 1.1,
      ),

      /// App bar title
      titleLarge: GoogleFonts.sofiaSans(
        fontSize: 20.sp,
        letterSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
        decoration: TextDecoration.none,
        height: 1.2,
      ),

      /// Dialog title
      titleMedium: GoogleFonts.sofiaSans(
        fontSize: 18.sp,
        letterSpacing: 0.05,
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
        decoration: TextDecoration.none,
        height: 1.2,
      ),

      /// Modal title
      titleSmall: GoogleFonts.sofiaSans(
        fontSize: 16.sp,
        letterSpacing: 0.02,
        fontWeight: FontWeight.w800,
        color: colorScheme.onSurface,
        decoration: TextDecoration.none,
        height: 1.2,
      ),
    );
  }

  InputDecorationTheme _buildInputDecoration(
    ColorScheme scheme,
    TextTheme txtTheme,
  ) {
    final borderRadius = BorderRadius.circular(_borderRadius());
    return InputDecorationTheme(
      filled: true,
      errorStyle: txtTheme.labelSmall!.copyWith(color: scheme.error),
      border: OutlineInputBorder(borderRadius: borderRadius),

      hintStyle: txtTheme.labelSmall?.copyWith(
        color: scheme.onSurface.withAlpha(150),
      ),

      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: scheme.error, width: 1.5),
        borderRadius: borderRadius,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey, width: 1),
        borderRadius: borderRadius,
      ),
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 8.sp),
    );
  }

  ThemeData buildTheme() {
    final borderRadius = _borderRadius();

    final colorScheme = ColorSchemaBuilder.fromSeed(
      errorColor: error,
      seedColor: primary,
      brightness: brightness,
    );

    final txtTheme = _buildTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      textTheme: txtTheme,
      colorScheme: colorScheme,
      inputDecorationTheme: _buildInputDecoration(colorScheme, txtTheme),

      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius * 1.5),
        ),
        margin: const EdgeInsets.all(0),
      ),

      /// Ripple styles
      splashColor: colorScheme.primary.withAlpha(25),
      highlightColor: colorScheme.primary.withAlpha(25),

      /// Button styles
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
