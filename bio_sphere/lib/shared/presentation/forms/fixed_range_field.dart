import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class FixedRangeField extends StatelessWidget {
  final GenericFieldController<RangeValues> controller;

  const FixedRangeField(this.controller, {super.key});

  (double, double) _getMinMax() {
    final extra = controller.config.extra;

    return (extra['min'] ?? 0.0, extra['max'] ?? 100.0);
  }

  @override
  Widget build(BuildContext context) {
    final (min, max) = _getMinMax();
    final range = controller.data ?? RangeValues(0, 0);
    final start = range.start.toInt().toString();
    final end = range.end.toInt().toString();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.sp),
      child: Column(
        spacing: 8.sp,
        children: [
          RangeSlider(
            min: min,
            max: max,
            values: range,
            labels: RangeLabels(start, end),
            onChanged: controller.didChange,
            padding: EdgeInsetsGeometry.zero,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextUI(
                'Min ( ${min.toInt()} )',
                align: TextAlign.center,
                level: TextLevel.labelMedium,
              ),
              TextUI(
                'Max ( ${max.toInt()} )',
                align: TextAlign.center,
                level: TextLevel.labelMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
