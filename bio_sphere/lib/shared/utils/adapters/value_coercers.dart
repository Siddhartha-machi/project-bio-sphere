import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:bio_sphere/models/data/attachment.dart';
import 'package:bio_sphere/shared/utils/adapters/field_meta.dart';
import 'package:bio_sphere/models/widget_models/generic_field_config.dart';

/// ---------- Value coercion subsystem ----------

/// Signature for coercion functions: receives field config & raw value -> returns coerced value.
typedef CoercionFn = dynamic Function(dynamic raw, CoercionContext ctx);

/// Converts raw values to canonical runtime values appropriate for a field type.
/// - Thread-safe: immutable public API.
/// - Pure functions: coercers should not mutate input state.

class ValueCoercer {
  final CoercionFn _fallback;
  final Map<GenericFieldType, CoercionFn> _coercers;

  ValueCoercer._(this._coercers, this._fallback);

  /// Default coercer with sensible built-ins.
  factory ValueCoercer.withDefaults() {
    final map = <GenericFieldType, CoercionFn>{
      GenericFieldType.text: _toString,
      GenericFieldType.integer: _toInt,
      GenericFieldType.double: _toDouble,
      GenericFieldType.email: _toString,
      GenericFieldType.password: _identity,

      GenericFieldType.checkbox: _toBool,
      GenericFieldType.radio: _toOption,
      GenericFieldType.dropdown: _toOption,
      GenericFieldType.select: _toOption,

      GenericFieldType.time: _toTimeOfDay,
      GenericFieldType.date: _toDateTimeLoose,
      GenericFieldType.dateTime: _toDateTimeLoose,

      GenericFieldType.url: _toUri,
      GenericFieldType.file: _toAttachments,
      GenericFieldType.objectList: _identity,

      GenericFieldType.rating: _toDouble,
    };

    return ValueCoercer._(map, _identity);
  }

  /// Coerce raw value for the given context.
  dynamic coerce(dynamic raw, CoercionContext ctx) {
    final fn = _coercers[ctx.type] ?? _fallback;
    try {
      return fn(raw, ctx);
    } catch (_) {
      return raw; // fail-safe: return as-is
    }
  }

  // -------- Built-in coercers (static) --------

  static dynamic _identity(dynamic raw, CoercionContext ctx) => raw;

  static dynamic _toString(dynamic raw, CoercionContext ctx) {
    if (raw == null) return null;

    if (raw is String) return raw;

    if (raw is num || raw is bool) return raw.toString();

    return raw.toString();
  }

  static dynamic _toInt(dynamic raw, CoercionContext ctx) {
    if (raw == null) return null;

    if (raw is int) return raw;

    if (raw is num) return raw.toInt();

    if (raw is String) return int.tryParse(raw.trim());

    return null;
  }

  static dynamic _toDouble(dynamic raw, CoercionContext ctx) {
    if (raw == null) return null;

    if (raw is double) return raw;

    if (raw is num) return raw.toDouble();

    if (raw is String) return double.tryParse(raw.trim());

    return null;
  }

  static dynamic _toBool(dynamic raw, CoercionContext ctx) {
    if (raw == null) return null;

    if (raw is bool) return raw;

    if (raw is num) return raw != 0;

    if (raw is String) {
      final s = raw.trim().toLowerCase();
      if (s == 'true' || s == '1' || s == 'yes' || s == 'y') return true;
      if (s == 'false' || s == '0' || s == 'no' || s == 'n') return false;
    }

    return null;
  }

  static DateTime? _toDateTimeLoose(dynamic raw, CoercionContext ctx) {
    if (raw == null) return null;

    if (raw is DateTime) return raw;

    if (raw is String) {
      try {
        return DateTime.parse(raw);
      } catch (_) {}

      final p = (ctx.type == GenericFieldType.date)
          ? ctx.meta.datePattern
          : ctx.meta.dateTimePattern;

      if (p != null) {
        try {
          return DateFormat(p).parseLoose(raw);
        } catch (_) {}
      }

      /// Try a couple of common fallbacks
      for (final pat in const [
        'y-MM-dd',
        'y/M/d',
        'd/M/y',
        'M/d/y H:m',
        'y-MM-dd HH:mm',
      ]) {
        try {
          return DateFormat(pat).parseLoose(raw);
        } catch (_) {}
      }
    }
    return null;
  }

  static DateTime? _toTimeOfDay(dynamic raw, CoercionContext ctx) {
    if (raw == null) return null;

    if (raw is DateTime) return raw;

    if (raw is TimeOfDay) {
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, raw.hour, raw.minute);
    }

    if (raw is String) {
      final parts = raw.split(':');
      if (parts.length >= 2) {
        final h = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        if (h != null && m != null) {
          final now = DateTime.now();
          return DateTime(now.year, now.month, now.day, h, m);
        }
      }

      /// Try parsing as DateTime string
      try {
        return DateTime.parse(raw);
      } catch (_) {}
    }

    if (raw is Map) {
      final h = _safeInt(raw['hour']);
      final m = _safeInt(raw['minute']);
      if (h != null && m != null) {
        final now = DateTime.now();
        return DateTime(now.year, now.month, now.day, h, m);
      }
    }

    return null;
  }

  static Uri? _toUri(dynamic raw, CoercionContext ctx) {
    if (raw == null) return null;

    final s = raw.toString().trim();

    if (s.isEmpty) return null;

    try {
      return Uri.parse(s);
    } catch (_) {
      return null;
    }
  }

  static int? _safeInt(dynamic v) {
    if (v is int) return v;

    if (v is num) return v.toInt();

    if (v is String) return int.tryParse(v);

    return null;
  }

  static List<Attachment> _toAttachments(dynamic raw, CoercionContext ctx) {
    if (raw is Map<String, dynamic>) {
      return [Attachment.fromJson(raw)];
    }

    if (raw is List<Map<String, dynamic>>) {
      return List.generate(
        raw.length,
        (index) => Attachment.fromJson(raw[index]),
      );
    }

    return [];
  }

  static GenericFieldOption? _toOption(dynamic raw, CoercionContext ctx) {
    final GenericFieldConfig? config = ctx.meta.extra?['config'];

    if (raw == null) return null;

    if (config == null) {
      throw Exception(
        'Config with options should be passed in CoercionContext.meta.extra',
      );
    }

    if (config.options == null || config.options!.isEmpty) return null;

    return config.options!
        .where((option) => option.value == raw)
        .cast<GenericFieldOption>()
        .firstOrNull;
  }
}
