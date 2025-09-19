import 'dart:developer' as developer;

import 'package:bio_sphere/dev_utils/dev_util_enums.dart';
import 'package:bio_sphere/dev_utils/logging/log_sink.dart';

class CompositeLogSink implements LogSink {
  final List<LogSink> sinks;

  CompositeLogSink(this.sinks);

  @override
  Future<void> write(String message, String tag, LogLevel level) async {
    for (final sink in sinks) {
      try {
        await sink.write(message, tag, level);
      } catch (e) {
        developer.log(
          'Error in sink: $e',
          name: 'CompositeLogSink',
          level: 1000,
        );
      }
    }
  }
}
