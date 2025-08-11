import 'package:flutter/material.dart';

import 'package:bio_sphere/models/widget_models/generic_field_config.dart';

class FormFieldDefinition {
  final List<String> dependsOn;
  final Widget Function(GenericFieldConfig config) builder;
  final bool Function(Map<String, dynamic> values)? visibleWhen;

  FormFieldDefinition({
    this.visibleWhen,
    required this.builder,
    this.dependsOn = const [],
  });
}
