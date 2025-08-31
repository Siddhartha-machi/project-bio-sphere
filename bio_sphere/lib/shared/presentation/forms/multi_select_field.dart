import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/features/extensions/todos/root.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class MultiSelectField extends StatelessWidget {
  final GenericFieldController<Set<GenericFieldOption>> controller;

  const MultiSelectField(this.controller, {super.key});

  Set<GenericFieldOption> _data() {
    return controller.data ?? <GenericFieldOption>{};
  }

  Widget _selectableChip(GenericFieldOption option, BuildContext ctx) {
    final theme = Theme.of(ctx);
    final isActive = _data().contains(option);

    return GestureDetector(
      onTap: () => _customDidChange(option),
      child: UIChip(
        iconSize: 10.sp,
        padding: (6, 12),
        label: option.label,
        color: isActive ? null : theme.dividerColor,
        icon: option.iconConfig != null
            ? FontAwesomeIconData(option.iconConfig!)
            : null,
      ),
    );
  }

  _customDidChange(GenericFieldOption option) {
    final newSet = {..._data()};

    /// Option selected again, so remove it
    if (newSet.contains(option)) {
      newSet.remove(option);
    } else {
      newSet.add(option);
    }

    controller.didChange(newSet);
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    final options = controller.config.options ?? [];

    if (options.isEmpty) {
      child = TextUI('No options', level: TextLevel.bodySmall);
    } else {
      child = Wrap(
        spacing: 12.sp,
        runSpacing: 12.sp,
        children: List.generate(
          options.length,
          (index) => _selectableChip(options[index], context),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 8.sp),
      child: child,
    );
  }
}
