import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/style.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';

class UIChip extends StatelessWidget {
  final String label;
  final Color? color;
  final IconData? icon;
  final double iconSize;
  final (double, double) padding;

  const UIChip({
    super.key,
    this.icon,
    this.color,
    this.iconSize = 14,
    required this.label,
    this.padding = (4, 8),
  });

  @override
  Widget build(BuildContext context) {
    final radius = Style.themeBorderRadius(context);
    final effColor = color ?? Theme.of(context).primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: effColor.withAlpha(50),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      padding: EdgeInsets.symmetric(
        vertical: padding.$1.sp,
        horizontal: padding.$2.sp,
      ),
      child: Row(
        spacing: 6.sp,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon!, color: effColor, size: iconSize.sp),
          TextUI(label, color: effColor, level: TextLevel.labelSmall),
        ],
      ),
    );
  }
}
