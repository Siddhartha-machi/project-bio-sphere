import 'package:flutter/material.dart';

/// Utility class for color styling and gradients.
class Style {
  /// Returns a darker shade of the given [color].
  /// [amount] specifies how much to darken (0.0 to 1.0).
  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  /// Returns a lighter shade of the given [color].
  /// [amount] specifies how much to lighten (0.0 to 1.0).
  static Color lighter(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );

    return hslLight.toColor();
  }

  /// Generates a symmetrical gradient of [n] colors from light -> base -> dark.
  /// [baseColor] is the starting color.
  /// [n] is the number of colors in the gradient (must be > 1).
  /// [spread] controls the range of lightness variation (0.0 to 1.0).
  static List<Color> generateColorGradient(
    Color baseColor,
    int n, {
    double spread = .3,
  }) {
    assert(n > 1, 'Must generate at least 2 color.');
    assert(spread >= 0 && spread <= 1, 'Spread must be between 0 and 1.');

    final hsl = HSLColor.fromColor(baseColor);

    if (n == 1) return [baseColor];

    final half = n ~/ 2;
    final step = half == 0 ? 0 : spread / half;

    // Generate gradient colors by adjusting lightness symmetrically around baseColor.
    return List.generate(n, (i) {
      final diff = (i - half).toDouble();
      final lightness = (hsl.lightness - (diff * step)).clamp(0.0, 1.0);
      return hsl.withLightness(lightness).toColor();
    });
  }
}
