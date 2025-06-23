import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';

class GenericButton extends StatelessWidget {
  const GenericButton({
    super.key,
    this.color,
    this.label,
    this.height,
    this.iconSize,
    this.textColor,
    this.onPressed,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.fullwidth = false,
    this.type = ButtonType.filled,
    this.variant = ButtonVariant.primary,
  });

  final String? label;
  final Color? color;
  final bool fullwidth;
  final double? height;
  final bool isLoading;
  final ButtonType type;
  final Color? textColor;
  final double? iconSize;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final ButtonVariant variant;
  final VoidCallback? onPressed;

  List<Color> _buildColors(BuildContext context) {
    final theme = Theme.of(context);
    Color bgColor, txtColor;

    if (onPressed == null || isLoading) {
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
        if (label != null)
          Text(
            label!,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(color: txtColor),
          ),
        if (suffixIcon != null) Icon(suffixIcon, color: txtColor, size: size),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget button;
    final [bgColor, txtColor] = _buildColors(context);

    if (type == ButtonType.filled) {
      button = FilledButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(bgColor),
          shape: WidgetStateProperty.all(
            Theme.of(context).buttonTheme.shape as OutlinedBorder?,
          ),
        ),
        child: _buildChild(context, txtColor),
      );
    } else if (type == ButtonType.outlined) {
      button = OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            Theme.of(context).buttonTheme.shape as OutlinedBorder?,
          ),
          side: WidgetStateProperty.all(BorderSide(color: bgColor)),
        ),
        child: _buildChild(context, bgColor),
      );
    } else {
      button = TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            Theme.of(context).buttonTheme.shape as OutlinedBorder?,
          ),
        ),
        child: _buildChild(context, bgColor),
      );
    }
    return SizedBox(height: height, child: button);
  }
}
