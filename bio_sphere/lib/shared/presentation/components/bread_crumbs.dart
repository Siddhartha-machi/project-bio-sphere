import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/models/widget_models/bread_crumb.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';

class Breadcrumbs extends StatelessWidget {
  const Breadcrumbs({
    super.key,
    this.size,
    this.color,
    required this.crumbs,
    this.divider = Icons.chevron_right_sharp,
  });

  final List<BreadCrumb> crumbs;
  final IconData divider;
  final Color? color;
  final double? size;

  Color _getColor(BuildContext context) =>
      color ?? Theme.of(context).colorScheme.onPrimary;

  double _getSize(BuildContext context) =>
      size ?? Theme.of(context).textTheme.titleSmall?.fontSize ?? 14.0.sp;

  double _getDividerSize(BuildContext context) => _getSize(context) * 1.6;

  Widget _buildCrumbItem(BuildContext context, BreadCrumb crumb) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextUI(
          crumb.label,
          color: _getColor(context),
          fontSize: _getSize(context),
        ),
        if (!Global.isEmptyString(crumb.caption))
          TextUI(crumb.caption!, level: TextLevel.bodySmall),
      ],
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Icon(
      divider,
      color: _getColor(context),
      size: _getDividerSize(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(crumbs.isNotEmpty, true);

    return Row(
      spacing: 3.sp,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        for (int i = 0; i < crumbs.length; i++) ...[
          _buildCrumbItem(context, crumbs[i]),
          if (i < crumbs.length - 1) _buildDivider(context),
        ],
      ],
    );
  }
}
