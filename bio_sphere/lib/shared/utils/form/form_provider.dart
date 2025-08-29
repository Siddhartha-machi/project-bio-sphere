import 'package:flutter/material.dart';

import 'package:bio_sphere/shared/utils/form/form_scope.dart';
import 'package:bio_sphere/shared/utils/form/form_layout_engine.dart';
import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';
import 'package:bio_sphere/shared/utils/form/form_field_definition.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/utils/form/form_registration_manager.dart';

class FormProvider extends StatefulWidget {
  final bool useGrouping;
  final double colSpacing;
  final FormStateManager formManager;
  final Map<String, dynamic> initialValues;
  final List<GenericFieldConfig> configList;

  const FormProvider({
    super.key,
    this.colSpacing = 25.0,
    required this.configList,
    this.useGrouping = false,
    required this.formManager,
    this.initialValues = const {},
  });

  @override
  State<FormProvider> createState() => _FormProviderState();

  static FormStateManager of(BuildContext context) => FormScope.of(context);
}

class _FormProviderState extends State<FormProvider> {
  late final FormStateManager formManager;
  late final FormLayoutEngine _layoutEngine;
  late final Map<String, FormFieldDefinition> _definitions;

  /// ----------- Life cycle methods ---------------- ///
  @override
  void initState() {
    super.initState();
    formManager = widget.formManager;

    /// Create registration manager object.
    final registrationManager = FormRegistrationManager(
      formManager: formManager,
      configList: widget.configList,
      initialValues: widget.initialValues,
    );

    /// Form registration wasn't done parent, we'll do it here.
    if (!formManager.isRegistrationComplete()) {
      registrationManager.registerForm();
    }

    /// Build field definitions
    _definitions = registrationManager.buildFieldDefinitions();

    // TODO: try optimization by building the layout here once
    _layoutEngine = FormLayoutEngine(
      buildersMap: _definitions,
      contentPadding: (5, 10, 5, 0),
      configList: widget.configList,
      columnSpacing: widget.colSpacing,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormScope(
      formManager: formManager,
      child: widget.useGrouping
          ? _layoutEngine.buildLayoutWithGrouping()
          : _layoutEngine.buildLayout(),
    );
  }
}
