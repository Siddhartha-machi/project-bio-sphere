import 'package:bio_sphere/models/widget_models/generic_field_config.dart';

class FieldMeta {
  const FieldMeta({
    this.extra,
    this.locale = 'en_IN',
    this.currencyCode = 'INR',
    this.timePattern = 'HH:mm:ss',
    this.datePattern = 'yyyy-MM-dd',
    this.dateTimePattern = 'yyyy-MM-dd HH:mm:ss',
  });

  final String? locale;
  final String? datePattern;
  final String? timePattern;
  final String? currencyCode;
  final String? dateTimePattern;
  final Map<String, dynamic>? extra; // extensibility hook
}

/// Context passed to coercers (data type + meta and locale).
class CoercionContext {
  const CoercionContext({required this.type, this.meta = const FieldMeta()});

  final FieldMeta meta;
  final GenericFieldType type;
}
