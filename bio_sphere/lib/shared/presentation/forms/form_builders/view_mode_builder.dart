import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/form/form_layout_engine.dart';
import 'package:bio_sphere/shared/utils/form/form_field_definition.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/presentation/forms/field_value_renderers/data_renderers.dart';
import 'package:bio_sphere/shared/presentation/forms/field_value_renderers/label_renderer.dart';

class ReadOnlyForm extends StatelessWidget {
  final Map<String, dynamic> data;
  final List<GenericFieldConfig> configList;

  const ReadOnlyForm({super.key, required this.data, required this.configList});

  Widget _fieldInViewMode(GenericFieldConfig config, dynamic value) {
    return Column(
      spacing: 6.sp,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabelBuilder(config: config),
        GenericDataRenderer(data: value, config: config),
      ],
    );
  }

  Map<String, ReadViewFieldDefinition> _buildDefinitions() {
    final Map<String, ReadViewFieldDefinition> defs = {};

    for (final config in configList) {
      final value = data[config.name];
      defs[config.name] = ReadViewFieldDefinition(
        builder: (config) => _fieldInViewMode(config, value),
      );
    }

    return defs;
  }

  @override
  Widget build(BuildContext context) {
    final layoutEngine = FormLayoutEngine(
      columnSpacing: 18,
      configList: configList,
      contentPadding: (10, 10, 10, 3),
      buildersMap: _buildDefinitions(),
    );
    return layoutEngine.buildLayoutWithGrouping();
  }
}
