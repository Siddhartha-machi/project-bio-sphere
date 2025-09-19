import 'package:flutter/material.dart';

import 'package:bio_sphere/models/widget_models/generic_field_config.dart';

abstract class FieldDefinition {
  final Widget Function(GenericFieldConfig config) builder;

  const FieldDefinition({required this.builder});
}

/// -------------- Concrete class used to define read view definition -------------------- ///
class ReadViewFieldDefinition extends FieldDefinition {
  ReadViewFieldDefinition({required super.builder});
}

/// -------------- Concrete class that defines form field definition -------------------- ///
class FormFieldDefinition extends FieldDefinition {
  final List<String> dependsOn;
  final bool Function(Map<String, dynamic> values)? visibleWhen;

  FormFieldDefinition({
    this.visibleWhen,
    required super.builder,
    this.dependsOn = const [],
  });
}
