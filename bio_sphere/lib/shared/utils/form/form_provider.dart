import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/models/data/attachment.dart';
import 'package:bio_sphere/shared/utils/form/field_wrap.dart';
import 'package:bio_sphere/shared/utils/form/form_scope.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';
import 'package:bio_sphere/shared/utils/form/form_field_definition.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_file_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_text_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_select_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_rating_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_checkbox_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_radiobox_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_date_time_field.dart';

class FormProvider extends StatefulWidget {
  final bool useGrouping;
  final double colSpacing;
  final Map<String, dynamic> initialValues;
  final List<GenericFieldConfig> configList;

  const FormProvider({
    super.key,
    this.colSpacing = 12.0,
    required this.configList,
    this.useGrouping = false,
    this.initialValues = const {},
  });

  @override
  State<FormProvider> createState() => FormProviderState();

  static FormStateManager of(BuildContext context) => FormScope.of(context);
}

class FormProviderState extends State<FormProvider> {
  late final FormStateManager formManager;
  late final Map<String, FormFieldDefinition> _map;

  static const String _defaultKey = '##---##';

  /// ----------- Life cycle methods ---------------- ///
  @override
  void initState() {
    super.initState();
    formManager = FormStateManager();
    _map = {};

    for (final config in widget.configList) {
      final initialValue = widget.initialValues[config.name];
      _map[config.name] = _registerAndBuildFieldByType(config, initialValue);
    }
  }

  @override
  void dispose() {
    formManager.disposeAll();
    super.dispose();
  }

  /// ----------- State Utility ---------------- ///

  FormFieldDefinition _registerAndBuildFieldByType(
    GenericFieldConfig config,
    dynamic initialValue,
  ) {
    switch (config.type) {
      case GenericFieldType.text:
      case GenericFieldType.email:
      case GenericFieldType.double:
      case GenericFieldType.integer:
      case GenericFieldType.password:
        formManager.register<String>(config, initialValue: initialValue);
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<String>(
            withFocus: true,
            withWrapper: true,
            config: fieldConfig,
            builder: (controller) => CustomTextField(controller),
          ),
        );
      case GenericFieldType.date:
      case GenericFieldType.time:
      case GenericFieldType.dateTime:
        formManager.register<DateTime>(config, initialValue: initialValue);
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<DateTime>(
            withWrapper: true,
            config: fieldConfig,
            builder: (controller) => CustomDateTimeField(controller),
          ),
        );
      case GenericFieldType.checkbox:
        formManager.register<bool>(config, initialValue: initialValue);
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<bool>(
            config: fieldConfig,
            builder: (controller) => CustomCheckboxField(controller),
          ),
        );
      case GenericFieldType.dropdown:
      case GenericFieldType.select:
        formManager.register<GenericFieldOption>(
          config,
          initialValue: initialValue,
        );
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<GenericFieldOption>(
            withWrapper: true,
            config: fieldConfig,
            builder: (controller) => CustomSelectField(controller),
          ),
        );
      case GenericFieldType.radio:
        formManager.register<GenericFieldOption>(
          config,
          initialValue: initialValue,
        );
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<GenericFieldOption>(
            config: fieldConfig,
            builder: (controller) => CustomRadioboxField(controller),
          ),
        );
      case GenericFieldType.rating:
        formManager.register<int>(config, initialValue: initialValue);
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<int>(
            config: fieldConfig,
            builder: (controller) => CustomRatingField(controller),
          ),
        );
      case GenericFieldType.file:
        formManager.register<List<Attachment>>(
          config,
          initialValue: initialValue,
        );
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<List<Attachment>>(
            config: fieldConfig,
            builder: (controller) => CustomFileField(controller),
          ),
        );
    }
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

  List<Widget> _arrangeFields() {
    List<Widget> children = [];
    final groupedMap = _convertToGroups();
    final rowSpacing = 10.sp;

    for (final key in groupedMap.keys) {
      List<Widget> rowGroup = [];
      final List<Widget> widgetGroup = [];

      final List<GenericFieldConfig> groupedList = groupedMap[key]!;

      for (int i = 0; i < groupedList.length; i++) {
        final fieldConfig = groupedList[i];
        final widget = _map[fieldConfig.name]!.builder(fieldConfig);

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
        children.add(TextUI(key));
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
    return FormScope(
      formManager: formManager,
      child: Column(
        spacing: 12.sp,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _arrangeFields(),
      ),
    );
  }
}
