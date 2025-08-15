import 'package:flutter/foundation.dart';

import 'package:bio_sphere/services/form_validation_service.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';

class GenericFieldState<T> {
  final T? data;
  final bool touched;
  final String? error;

  const GenericFieldState({this.data, this.touched = false, this.error});

  static const _undefined = Object();

  GenericFieldState<T> copyWith({
    bool? touched,
    Object? data = _undefined,
    Object? error = _undefined,
  }) {
    return GenericFieldState<T>(
      touched: touched ?? this.touched,
      data: data == _undefined ? this.data : data as T?,
      error: error == _undefined ? this.error : error as String?,
    );
  }

  @override
  String toString() =>
      'GenericFieldState(value: $data, touched: $touched, error: $error)';
}

class GenericFieldController<T> extends ValueNotifier<GenericFieldState<T>> {
  final T? initialValue;
  final GenericFieldConfig config;

  GenericFieldController(this.config, {this.initialValue})
    : super(GenericFieldState<T>(data: initialValue));

  T? get data => value.data;
  String? get error => value.error;

  bool isValid() {
    /// If the field is required, then it should have a value and no error.
    if (config.isRequired) {
      return value.error == null && value.data != null;
    }

    return value.error == null;
  }

  bool isDirty() => value.touched && initialValue != data;

  void didChange(T? newValue) {
    if (value.data != newValue) {
      value = value.copyWith(data: newValue, touched: true);
    }
  }

  /// Returns true if field is valid
  bool validate() {
    String? validateResult;

    switch (config.type) {
      case GenericFieldType.text:
      case GenericFieldType.password:
        final validator = FormValidationService.stringValidator(config);
        validateResult = validator(data as String?);
      case GenericFieldType.email:
        final validator = FormValidationService.emailValidator(config);
        validateResult = validator(data as String?);
      case GenericFieldType.integer:
        final validator = FormValidationService.intValidator(config);
        validateResult = validator(data as String?);
      case GenericFieldType.double:
        final validator = FormValidationService.numValidator(config);
        validateResult = validator(data as String?);

      /// Date and time validations
      case GenericFieldType.dateTime:
        final validator = FormValidationService.dateTimeValidator(config);
        validateResult = validator(data as DateTime?);
        break;
      case GenericFieldType.date:
        final validator = FormValidationService.dateFieldValidator(config);
        validateResult = validator(data as DateTime?);
        break;
      case GenericFieldType.time:
        final validator = FormValidationService.timeFieldValidator(config);
        validateResult = validator(data as DateTime?);
        break;
      case GenericFieldType.select:
      case GenericFieldType.dropdown:
        final validator = FormValidationService.dropdownFieldValidator(config);
        validateResult = validator(data as GenericFieldOption?);
        break;
      case GenericFieldType.checkbox:
        final validator = FormValidationService.checkFieldValidator(config);
        validateResult = validator(data as bool?);
        break;
      case GenericFieldType.radio:
        final validator = FormValidationService.radioFieldValidator(config);
        validateResult = validator(data as GenericFieldOption?);
        break;

      default:
        validateResult = null;
    }

    if (validateResult != value.error) {
      value = value.copyWith(error: validateResult);
    }

    return validateResult == null;
  }

  void reset() {
    value = GenericFieldState<T>(data: initialValue);
  }
}
