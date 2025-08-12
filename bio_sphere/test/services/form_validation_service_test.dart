import 'package:flutter_test/flutter_test.dart';
import 'package:bio_sphere/services/form_validation_service.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';

void main() {
  group('FormValidationService', () {
    // --- Text ---
    final requiredTextConfig = GenericFieldConfig<String>(
      name: 'username',
      type: GenericFieldType.text,
      label: 'Username',
      isRequired: true,
      minLength: 3,
      maxLength: 5,
    );
    final optionalTextConfig = GenericFieldConfig<String>(
      name: 'nickname',
      type: GenericFieldType.text,
      label: 'Nickname',
      isRequired: false,
    );

    // --- Integer ---
    final requiredIntConfig = GenericFieldConfig<int>(
      name: 'age',
      type: GenericFieldType.integer,
      label: 'Age',
      isRequired: true,
      min: 18,
      max: 99,
    );

    // --- Double ---
    final requiredDoubleConfig = GenericFieldConfig<double>(
      name: 'score',
      type: GenericFieldType.double,
      label: 'Score',
      isRequired: true,
      min: 0,
      max: 100,
    );

    // --- Email ---
    final requiredEmailConfig = GenericFieldConfig<String>(
      name: 'email',
      type: GenericFieldType.email,
      label: 'Email',
      isRequired: true,
    );

    // --- Password ---
    final requiredPasswordConfig = GenericFieldConfig<String>(
      name: 'password',
      type: GenericFieldType.password,
      label: 'Password',
      isRequired: true,
      minLength: 6,
    );

    // --- Checkbox ---
    final requiredBoolConfig = GenericFieldConfig<bool>(
      name: 'accept',
      type: GenericFieldType.checkbox,
      label: 'Accept',
      isRequired: true,
    );

    // --- Dropdown ---
    final requiredDropdownConfig = GenericFieldConfig<GenericFieldOption>(
      name: 'dropdown',
      type: GenericFieldType.dropdown,
      label: 'Dropdown',
      isRequired: true,
      options: [GenericFieldOption(value: '1', label: 'One')],
    );

    // --- Radio ---
    final requiredRadioConfig = GenericFieldConfig<GenericFieldOption>(
      name: 'radio',
      type: GenericFieldType.radio,
      label: 'Radio',
      isRequired: true,
      options: [GenericFieldOption(value: '1', label: 'One')],
    );

    // --- Select ---
    final requiredSelectConfig = GenericFieldConfig<GenericFieldOption>(
      name: 'select',
      type: GenericFieldType.select,
      label: 'Select',
      isRequired: true,
      options: [GenericFieldOption(value: '1', label: 'One')],
    );

    // --- Date ---
    final requiredDateConfig = GenericFieldConfig<DateTime>(
      name: 'date',
      type: GenericFieldType.date,
      label: 'Date',
      isRequired: true,
    );

    // --- Time ---
    final requiredTimeConfig = GenericFieldConfig<DateTime>(
      name: 'time',
      type: GenericFieldType.time,
      label: 'Time',
      isRequired: true,
    );

    // --- DateTime ---
    final requiredDateTimeConfig = GenericFieldConfig<DateTime>(
      name: 'datetime',
      type: GenericFieldType.dateTime,
      label: 'DateTime',
      isRequired: true,
    );

    // --- File ---
    final requiredFileConfig = GenericFieldConfig<String>(
      name: 'file',
      type: GenericFieldType.file,
      label: 'File',
      isRequired: true,
    );

    // --- Rating ---
    final requiredRatingConfig = GenericFieldConfig<int>(
      name: 'rating',
      type: GenericFieldType.rating,
      label: 'Rating',
      isRequired: true,
      min: 1,
      max: 5,
    );

    // --- TEXT ---
    test('FMVS_G1_T1 stringValidator required/min/max', () {
      final validator = FormValidationService.stringValidator(
        requiredTextConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator(''), isNotNull);
      expect(validator('ab'), isNotNull); // too short
      expect(validator('abcdef'), isNotNull); // too long
      expect(validator('abc'), isNull); // valid
      expect(validator('abcd'), isNull); // valid
      expect(validator('abcde'), isNull); // valid
    });

    test('FMVS_G1_T2 stringValidator optional', () {
      final validator = FormValidationService.stringValidator(
        optionalTextConfig,
      );
      expect(validator(null), isNull);
      expect(validator(''), isNull);
      expect(validator('abc'), isNull);
    });

    // --- INTEGER ---
    test('FMVS_G2_T1 intValidator required/min/max', () {
      final validator = FormValidationService.intValidator(requiredIntConfig);
      expect(validator(null), isNotNull);
      expect(validator('17'), isNotNull); // too small
      expect(validator('100'), isNotNull); // too large
      expect(validator('50'), isNull); // valid
      expect(validator('abc'), isNotNull); // not a number
    });

    // --- DOUBLE ---
    test('FMVS_G3_T1 numValidator required/min/max', () {
      final validator = FormValidationService.numValidator(
        requiredDoubleConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator('-1'), isNotNull); // too small
      expect(validator('101'), isNotNull); // too large
      expect(validator('50'), isNull); // valid
      expect(validator('abc'), isNotNull); // not a number
    });

    // --- EMAIL ---
    test('FMVS_G4_T1 emailValidator', () {
      final validator = FormValidationService.emailValidator(
        requiredEmailConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator('not-an-email'), isNotNull);
      expect(validator('test@example.com'), isNull);
    });

    // --- PASSWORD ---
    test('FMVS_G5_T1 passwordValidator', () {
      final validator = FormValidationService.stringValidator(
        requiredPasswordConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator('123'), isNotNull); // too short
      expect(validator('123456'), isNull); // valid
    });

    // --- CHECKBOX ---
    test('FMVS_G6_T1 checkFieldValidator', () {
      final validator = FormValidationService.checkFieldValidator(
        requiredBoolConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator(false), isNotNull);
      expect(validator(true), isNull);
    });

    // --- DROPDOWN ---
    test('FMVS_G7_T1 dropdownFieldValidator', () {
      final validator = FormValidationService.dropdownFieldValidator(
        requiredDropdownConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator(GenericFieldOption(value: '1', label: 'One')), isNull);
    });

    // --- RADIO ---
    test('FMVS_G8_T1 radioFieldValidator', () {
      final validator = FormValidationService.radioFieldValidator(
        requiredRadioConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator(GenericFieldOption(value: '1', label: 'One')), isNull);
    });

    // --- SELECT ---
    test('FMVS_G9_T1 selectFieldValidator', () {
      final validator = FormValidationService.dropdownFieldValidator(
        requiredSelectConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator(GenericFieldOption(value: '1', label: 'One')), isNull);
    });

    // --- DATE ---
    test('FMVS_G10_T1 dateFieldValidator', () {
      final validator = FormValidationService.dateFieldValidator(
        requiredDateConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator(DateTime(2020, 1, 1)), isNull);
    });

    // --- TIME ---
    test('FMVS_G11_T1 timeFieldValidator', () {
      final validator = FormValidationService.timeFieldValidator(
        requiredTimeConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator(DateTime(2020, 1, 1, 12, 30)), isNull);
    });

    // --- DATETIME ---
    test('FMVS_G12_T1 dateTimeValidator', () {
      final validator = FormValidationService.dateTimeValidator(
        requiredDateTimeConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator(DateTime.now()), isNull);
    });

    // --- FILE ---
    test('FMVS_G13_T1 fileValidator (stringValidator)', () {
      final validator = FormValidationService.stringValidator(
        requiredFileConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator(''), isNotNull);
      expect(validator('file.pdf'), isNull);
    });

    // --- RATING ---
    test('FMVS_G14_T1 ratingValidator (intValidator)', () {
      final validator = FormValidationService.intValidator(
        requiredRatingConfig,
      );
      expect(validator(null), isNotNull);
      expect(validator('0'), isNotNull); // too small
      expect(validator('6'), isNotNull); // too large
      expect(validator('3'), isNull); // valid
    });

    // --- EDGE CASES ---
    test('FMVS_G15_T1 dropdownFieldValidator with no options', () {
      final config = GenericFieldConfig<GenericFieldOption>(
        name: 'dropdown2',
        type: GenericFieldType.dropdown,
        label: 'Dropdown2',
        isRequired: true,
      );
      final validator = FormValidationService.dropdownFieldValidator(config);
      expect(validator(null), isNotNull);
    });

    test('FMVS_G15_T2 radioFieldValidator with no options', () {
      final config = GenericFieldConfig<GenericFieldOption>(
        name: 'radio2',
        type: GenericFieldType.radio,
        label: 'Radio2',
        isRequired: true,
      );
      final validator = FormValidationService.radioFieldValidator(config);
      expect(validator(null), isNotNull);
    });

    test('FMVS_G15_T3 selectFieldValidator with no options', () {
      final config = GenericFieldConfig<GenericFieldOption>(
        name: 'select2',
        type: GenericFieldType.select,
        label: 'Select2',
        isRequired: true,
      );
      final validator = FormValidationService.dropdownFieldValidator(config);
      expect(validator(null), isNotNull);
    });
  });
}
