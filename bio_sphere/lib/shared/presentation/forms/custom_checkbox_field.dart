import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class CustomCheckboxField extends StatelessWidget {
  final GenericFieldController<bool> controller;

  const CustomCheckboxField(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final isChecked = controller.data == true;

    return InkWell(
      onTap: () => controller.didChange(!(controller.data ?? false)),
      child: Padding(
        padding: const EdgeInsetsGeometry.fromLTRB(12, 8, 12, 8),
        child: Row(
          spacing: 12.sp,
          children: [
            if (!Global.isEmptyString(controller.config.hintText))
              Expanded(
                child: TextUI(
                  controller.config.hintText!,
                  level: TextLevel.bodySmall,
                ),
              ),
            Icon(
              size: 20.sp,
              isChecked ? FontAwesome.square_check_solid : FontAwesome.square,
              color: isChecked
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.onSurface.withAlpha(160),
            ),
          ],
        ),
      ),
    );
  }
}
