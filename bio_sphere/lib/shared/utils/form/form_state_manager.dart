import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

class FormStateManager {
  bool _isRegistrationClosed = false;
  final Map<String, GenericFieldController> _fields = {};

  void register<T>(GenericFieldConfig config, {T? initialValue}) {
    if (_isRegistrationClosed) return;

    if (_fields.containsKey(config.name)) {
      throw Exception('Field with name ${config.name} is already registered.');
    }
    _fields[config.name] = GenericFieldController<T>(
      config,
      initialValue: initialValue,
    );
  }

  bool isRegistrationComplete() => _isRegistrationClosed;
  
  void setRegistrationComplete() => _isRegistrationClosed = true;

  void unregister<T>(String name) {
    if (_fields.containsKey(name)) _fields.remove(name);
  }

  bool isRegistered(String key) => _fields[key] != null;

  GenericFieldController<T>? field<T>(String key) {
    final controller = _fields[key];
    if (controller == null) return null;
    return controller as GenericFieldController<T>;
  }

  Map<String, dynamic> get values {
    return _fields.map((key, controller) => MapEntry(key, controller.value));
  }

  bool isValid() {
    bool isValid = true;

    for (final field in _fields.values) {
      isValid = isValid && field.isValid();
    }

    return isValid;
  }

  bool validateAll<T>() {
    for (final controller in _fields.values) {
      final isValid = controller.validate();
      if (!isValid) return false;
    }

    return true;
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
