import 'package:flutter/foundation.dart';

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
  final GenericFieldConfig config;

  GenericFieldController(this.config, {T? initialValue})
    : super(GenericFieldState<T>(data: initialValue));

  T? get data => value.data;
  String? get error => value.error;
  bool get isTouched => value.touched;

  void didChange(T? newValue) {
    if (value.data != newValue) {
      value = value.copyWith(data: newValue, touched: true);
    }
  }

  void validate() {
    if (data == null) {
      value = value.copyWith(error: 'Field is required.');
    }
    // final validateResult = stateRef.validate(data);
    // if (validateResult != value.error) {
    //   value = value.copyWith(error: validateResult);
    // }
  }

  void reset() {
    // final resetValue = stateRef.reset();
    // value = GenericFieldState<T>(data: resetValue);
  }
}
