import 'package:flutter/material.dart';

import 'package:icons_plus/icons_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';

/// ---------------- Field atoms ------------------ ///

class FieldLabelBuilder extends StatelessWidget {
  final GenericFieldConfig config;

  const FieldLabelBuilder({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    if (config.prefixIcon != null) {
      children.add(Icon(FontAwesomeIconData(config.prefixIcon!), size: 14.sp));
    }

    if (!Global.isEmptyString(config.label)) {
      children.add(TextUI(config.label!, level: TextLevel.labelMedium));
    }

    return Row(spacing: 5, children: children);
  }
}
