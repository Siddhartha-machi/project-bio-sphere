import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/form/form_field_definition.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/presentation/components/expanding_container.dart';

class FormLayoutEngine {
  final double rowSpacing;
  final double columnSpacing;
  final double sectionSpacing;
  final bool withContentBorder;
  final List<GenericFieldConfig> configList;
  static const String _defaultKey = 'Details';
  final Map<String, FieldDefinition> buildersMap;
  final (double, double, double, double) contentPadding;

  const FormLayoutEngine({
    this.rowSpacing = 10,
    this.columnSpacing = 10,
    required this.configList,
    this.sectionSpacing = 10,
    required this.buildersMap,
    this.withContentBorder = false,
    this.contentPadding = (0, 10, 0, 0),
  });

  Map<String, List<GenericFieldConfig>> _convertToGroups() {
    Map<String, List<GenericFieldConfig>> groups = {};

    for (final config in configList) {
      final key = config.group != null ? config.group! : _defaultKey;

      if (groups[key] == null) {
        groups[key] = [];
      }

      groups[key]!.add(config);
    }

    return groups;
  }

  Widget buildLayout() {
    return Column(
      spacing: columnSpacing.sp,
      children: List.generate(configList.length, (index) {
        final config = configList[index];
        final widget = buildersMap[config.name]!.builder(config);

        return widget;
      }),
    );
  }

  Widget buildLayoutWithGrouping() {
    int groupIndex = 0;
    List<Widget> children = [];
    final hSpacing = rowSpacing.sp;
    final groupedMap = _convertToGroups();

    for (final key in groupedMap.keys) {
      List<Widget> rowGroup = [];
      final List<Widget> widgetGroup = [];

      final List<GenericFieldConfig> groupedList = groupedMap[key]!;

      for (int i = 0; i < groupedList.length; i++) {
        final fieldConfig = groupedList[i];
        final widget = buildersMap[fieldConfig.name]!.builder(fieldConfig);

        if (fieldConfig.halfWidth) {
          if (rowGroup.isEmpty) {
            rowGroup.add(Flexible(child: widget));
            rowGroup.add(const Spacer(flex: 1));
          } else if (rowGroup.length == 2 && rowGroup.last is Spacer) {
            rowGroup[rowGroup.length - 1] = Flexible(child: widget);
            widgetGroup.add(Row(spacing: hSpacing, children: rowGroup));
            rowGroup = [];
          } else {
            widgetGroup.add(Row(spacing: hSpacing, children: rowGroup));
            rowGroup = [Flexible(child: widget), const Spacer(flex: 1)];
          }
        } else {
          if (rowGroup.isNotEmpty) {
            widgetGroup.add(Row(spacing: hSpacing, children: rowGroup));
            rowGroup = [];
          }
          widgetGroup.add(widget);
        }
      }

      // Flush leftover half-width row
      if (rowGroup.isNotEmpty) {
        widgetGroup.add(Row(spacing: hSpacing, children: rowGroup));
        rowGroup = [];
      }

      if (widgetGroup.isNotEmpty) {
        children.add(
          CustomExpansionTile(
            title: key,
            isExpanded: groupIndex == 0,
            contentPadding: contentPadding,
            enableContentBorder: withContentBorder,
            child: Column(spacing: columnSpacing.sp, children: widgetGroup),
          ),
        );
      }

      groupIndex++;
    }

    return Column(
      spacing: sectionSpacing.sp,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }
}


/// ------------- TODO --------------- ///
/// 1. Align row group widgets when one of child has helptext.