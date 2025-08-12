// Dart
import 'package:flutter_test/flutter_test.dart';

import 'package:bio_sphere/shared/utils/form/form_state_manager.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';
import 'package:bio_sphere/shared/utils/form/generic_field_controller.dart';

void main() {
  group('FormStateManager', () {
    late FormStateManager manager;
    late GenericFieldConfig<String> textConfig;
    late GenericFieldConfig<int> intConfig;

    setUp(() {
      manager = FormStateManager();
      textConfig = GenericFieldConfig<String>(
        name: 'username',
        type: GenericFieldType.text,
        label: 'Username',
        isRequired: true,
      );
      intConfig = GenericFieldConfig<int>(
        name: 'age',
        type: GenericFieldType.integer,
        label: 'Age',
        isRequired: false,
      );
    });

    test('FM_G1_T1 registers and retrieves a field', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      expect(manager.isRegistered('username'), isTrue);
      final field = manager.field<String>('username');
      expect(field, isNotNull);
      expect(field!.data, equals('abc'));
    });

    test('FM_G1_T2 throws when registering duplicate field', () {
      manager.register<String>(textConfig);
      expect(() => manager.register<String>(textConfig), throwsException);
    });

    test('FM_G2_T1 unregister removes field', () {
      manager.register<String>(textConfig);
      manager.unregister<String>('username');
      expect(manager.isRegistered('username'), isFalse);
      expect(manager.field<String>('username'), isNull);
    });

    test('FM_G2_T2 unregister does nothing for non-existent field', () {
      expect(manager.isRegistered('notfound'), isFalse);
      manager.unregister<String>('notfound');
      expect(manager.isRegistered('notfound'), isFalse);
    });

    test('FM_G3_T1 field returns null for non-existent field', () {
      expect(manager.field<String>('notfound'), isNull);
    });

    test('FM_G4_T1 isValid returns true when all fields valid', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.register<int>(intConfig, initialValue: 42);
      expect(manager.isValid, isTrue);
    });

    test('FM_G4_T2 isValid returns false when any field has error', () {
      manager.register<String>(textConfig, initialValue: '');
      manager.field<String>('username')!.validate();
      expect(manager.isValid, isFalse);
    });

    test('FM_G4_T3 error is cleared when valid value is set', () {
      manager.register<String>(textConfig, initialValue: '');
      final field = manager.field<String>('username')!;
      field.validate();
      expect(field.error, isNotNull); // Error present for empty value

      field.didChange('validUsername');
      field.validate();
      expect(field.error, isNull); // Error cleared for valid value
    });

    test('FM_G5_T1 values returns correct map', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.register<int>(intConfig, initialValue: 42);
      final values = manager.values;
      expect(values.keys, containsAll(['username', 'age']));
      expect((values['username'] as GenericFieldState).data, equals('abc'));
      expect((values['age'] as GenericFieldState).data, equals(42));
    });

    test('FM_G6_T1 validateAll sets errors', () {
      manager.register<String>(textConfig, initialValue: '');
      manager.register<String>(intConfig, initialValue: '10');
      manager.validateAll();
      expect(manager.field<String>('username')!.error, isNotNull);
      expect(manager.field<String>('age')!.error, isNull);
    });

    test('FM_G7_T1 resetAll resets field data', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.field<String>('username')!.didChange('changed');
      expect(manager.field<String>('username')!.data, equals('changed'));
      manager.resetAll();
      expect(manager.field<String>('username')!.data, equals('abc'));
    });

    test('FM_G8_T1 disposeAll clears all fields', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.register<int>(intConfig, initialValue: 42);
      manager.disposeAll();
      expect(manager.isRegistered('username'), isFalse);
      expect(manager.isRegistered('age'), isFalse);
      expect(manager.values, isEmpty);
    });

    test('FM_G9_T1 registers multiple types', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.register<int>(intConfig, initialValue: 42);
      expect(manager.field<String>('username'), isNotNull);
      expect(manager.field<int>('age'), isNotNull);
    });

    test('FM_G10_T1 validateAll after unregister does not throw', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.unregister<String>('username');
      expect(() => manager.validateAll(), returnsNormally);
    });

    test('FM_G10_T2 resetAll after unregister does not throw', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.unregister<String>('username');
      expect(() => manager.resetAll(), returnsNormally);
    });

    test('FM_G10_T3 validateAll after disposeAll does not throw', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.disposeAll();
      expect(() => manager.validateAll(), returnsNormally);
    });

    test('FM_G10_T4 resetAll after disposeAll does not throw', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.disposeAll();
      expect(() => manager.resetAll(), returnsNormally);
    });

    test('FM_G10_T5 disposeAll is idempotent', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.disposeAll();
      expect(() => manager.disposeAll(), returnsNormally);
    });

    test('FM_G11_T1 retrieving with wrong type throws', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      expect(() => manager.field<int>('username'), throwsA(isA<TypeError>()));
    });

    test('FM_G11_T2 unregister after dispose does not throw', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.disposeAll();
      expect(() => manager.unregister<String>('username'), returnsNormally);
    });

    test('FM_G11_T3 resetAll/validateAll with no fields does not throw', () {
      expect(() => manager.resetAll(), returnsNormally);
      expect(() => manager.validateAll(), returnsNormally);
    });

    test('FM_G11_T4 register after disposeAll works', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      manager.disposeAll();
      expect(manager.isRegistered('username'), isFalse);
      manager.register<String>(textConfig, initialValue: 'new');
      expect(manager.isRegistered('username'), isTrue);
    });

    test('FM_G11_T5 register with null initial value', () {
      manager.register<String>(textConfig);
      expect(manager.field<String>('username')!.data, isNull);
      manager.resetAll();
      expect(manager.field<String>('username')!.data, isNull);
    });

    test('FM_G11_T6 registering same name with different type throws', () {
      manager.register<String>(textConfig, initialValue: 'abc');
      final intConfigSameName = GenericFieldConfig<int>(
        name: 'username',
        type: GenericFieldType.integer,
        label: 'Username',
      );
      expect(() => manager.register<int>(intConfigSameName, initialValue: 1), throwsException);
    });
  });
}
