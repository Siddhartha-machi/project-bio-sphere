import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class CustomRatingField extends StatelessWidget {
  final GenericFieldController<int> controller;

  const CustomRatingField(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    final value = (controller.data ?? 0).toInt();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          final isActive = index < value;
          final color = isActive
              ? Theme.of(context).primaryColor
              : Theme.of(context).colorScheme.onSurface.withAlpha(180);

          return GestureDetector(
            onTap: () => {
              if (index + 1 == value)
                /// If the same icon is tapped twice we reset value
                {controller.didChange(0)}
              else
                {controller.didChange(index + 1)},
            },
            child: Icon(
              color: color,
              size: (controller.config.size ?? 25).sp,
              isActive ? FontAwesome.star_solid : FontAwesome.star,
            ),
          );
        }),
      ),
    );
  }
}
