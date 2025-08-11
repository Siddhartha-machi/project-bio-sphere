import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class CustomDateTimeField extends StatelessWidget {
  final GenericFieldController<DateTime> controller;

  const CustomDateTimeField(this.controller, {super.key});

  Widget _buildFieldIcon() {
    IconData icon = FontAwesome.calendar;

    if (controller.config.type == GenericFieldType.time) {
      icon = FontAwesome.clock;
    }

    return Icon(icon, size: 16.sp);
  }

  bool get isTimeMode => controller.config.type == GenericFieldType.time;
  bool get isDateMode => controller.config.type == GenericFieldType.date;
  bool get isDateTimeMode =>
      controller.config.type == GenericFieldType.dateTime;

  String _buildDisplayValue(BuildContext ctx) {
    if (controller.data == null) {
      return 'No ${isTimeMode ? 'Time' : 'Date'} Selected';
    }

    final selected = controller.data;

    switch (controller.config.type) {
      case GenericFieldType.date:
        return "${selected!.day.toString().padLeft(2, '0')}-${selected.month.toString().padLeft(2, '0')}-${selected.year}";
      case GenericFieldType.time:
        return TimeOfDay.fromDateTime(selected!).format(ctx);
      case GenericFieldType.dateTime:
        return "${selected!.day.toString().padLeft(2, '0')}-${selected.month.toString().padLeft(2, '0')}-${selected.year} "
            "${TimeOfDay.fromDateTime(selected).format(ctx)}";
      default:
        throw Exception('Incompatable controller assigned.');
    }
  }

  Future<DateTime?> _pickDate(BuildContext ctx) async {
    return await showDatePicker(
      context: ctx,
      lastDate: DateTime(2100),
      firstDate: DateTime(2000),
      initialDate: controller.data ?? DateTime.now(),
    );
  }

  Future<TimeOfDay?> _pickTime(BuildContext ctx) async {
    final selected = controller.data;

    return await showTimePicker(
      context: ctx,
      initialTime: selected == null
          ? TimeOfDay.now()
          : TimeOfDay(hour: selected.hour, minute: selected.minute),
    );
  }

  Future<void> _pick(BuildContext ctx) async {
    /// We start with existing date or today's date
    DateTime newDateTime = controller.data ?? DateTime.now();

    /// In date or dateTime mode we first select date
    if (isDateMode || isDateTimeMode) {
      final date = await _pickDate(ctx);
      if (date == null) return;

      newDateTime = DateTime(date.year, date.month, date.day);
    }

    /// If it's dateTime or time mode we need to get time
    if ((isDateTimeMode || isTimeMode) && ctx.mounted) {
      final time = await _pickTime(ctx);

      if (time == null) return;

      newDateTime = DateTime(
        newDateTime.year,
        newDateTime.month,
        newDateTime.day,
        time.hour,
        time.minute,
      );
    }

    if (newDateTime != controller.data) {
      controller.didChange(newDateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pick(context),
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Row(
          spacing: 12.sp,
          children: [
            Expanded(
              child: TextUI(
                _buildDisplayValue(context),
                level: TextLevel.bodySmall,
              ),
            ),
            _buildFieldIcon(),
          ],
        ),
      ),
    );
  }
}
