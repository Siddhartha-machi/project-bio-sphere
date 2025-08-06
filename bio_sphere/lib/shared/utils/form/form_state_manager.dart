import 'package:bio_sphere/shared/presentation/forms/base_form_field.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class FormStateManager {
  final Map<String, GenericFieldController> _fields = {};

  void register<T>(
    String name,
    BaseFormFieldState stateRef, {
    T? initialValue,
  }) {
    if (_fields.containsKey(name)) {
      throw Exception('Field with name $name is already registered.');
    }
    _fields[name] = GenericFieldController<T>(
      stateRef,
      initialValue: initialValue,
    );
  }

  void unregister<T>(String name) {
    if (_fields.containsKey(name)) _fields.remove(name);
  }

  bool isRegistered(String key) => _fields[key] != null;

  GenericFieldController<T>? field<T>(String key) {
    final controller = _fields[key];
    if (controller == null) return null;
    return controller as GenericFieldController<T>;
  }

  bool get isValid => _fields.values.every((f) => f.error == null);

  Map<String, dynamic> get values {
    return _fields.map((key, controller) => MapEntry(key, controller.value));
  }

  void validateAll<T>() {
    for (final controller in _fields.values) {
      controller.validate();
    }
  }

  void resetAll() {
    for (final controller in _fields.values) {
      controller.reset();
    }
  }

  void disposeAll() {
    for (final controller in _fields.values) {
      controller.dispose();
    }
    _fields.clear();
  }
}
