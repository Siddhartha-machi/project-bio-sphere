import 'package:intl/intl.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:bio_sphere/shared/utils/global.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';

typedef Validator<T> = String? Function(T?);

/// Service for generating validators for form fields based on their config.
class FormValidationService {
  /// Checks if a value is empty, considering its type.
  static bool _typeAwareEmptyCheck(dynamic value) {
    if (value == null) return true;

    if (value is DateTime) return false;

    if (value is bool) return !value;

    return Global.isEmpty(value);
  }

  /// Composes required and custom validators for a field.
  static Validator<T> _requiredValidator<T>(
    GenericFieldConfig field,
    List<Validator<T>> vLst, {
    String? customErr,
  }) {
    // Use custom error if provided, else default to field label.
    customErr ??= '${field.label ?? 'field'} is required.';

    // If field is not required, only apply validators if not empty.
    if (field.isRequired != true) {
      return (value) {
        if (!_typeAwareEmptyCheck(value)) {
          final validator = FormBuilderValidators.compose<T>(vLst);
          return validator(value);
        }
        return null;
      };
    }

    // If required, add required validator and custom validators.
    return FormBuilderValidators.compose<T>([
      FormBuilderValidators.required(errorText: customErr),
      ...vLst,
    ]);
  }

  /// -------------- String Validators -------------- ///

  static Validator<String> emailValidator(GenericFieldConfig field) {
    final validators = <Validator<String>>[FormBuilderValidators.email()];

    return _requiredValidator(field, validators);
  }

  /// Validator for string fields.
  static Validator<String> stringValidator(GenericFieldConfig field) {
    final validators = <Validator<String>>[];
    if (field.minLength != null) {
      validators.add(FormBuilderValidators.minLength(field.minLength!));
    }
    if (field.maxLength != null) {
      validators.add(FormBuilderValidators.maxLength(field.maxLength!));
    }
    return _requiredValidator<String>(field, validators);
  }

  /// Validator for integer fields.
  static Validator<String> intValidator(GenericFieldConfig field) {
    final validators = <Validator<String>>[FormBuilderValidators.integer()];
    if (field.min != null) {
      validators.add(FormBuilderValidators.min(field.min!));
    }
    if (field.max != null) {
      validators.add(FormBuilderValidators.max(field.max!));
    }
    return _requiredValidator<String>(field, validators);
  }

  /// Validator for floating point number fields.
  static Validator<String> numValidator(GenericFieldConfig field) {
    final validators = <Validator<String>>[FormBuilderValidators.numeric()];
    if (field.min != null) {
      validators.add(FormBuilderValidators.min(field.min!));
    }
    if (field.max != null) {
      validators.add(FormBuilderValidators.max(field.max!));
    }
    return _requiredValidator<String>(field, validators);
  }

  /// -------------- Boolean Validators -------------- ///

  static Validator<bool> checkFieldValidator(GenericFieldConfig field) {
    final validators = <Validator<bool>>[FormBuilderValidators.isTrue()];
    return _requiredValidator<bool>(
      field,
      validators,
      customErr: "You need to check this box.",
    );
  }

  /// -------------- Object Validators -------------- ///

  static Validator<GenericFieldOption> dropdownFieldValidator(
    GenericFieldConfig field,
  ) {
    final validators = <Validator<GenericFieldOption>>[];
    return _requiredValidator<GenericFieldOption>(field, validators);
  }

  static Validator<GenericFieldOption> radioFieldValidator(
    GenericFieldConfig field,
  ) {
    final validators = <Validator<GenericFieldOption>>[];
    return _requiredValidator<GenericFieldOption>(
      field,
      validators,
      customErr: "Select one of the options below.",
    );
  }

  /// -------------- Data and Time Validators -------------- ///

  static Validator<DateTime> dateTimeValidator(GenericFieldConfig field) {
    final validators = <Validator<DateTime>>[FormBuilderValidators.dateTime()];
    return _requiredValidator<DateTime>(field, validators);
  }

  static Validator<DateTime> dateFieldValidator(GenericFieldConfig field) {
    final validators = <Validator<String>>[FormBuilderValidators.date()];
    final validator = _requiredValidator<String>(field, validators);

    return (DateTime? dateTime) =>
        _dateTimevalidatorWrapper(dateTime, validator, false);
  }

  static Validator<DateTime> timeFieldValidator(GenericFieldConfig field) {
    final validators = <Validator<String>>[FormBuilderValidators.time()];

    final validator = _requiredValidator<String>(field, validators);

    return (DateTime? dateTime) =>
        _dateTimevalidatorWrapper(dateTime, validator, true);
  }

  static String? _dateTimevalidatorWrapper(
    DateTime? dateTime,
    Validator<String> validator,
    bool isTime,
  ) {
    if (isTime) {
      final formattedTime = dateTime == null
          ? null
          : DateFormat('hh:mm a').format(dateTime);
      return validator(formattedTime);
    }
    return validator(dateTime?.toIso8601String());
  }
}
