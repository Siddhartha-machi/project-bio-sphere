import 'package:bio_sphere/models/data/attachment.dart';
import 'package:bio_sphere/shared/presentation/text/text_ui.dart';
import 'package:bio_sphere/shared/utils/adapters/field_meta.dart';
import 'package:bio_sphere/shared/utils/adapters/value_coercers.dart';
import 'package:bio_sphere/shared/utils/form/field_wrap.dart';
import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';
import 'package:bio_sphere/shared/utils/form/form_field_definition.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_file_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_text_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_rating_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_select_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_checkbox_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_radiobox_field.dart';
import 'package:bio_sphere/shared/presentation/forms/custom_date_time_field.dart';

/// External registration plugin class
/// to register fields and build definitions form config.
class FormRegistrationManager {
  final FormStateManager formManager;
  final Map<String, dynamic> initialValues;
  final List<GenericFieldConfig> configList;

  const FormRegistrationManager({
    required this.configList,
    required this.formManager,
    this.initialValues = const {},
  });

  /// Only register fields with the state manager.
  void registerForm() {
    final coercer = ValueCoercer.withDefaults();

    for (final config in configList) {
      dynamic initialValue = initialValues[config.name];

      if (initialValue != null) {
        initialValue = coercer.coerce(
          initialValue,
          CoercionContext(
            type: config.type,
            meta: FieldMeta(extra: {'config': config}),
          ),
        );
      }

      _registerFieldByType(formManager, config, initialValue);
    }

    formManager.setRegistrationComplete();
  }

  /// Builds fields definition objects from config.
  Map<String, FormFieldDefinition> buildFieldDefinitions() {
    final Map<String, FormFieldDefinition> definitions = {};

    for (final config in configList) {
      definitions[config.name] = _buildFieldByType(config);
    }

    return definitions;
  }

  _registerFieldByType(
    FormStateManager formManager,
    GenericFieldConfig config,
    dynamic initialValue,
  ) {
    switch (config.type) {
      case GenericFieldType.text:
      case GenericFieldType.email:
      case GenericFieldType.double:
      case GenericFieldType.integer:
      case GenericFieldType.password:
        formManager.register<String>(
          config,
          initialValue: initialValue?.toString(),
        );

      case GenericFieldType.date:
      case GenericFieldType.time:
      case GenericFieldType.dateTime:
        DateTime? value;
        if (initialValue is String) value = DateTime.parse(initialValue);
        formManager.register<DateTime>(config, initialValue: value);

      case GenericFieldType.checkbox:
        formManager.register<bool>(config, initialValue: initialValue);

      case GenericFieldType.dropdown:
      case GenericFieldType.select:
        formManager.register<GenericFieldOption>(
          config,
          initialValue: initialValue,
        );

      case GenericFieldType.radio:
        formManager.register<GenericFieldOption>(
          config,
          initialValue: initialValue,
        );

      case GenericFieldType.rating:
        formManager.register<int>(config, initialValue: initialValue);

      case GenericFieldType.file:
        formManager.register<List<Attachment>>(
          config,
          initialValue: initialValue,
        );
      default:
        throw Exception('Unsupported type provided.');
    }
  }

  FormFieldDefinition _buildFieldByType(GenericFieldConfig config) {
    switch (config.type) {
      case GenericFieldType.text:
      case GenericFieldType.email:
      case GenericFieldType.double:
      case GenericFieldType.integer:
      case GenericFieldType.password:
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
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<DateTime>(
            withWrapper: true,
            config: fieldConfig,
            builder: (controller) => CustomDateTimeField(controller),
          ),
        );

      case GenericFieldType.checkbox:
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<bool>(
            config: fieldConfig,
            builder: (controller) => CustomCheckboxField(controller),
          ),
        );

      case GenericFieldType.select:
      case GenericFieldType.dropdown:
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<GenericFieldOption>(
            withWrapper: true,
            config: fieldConfig,
            builder: (controller) => CustomSelectField(controller),
          ),
        );

      case GenericFieldType.radio:
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<GenericFieldOption>(
            config: fieldConfig,
            builder: (controller) => CustomRadioboxField(controller),
          ),
        );

      case GenericFieldType.rating:
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<int>(
            config: fieldConfig,
            builder: (controller) => CustomRatingField(controller),
          ),
        );

      case GenericFieldType.file:
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<List<Attachment>>(
            config: fieldConfig,
            builder: (controller) => CustomFileField(controller),
          ),
        );
      case GenericFieldType.url:
        return FormFieldDefinition(
          builder: (fieldConfig) => FieldWrap<Uri>(
            config: fieldConfig,
            builder: (controller) => TextUI('URL field'),
          ),
        );
      default:
        throw Exception('Unsupported type ${config.type.name} provided.');
    }
  }
}
