import 'dart:developer' as developer;

import 'package:bio_sphere/dev_utils/dev_util_enums.dart';
import 'package:bio_sphere/dev_utils/logging/log_sink.dart';

class ConsoleLogSink implements LogSink {
  const ConsoleLogSink();

  @override
  Future<void> write(String message, String tag, LogLevel level) async {
    developer.log(
      message,
      name: tag,
      time: DateTime.now(),
      level: _developerLogLevel(level),
    );
  }

  int _developerLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}
