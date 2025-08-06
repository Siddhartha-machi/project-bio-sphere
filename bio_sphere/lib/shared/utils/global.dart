// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';

import 'package:bio_sphere/shared/presentation/ui_feedback/in_app_feedback.dart';

/// Formatters
class _NumberFormatter {
  String condense(num value, {int precision = 1, bool shortZero = true}) {
    final absValue = value.abs();
    final sign = value < 0 ? '-' : '';

    String format(num val, String suffix) {
      String str = val.abs().toStringAsFixed(precision);
      if (shortZero && str.endsWith('.0')) {
        str = str.substring(0, str.length - 2);
      }
      return '$sign$str$suffix';
    }

    if (absValue >= 1e12) return format(value / 1e12, 'T');
    if (absValue >= 1e9) return format(value / 1e9, 'B');
    if (absValue >= 1e6) return format(value / 1e6, 'M');
    if (absValue >= 1e3) return format(value / 1e3, 'K');
    return value.toString();
  }

  String withCommas(num value, {String locale = 'en_US'}) {
    final format = NumberFormat.decimalPattern(locale);
    return format.format(value);
  }

  String withCustomSeparator(num value, {String separator = ','}) {
    final parts = value.toStringAsFixed(0).split('');
    for (int i = parts.length - 3; i > 0; i -= 3) {
      parts.insert(i, separator);
    }
    return parts.join();
  }

  String ordinal(int number) {
    if (number <= 0) return number.toString();
    final suffix = (number % 100 >= 11 && number % 100 <= 13)
        ? 'th'
        : ['th', 'st', 'nd', 'rd'][number % 10 < 4 ? number % 10 : 0];
    return '$number$suffix';
  }
}

class _DateTimeFormatter {
  String duration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    final parts = <String>[];
    if (hours > 0) parts.add('${hours}h');
    if (minutes > 0) parts.add('${minutes}m');
    if (seconds > 0 || parts.isEmpty) parts.add('${seconds}s');

    return parts.join(' ');
  }

  String timeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);

    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  String formattedDate(DateTime date, {bool includeTime = true}) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today at ${DateFormat.jm().format(date)}';
    } else if (difference == 1) {
      return 'Yesterday at ${DateFormat.jm().format(date)}';
    } else if (difference < 7) {
      return '${DateFormat.EEEE().format(date)} at ${DateFormat.jm().format(date)}'; // e.g., Monday at 3:00 PM
    } else if (date.year == now.year) {
      final fStr = includeTime ? "MMM d 'at' h:mm a" : 'MMM d';
      return DateFormat(fStr).format(date);
    } else {
      // e.g., Jan 10, 2023 at 3:00 PM
      final fStr = includeTime ? "MMM d, yyyy 'at' h:mm a" : 'MMM d, yyyy';
      return DateFormat(fStr).format(date);
    }
  }
}

class _UnitFormatter {
  String bytes(int bytes, {int precision = 1}) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    double size = bytes.toDouble();
    int i = 0;
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    String result = size.toStringAsFixed(precision);
    if (result.endsWith('.0')) result = result.substring(0, result.length - 2);
    return '$result ${suffixes[i]}';
  }

  String siUnit(num value, String unit) {
    final abs = value.abs();
    if (abs >= 1e9) return '${(value / 1e9).toStringAsFixed(1)}G$unit';
    if (abs >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M$unit';
    if (abs >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}k$unit';
    if (abs >= 1) return '$value$unit';
    if (abs >= 1e-3) return '${(value * 1e3).toStringAsFixed(1)}m$unit';
    if (abs >= 1e-6) return '${(value * 1e6).toStringAsFixed(1)}µ$unit';
    return '$value$unit';
  }
}

class _CurrencyFormatter {
  String format(num value, {String symbol = '\$', String locale = 'en_US'}) {
    final format = NumberFormat.currency(locale: locale, symbol: symbol);
    return format.format(value);
  }

  String compactCurrency(num value, {String symbol = '\$', int precision = 1}) {
    final condensed = _NumberFormatter()..condense(value, precision: precision);
    return '$symbol$condensed';
  }

  String percent(num value, {int decimalPlaces = 0}) {
    final percentValue = (value * 100).toStringAsFixed(decimalPlaces);
    return '$percentValue%';
  }
}

class _StringFormatter {
  /// Capitalizes the first letter of a string
  String capitalize(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  /// Trims and removes extra spaces
  String normalizeWhitespace(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Converts a string to title case
  String toTitleCase(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'[-_]'), ' ') // convert - and _ to space
        .split(RegExp(r'\s+')) // split on any whitespace
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  /// Truncates a string to [maxLength] and adds ellipsis
  String truncate(String input, int maxLength) {
    if (input.length <= maxLength) return input;
    return '${input.substring(0, maxLength - 1)}…';
  }

  /// Obfuscates an email like a****@domain.com
  String obfuscateEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2 || parts[0].length < 2) return email;
    final user = parts[0];
    final obfuscatedUser = user[0] + '*' * (user.length - 1);
    return '$obfuscatedUser@${parts[1]}';
  }
}

class _Formatters {
  final unit = _UnitFormatter();
  final number = _NumberFormatter();
  final string = _StringFormatter();
  final dateTime = _DateTimeFormatter();
  final currency = _CurrencyFormatter();
}

/// Dev utilities

class _DevUtils {
  void featureNotImplementedDialog(BuildContext context) {
    InAppFeedback.popups.info(context, 'Feature not implemented yet!');
  }

  safeCallbackCall(VoidCallback? callback, BuildContext context) {
    if (callback != null) {
      return callback.call();
    }
    Global.devUtils.featureNotImplementedDialog(context);
  }
}

class Global {
  /// Formatters
  static final formatters = _Formatters();

  /// Dev utils interface
  static final devUtils = _DevUtils();

  // Type checkings

  static bool isEmptyString(value) {
    return value == null || (value is String && value.isEmpty);
  }

  static bool isEmptyList(value) {
    return value == null || (value is List && value.isEmpty);
  }

  static bool isEmpty(value) {
    if (value is String || value is List || value is Map) {
      return value.isEmpty;
    }

    return value == null;
  }
}
