import 'package:flutter/material.dart';

import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/presentation/ui_feedback/loaders.dart';

class GenericIconButton extends StatelessWidget {
  const GenericIconButton({
    super.key,
    this.height,
    this.bgColor,
    this.iconSize,
    this.iconColor,
    this.onPressed,
    this.borderRadius,
    required this.icon,
    this.isLoading = false,
    this.type = ButtonType.filled,
    this.variant = ButtonVariant.primary,
  });

  final IconData icon;
  final Color? bgColor;
  final bool isLoading;
  final double? height;
  final ButtonType type;
  final Color? iconColor;
  final double? iconSize;
  final double? borderRadius;
  final ButtonVariant variant;
  final VoidCallback? onPressed;

  List<Color> _buildColors(BuildContext context) {
    final theme = Theme.of(context);
    Color kBgColor, kIconColor;

    if (onPressed == null) {
      kBgColor = kIconColor = theme.disabledColor;
    } else {
      switch (variant) {
        case ButtonVariant.primary:
          kBgColor = theme.colorScheme.primary;
          kIconColor = theme.colorScheme.onPrimary;
        case ButtonVariant.secondary:
          kBgColor = theme.colorScheme.onPrimary;
          kIconColor = theme.colorScheme.primary;
        case ButtonVariant.error:
          kBgColor = theme.colorScheme.error;
          kIconColor = theme.colorScheme.onError;
      }
    }

    return [bgColor ?? kBgColor, iconColor ?? kIconColor];
  }

  Widget _buildLoader(Color color) {
    double size = 20;

    if (height != null) {
      size = height! - (height! / 2.3);
    }

    return SizedBox(height: size, width: size, child: Loaders.spinner(color));
  }

  @override
  Widget build(BuildContext context) {
    Widget button;
    final pressHandler = isLoading ? null : onPressed;
    final [kBgColor, kIconColor] = _buildColors(context);

    if (type == ButtonType.filled) {
      button = IconButton.filled(
        color: kIconColor,
        iconSize: iconSize,
        onPressed: pressHandler,
        icon: isLoading ? _buildLoader(kBgColor) : Icon(icon),
      );
    } else if (type == ButtonType.outlined) {
      button = IconButton.outlined(
        color: kIconColor,
        iconSize: iconSize,
        onPressed: pressHandler,
        icon: isLoading ? _buildLoader(kBgColor) : Icon(icon),
      );
    } else {
      button = IconButton(
        color: kBgColor,
        iconSize: iconSize,
        onPressed: pressHandler,
        padding: EdgeInsets.zero,
        icon: isLoading ? _buildLoader(kBgColor) : Icon(icon),
      );
    }
    return SizedBox(height: height, child: button);
  }
}
