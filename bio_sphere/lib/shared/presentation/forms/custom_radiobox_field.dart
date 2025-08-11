import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class CustomRadioboxField extends StatelessWidget {
  final GenericFieldController<int> controller;

  const CustomRadioboxField(this.controller, {super.key});

  Widget _buildRadioButton(BuildContext ctx, int index) {
    final isActive = controller.data == index;
    final color = isActive
        ? Theme.of(ctx).primaryColor
        : Theme.of(ctx).colorScheme.onPrimary;

    return GestureDetector(
      onTap: () => controller.didChange(index),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 2.sp),
        padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 4.sp),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(3.sp),
          color: color.withAlpha(60),
        ),
        child: Row(
          spacing: 12.0.sp,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              spacing: 3.0.sp,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextUI('Label', level: TextLevel.bodySmall),
                TextUI('Description', level: TextLevel.caption),
              ],
            ),
            isActive
                ? Icon(
                    FontAwesome.circle_check_solid,
                    size: 15.sp,
                    color: color,
                  )
                : Icon(FontAwesome.circle, size: 15.sp),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [for (int i = 0; i < 3; i++) _buildRadioButton(context, i)],
    );
  }
}
