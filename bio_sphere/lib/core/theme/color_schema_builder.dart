import 'package:flutter/material.dart';

import 'package:material_color_utilities/material_color_utilities.dart';

class ColorSchemaBuilder {
  static ColorScheme fromSeed({
    Color? errorColor,
    required Color seedColor,
    required Brightness brightness,
  }) {
    final core = CorePalette.of(seedColor.toARGB32());

    // Helpers to convert ARGB int (from palettes) → Flutter Color
    Color argb(int a) => Color(a);

    // Primary/Secondary/Tertiary/Error tonal palettes
    final p = core.primary;
    final s = core.secondary;
    final t = core.tertiary;
    final e = core.error;

    // Neutral palettes (surfaces, outlines)
    final n = core.neutral;
    final nv = core.neutralVariant;

    // Recommended M3 tone mapping:
    // Light scheme tones (Material Design guidance)
    const lPrimary = 50;
    const lOnprimary = 100;
    const lPrimarycontainer = 90;
    const lOnprimarycontainer = 10;

    const lSecondary = 60;
    const lOnsecondary = 100;
    const lSecondarycontainer = 90;
    const lOnsecondarycontainer = 10;

    const lTertiary = 40;
    const lOntertiary = 100;
    const lTertiarycontainer = 90;
    const lOntertiarycontainer = 10;

    const lError = 40;
    const lOnerror = 100;
    const lErrorcontainer = 90;
    const lOnerrorcontainer = 10;

    const lSurface = 250; // neutral
    const lOnsurface = 10;
    const lOnsurfacevariant = 30;
    const lOutline = 50;
    const lOutlinevariant = 80;
    const lInversesurface = 20;
    const lInverseonsurface = 95;
    const lInverseprimary = 80;
    const lSurfacetint = lPrimary;

    // Dark scheme tones
    const dPrimary = 80;
    const dOnprimary = 20;
    const dPrimarycontainer = 30;
    const dOnprimarycontainer = 90;

    const dSecondary = 80;
    const dOnsecondary = 20;
    const dSecondarycontainer = 30;
    const dOnsecondarycontainer = 90;

    const dTertiary = 80;
    const dOntertiary = 20;
    const dTertiarycontainer = 30;
    const dOntertiarycontainer = 90;

    const dError = 80;
    const dOnerror = 20;
    const dErrorcontainer = 30;
    const dOnerrorcontainer = 80;

    const dSurface = 6; // near-black but not pure
    const dOnsurface = 90;
    const dOnsurfacevariant = 80;
    const dOutline = 60;
    const dOutlinevariant = 30;
    const dInversesurface = 90;
    const dInverseonsurface = 20;
    const dInverseprimary = 40;
    const dSurfacetint = dPrimary;

    if (brightness == Brightness.light) {
      final primary = argb(p.get(lPrimary));

      return ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: argb(p.get(lOnprimary)),
        primaryContainer: argb(p.get(lPrimarycontainer)),
        onPrimaryContainer: argb(p.get(lOnprimarycontainer)),

        secondary: argb(s.get(lSecondary)),
        onSecondary: argb(s.get(lOnsecondary)),
        secondaryContainer: argb(s.get(lSecondarycontainer)),
        onSecondaryContainer: argb(s.get(lOnsecondarycontainer)),

        tertiary: argb(t.get(lTertiary)),
        onTertiary: argb(t.get(lOntertiary)),
        tertiaryContainer: argb(t.get(lTertiarycontainer)),
        onTertiaryContainer: argb(t.get(lOntertiarycontainer)),

        error: errorColor ?? argb(e.get(lError)),
        onError: argb(e.get(lOnerror)),
        errorContainer: argb(e.get(lErrorcontainer)),
        onErrorContainer: argb(e.get(lOnerrorcontainer)),

        surface: argb(n.get(lSurface)),
        onSurface: argb(n.get(lOnsurface)),
        onSurfaceVariant: argb(nv.get(lOnsurfacevariant)),
        outline: argb(nv.get(lOutline)),
        outlineVariant: argb(nv.get(lOutlinevariant)),
        shadow: Colors.black,
        scrim: Colors.black,

        inverseSurface: argb(n.get(lInversesurface)),
        onInverseSurface: argb(n.get(lInverseonsurface)),
        inversePrimary: argb(p.get(lInverseprimary)),
        surfaceTint: argb(p.get(lSurfacetint)),
      );
    } else {
      final primary = argb(p.get(dPrimary));

      return ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: argb(p.get(dOnprimary)),
        primaryContainer: argb(p.get(dPrimarycontainer)),
        onPrimaryContainer: argb(p.get(dOnprimarycontainer)),

        secondary: argb(s.get(dSecondary)),
        onSecondary: argb(s.get(dOnsecondary)),
        secondaryContainer: argb(s.get(dSecondarycontainer)),
        onSecondaryContainer: argb(s.get(dOnsecondarycontainer)),

        tertiary: argb(t.get(dTertiary)),
        onTertiary: argb(t.get(dOntertiary)),
        tertiaryContainer: argb(t.get(dTertiarycontainer)),
        onTertiaryContainer: argb(t.get(dOntertiarycontainer)),

        error: errorColor ?? argb(e.get(dError)),
        onError: argb(e.get(dOnerror)),
        errorContainer: argb(e.get(dErrorcontainer)),
        onErrorContainer: argb(e.get(dOnerrorcontainer)),

        surface: argb(n.get(dSurface)),
        onSurface: argb(n.get(dOnsurface)),
        onSurfaceVariant: argb(nv.get(dOnsurfacevariant)),
        outline: argb(nv.get(dOutline)),
        outlineVariant: argb(nv.get(dOutlinevariant)),
        shadow: Colors.black,
        scrim: Colors.black,

        inverseSurface: argb(n.get(dInversesurface)),
        onInverseSurface: argb(n.get(dInverseonsurface)),
        inversePrimary: argb(p.get(dInverseprimary)),
        surfaceTint: argb(p.get(dSurfacetint)),
      );
    }
  }
}
