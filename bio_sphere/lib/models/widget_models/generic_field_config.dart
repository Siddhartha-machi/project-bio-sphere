enum GenericFieldType {
  /// Text fields
  text,
  integer,
  double,
  email,
  password,

  /// Option choosers
  checkbox,
  radio,
  dropdown,
  select,

  /// Date time
  date,
  time,
  dateTime,

  /// Advanced
  url,
  file,
  objectList,
  multiSelect,

  /// Misc
  freeRange,
  fixedRange,

  /// Feedback
  rating,
}

class GenericFieldConfig<T> {
  final String name;
  final GenericFieldType type;

  // Optional attributes
  final String? label;
  final double? size;
  final double? gap;
  final String? group;
  final bool halfWidth;
  final T? defaultValue;
  final int? prefixIcon;
  final int? suffixIcon;
  final String? hintText;
  final String? helperText;
  final dynamic showIfValue;
  final Map<String, dynamic> extra;
  final List<GenericFieldOption>? options; // For dropdown, radio, etc.
  final Map<String, dynamic>? dependencies;

  // Validation attributes
  final int? min;
  final int? max;
  final int rows;
  final int? minLength;
  final int? maxLength;
  final bool isRequired;

  GenericFieldConfig({
    this.max,
    this.min,
    this.size,
    this.gap,
    this.label,
    this.group,
    this.hintText,
    this.options,
    this.minLength,
    this.maxLength,
    this.rows = 1,
    this.helperText,
    this.prefixIcon,
    this.suffixIcon,
    this.showIfValue,
    this.defaultValue,
    this.dependencies,
    required this.name,
    required this.type,
    this.extra = const {},
    this.halfWidth = false,
    this.isRequired = false,
  });
}

class GenericFieldOption {
  const GenericFieldOption({
    this.iconConfig,
    this.description,
    required this.value,
    required this.label,
  });

  final String value;
  final String label;
  final int? iconConfig;
  final String? description;
}
