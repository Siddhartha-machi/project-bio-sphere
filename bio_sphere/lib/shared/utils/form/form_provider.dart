import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/utils/form/form_scope.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';
import 'package:bio_sphere/shared/utils/form/form_field_definition.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/constants/widget/text_widget_enums.dart';
import 'package:bio_sphere/shared/utils/form/form_registration_manager.dart';

class FormProvider extends StatefulWidget {
  final bool useGrouping;
  final double colSpacing;
  final FormStateManager formManager;
  final Map<String, dynamic> initialValues;
  final List<GenericFieldConfig> configList;

  const FormProvider({
    super.key,
    this.colSpacing = 16.0,
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
  late final Map<String, FormFieldDefinition> _definitions;

  static const String _defaultKey = '##---##';

  /// ----------- Life cycle methods ---------------- ///
  @override
  void initState() {
    super.initState();
    formManager = widget.formManager;

    /// Create registration manager object.
    final registrationManager = FormRegistrationManager(
      configList: widget.configList,
      initialValues: widget.initialValues,
    );

    /// Form registration wasn't done parent, we'll do it here.
    if (!widget.formManager.isRegistrationComplete()) {
      registrationManager.registerForm();
    }

    /// Build field definitions
    _definitions = registrationManager.buildFieldDefinitions();
  }

  /// ----------- Widget builder ---------------- ///

  Map<String, List<GenericFieldConfig>> _convertToGroups() {
    Map<String, List<GenericFieldConfig>> groups = {};

    for (final config in widget.configList) {
      final key = config.group != null ? config.group! : _defaultKey;

      if (groups[key] == null) {
        groups[key] = [];
      }

      groups[key]!.add(config);
    }

    return groups;
  }

  List<Widget> _arrangeFields(BuildContext ctx) {
    List<Widget> children = [];
    final groupedMap = _convertToGroups();
    final rowSpacing = 10.sp;

    for (final key in groupedMap.keys) {
      List<Widget> rowGroup = [];
      final List<Widget> widgetGroup = [];

      final List<GenericFieldConfig> groupedList = groupedMap[key]!;

      for (int i = 0; i < groupedList.length; i++) {
        final fieldConfig = groupedList[i];
        final widget = _definitions[fieldConfig.name]!.builder(fieldConfig);

        if (fieldConfig.halfWidth) {
          if (rowGroup.isEmpty) {
            rowGroup.add(Flexible(child: widget));
            rowGroup.add(const Spacer(flex: 1));
          } else if (rowGroup.length == 2 && rowGroup.last is Spacer) {
            rowGroup[rowGroup.length - 1] = Flexible(child: widget);
            widgetGroup.add(Row(spacing: rowSpacing, children: rowGroup));
            rowGroup = [];
          } else {
            widgetGroup.add(Row(spacing: rowSpacing, children: rowGroup));
            rowGroup = [Flexible(child: widget), const Spacer(flex: 1)];
          }
        } else {
          if (rowGroup.isNotEmpty) {
            widgetGroup.add(Row(spacing: rowSpacing, children: rowGroup));
            rowGroup = [];
          }
          widgetGroup.add(widget);
        }
      }

      // Flush leftover half-width row
      if (rowGroup.isNotEmpty) {
        widgetGroup.add(Row(spacing: rowSpacing, children: rowGroup));
        rowGroup = [];
      }

      if (widget.useGrouping && key != _defaultKey) {
        children.add(
          TextUI(
            key,
            level: TextLevel.titleSmall,
            color: Theme.of(ctx).colorScheme.onSurface.withAlpha(160),
          ),
        );
      }

      if (widgetGroup.isNotEmpty) {
        children.add(
          Column(spacing: widget.colSpacing.sp, children: widgetGroup),
        );
      }
    }

    return children;
  }

  @override
  Widget build(BuildContext context) {
    print('Building form');
    return FormScope(
      formManager: formManager,
      child: Column(
        spacing: 20.sp,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _arrangeFields(context),
      ),
    );
  }
}
