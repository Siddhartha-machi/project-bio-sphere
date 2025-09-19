import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';
import 'package:bio_sphere/shared/presentation/ui_feedback/loaders.dart';

class GenericButton extends StatelessWidget {
  const GenericButton({
    super.key,
    this.color,
    this.height,
    this.iconSize,
    this.textColor,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius,
    required this.label,
    this.isLoading = false,
    this.fullwidth = false,
    this.isCircular = false,
    this.type = ButtonType.filled,
    this.variant = ButtonVariant.primary,
  });

  final String label;
  final Color? color;
  final bool fullwidth;
  final double? height;
  final bool isLoading;
  final ButtonType type;
  final bool isCircular;
  final Color? textColor;
  final double? iconSize;
  final double? borderRadius;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final ButtonVariant variant;
  final VoidCallback? onPressed;

  List<Color> _buildColors(BuildContext context) {
    final theme = Theme.of(context);
    Color bgColor, txtColor;

    if (onPressed == null) {
      bgColor = txtColor = theme.disabledColor;
    } else {
      switch (variant) {
        case ButtonVariant.primary:
          bgColor = theme.colorScheme.primary;
          txtColor = theme.colorScheme.onPrimary;
        case ButtonVariant.secondary:
          bgColor = theme.colorScheme.onPrimary;
          txtColor = theme.colorScheme.primary;
        case ButtonVariant.error:
          bgColor = theme.colorScheme.error;
          txtColor = theme.colorScheme.onError;
      }
    }

    return [color ?? bgColor, textColor ?? txtColor];
  }

  Widget _buildChild(BuildContext context, Color txtColor) {
    final size = iconSize ?? 18.sp;

    return Row(
      spacing: 8.0,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (prefixIcon != null) Icon(prefixIcon, color: txtColor, size: size),

        TextUI(label, color: txtColor),

        if (suffixIcon != null) Icon(suffixIcon, color: txtColor, size: size),
      ],
    );
  }

  Widget _buildLoader(Color color) {
    double size = 20;
    if (height != null) {
      size = height! - (height! / 2.3);
    }

    return SizedBox(height: size, width: size, child: Loaders.spinner(color));
  }

  ButtonStyle _buildButtonStyle({Color? bgColor, Color? borderColor}) {
    ShapeBorder? border;

    if (isCircular == true) {
      border = const CircleBorder();
    } else if (borderRadius != null) {
      border = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius!),
      );
    } else {
      // null means use default from theme
      border = null;
    }

    return ButtonStyle(
      backgroundColor: WidgetStateProperty.all(bgColor),
      shape: WidgetStateProperty.all(border as OutlinedBorder?),
      side: borderColor != null
          ? WidgetStateProperty.all(BorderSide(color: borderColor))
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget button;
    final [bgColor, txtColor] = _buildColors(context);
    final pressHandler = isLoading ? null : onPressed;

    if (type == ButtonType.filled) {
      button = FilledButton(
        onPressed: pressHandler,
        style: _buildButtonStyle(bgColor: bgColor),
        child: isLoading
            ? _buildLoader(txtColor)
            : _buildChild(context, txtColor),
      );
    } else if (type == ButtonType.outlined) {
      button = OutlinedButton(
        onPressed: pressHandler,
        style: _buildButtonStyle(borderColor: bgColor),
        child: isLoading
            ? _buildLoader(bgColor)
            : _buildChild(context, bgColor),
      );
    } else {
      button = TextButton(
        onPressed: pressHandler,
        style: _buildButtonStyle(),
        child: isLoading
            ? _buildLoader(bgColor)
            : _buildChild(context, bgColor),
      );
    }
    return SizedBox(height: height, child: button);
  }
}
