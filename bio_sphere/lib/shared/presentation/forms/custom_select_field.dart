import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';
import 'package:bio_sphere/shared/presentation/ui_overlays/bottom_sheets.dart';
import 'package:bio_sphere/shared/presentation/list_widgets/generic_list_view.dart';

class CustomSelectField extends StatelessWidget {
  final GenericFieldController<GenericFieldOption> controller;

  const CustomSelectField(this.controller, {super.key});

  static final iconSize = 12.sp;

  GenericFieldConfig _config() => controller.config;

  GenericFieldOption _selectedOp(GenericFieldState<GenericFieldOption> state) {
    if (state.data != null) {
      return state.data!;
    }
    return GenericFieldOption(optionLabel: 'No option selected', value: 'null');
  }

  Widget _buildSelectedOption(GenericFieldOption option) {
    return Row(
      spacing: 8.0,
      children: [
        if (option.iconConfig != null)
          Icon(
            IconData(option.iconConfig!, fontFamily: 'MaterialIcons'),
            size: iconSize,
          ),
        Expanded(
          child: TextUI(
            option.optionLabel,
            align: TextAlign.start,
            level: TextLevel.bodySmall,
          ),
        ),
      ],
    );
  }

  Widget _buildOption(
    BuildContext ctx,
    GenericFieldOption option,
    bool isActive,
  ) {
    final color = isActive ? Theme.of(ctx).primaryColor : null;

    return InkWell(
      onTap: () => Navigator.of(ctx).pop(option),
      child: Row(
        spacing: 12.0,
        children: [
          if (option.iconConfig != null)
            Container(
              color: Theme.of(ctx).primaryColor,
              padding: EdgeInsets.all(4.0.sp),
              child: Icon(
                color: Theme.of(ctx).colorScheme.onPrimary,
                IconData(option.iconConfig!, fontFamily: 'MaterialIcons'),
              ),
            ),
          Expanded(
            child: TextUI(
              option.optionLabel,
              color: color,
              align: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showOptions(BuildContext ctx) async {
    final config = _config();
    final value = controller.data;

    final result = await BottomSheets.showDraggableListBottomSheet(
      context: ctx,
      title: 'Choose an option',
      childHeightRatio: 0.35,
      builder: (ctx, sControl) => Global.isEmptyList(config.options)
          ? SizedBox(
              height: 150.sp,
              child: TextUI('No options to choose', level: TextLevel.bodySmall),
            )
          : GenericListView(
              gap: 16,
              scrollController: sControl,
              data: config.options!,
              builder: (option) => _buildOption(ctx, option, value == option),
            ),
    );

    if (result != controller.data) {
      controller.didChange(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOptions(context),
      child: Padding(
        padding: EdgeInsets.all(10.sp),
        child: Row(
          spacing: 12.sp,
          children: [
            Expanded(
              child: _buildSelectedOption(_selectedOp(controller.value)),
            ),
            Icon(FontAwesome.chevron_right_solid, size: 13.sp),
          ],
        ),
      ),
    );
  }
}
