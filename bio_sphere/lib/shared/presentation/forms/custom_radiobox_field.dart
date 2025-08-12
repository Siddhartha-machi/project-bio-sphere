import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class CustomRadioboxField extends StatelessWidget {
  final GenericFieldController<GenericFieldOption> controller;

  const CustomRadioboxField(this.controller, {super.key});

  Widget _buildRadioButton(BuildContext ctx, GenericFieldOption option) {
    final isActive = controller.data == option;
    final color = isActive
        ? Theme.of(ctx).primaryColor
        : Theme.of(ctx).colorScheme.onPrimary;

    return GestureDetector(
      onTap: () => controller.didChange(option),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0.sp),
        padding: EdgeInsets.symmetric(horizontal: 8.0.sp, vertical: 8.sp),
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
                TextUI(option.label, level: TextLevel.bodySmall),
                if (!Global.isEmptyString(option.description))
                  TextUI(option.description!, level: TextLevel.caption),
              ],
            ),
            isActive
                ? Icon(
                    size: 15.sp,
                    color: color,
                    FontAwesome.circle_check_solid,
                  )
                : Icon(FontAwesome.circle, size: 15.sp),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final options = controller.config.options;

    assert(options != null && options.length > 1);
    if (options == null) return TextUI('No options provided');

    return Column(
      children: List.generate(
        options.length,
        (index) => _buildRadioButton(context, options[index]),
      ),
    );
  }
}
