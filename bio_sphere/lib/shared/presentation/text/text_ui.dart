import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';

/// A hybrid text widget that uses the app theme and allows custom overrides.
class TextUI extends StatelessWidget {
  /// The text to display.
  final String text;

  /// The color override.
  final Color? color;

  /// The text alignment.
  final TextAlign align;

  /// The text level (uses theme).
  final TextLevel? level;

  /// Font size override (in logical pixels, will be scaled).
  final double? fontSize;

  /// Font weight override.
  final FontWeight? fontWeight;

  /// Font style override (e.g., italic).
  final FontStyle? fontStyle;

  /// Letter spacing override.
  final double? letterSpacing;

  /// Line height override.
  final double? height;

  /// Maximum number of lines.
  final int? maxLines;

  /// Overflow behavior.
  final TextOverflow? overflow;

  const TextUI(
    this.text, {
    super.key,
    this.color,
    this.level,
    this.height,
    this.maxLines,
    this.overflow,
    this.fontSize,
    this.fontStyle,
    this.fontWeight,
    this.letterSpacing,
    this.align = TextAlign.start,
  });

  TextStyle? _getTextStyle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    switch (level) {
      case TextLevel.displayLarge:
        return textTheme.displayLarge;
      case TextLevel.displayMedium:
        return textTheme.displayMedium;
      case TextLevel.displaySmall:
        return textTheme.displaySmall;
      case TextLevel.headlineLarge:
        return textTheme.headlineLarge;
      case TextLevel.headlineMedium:
        return textTheme.headlineMedium;
      case TextLevel.headlineSmall:
        return textTheme.headlineSmall;
      case TextLevel.titleLarge:
        return textTheme.titleLarge;
      case TextLevel.titleMedium:
        return textTheme.titleMedium;
      case TextLevel.titleSmall:
        return textTheme.titleSmall;
      case TextLevel.bodyLarge:
        return textTheme.bodyLarge;
      case TextLevel.bodyMedium:
        return textTheme.bodyMedium;
      case TextLevel.bodySmall:
        return textTheme.bodySmall;
      case TextLevel.labelLarge:
        return textTheme.labelLarge;
      case TextLevel.labelMedium:
        return textTheme.labelMedium;
      case TextLevel.labelSmall:
        return textTheme.labelSmall;
      case TextLevel.caption:
        return textTheme.bodySmall?.copyWith(fontSize: 10.0.sp);
      default:
        return textTheme.bodyMedium;
    }
  }

  TextStyle _addStyleOverrides(TextStyle? baseStyles) {
    return (baseStyles ?? const TextStyle()).copyWith(
      color: color,
      height: height,
      fontStyle: fontStyle,
      fontSize: fontSize?.sp,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseStyles = _getTextStyle(context);
    final overridenStyles = _addStyleOverrides(baseStyles);

    return Text(
      text,
      softWrap: true,
      textAlign: align,
      maxLines: maxLines,
      overflow: overflow,
      style: overridenStyles,
    );
  }
}
