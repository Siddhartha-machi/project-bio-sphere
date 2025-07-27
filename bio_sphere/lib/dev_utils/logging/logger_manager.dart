import 'package:flutter/foundation.dart';

import 'package:bio_sphere/dev_utils/logging/app_logger.dart';
import 'package:bio_sphere/dev_utils/logging/console_log_sink.dart';
import 'package:bio_sphere/dev_utils/logging/composite_log_sink.dart';

class LoggerManager {
  static AppLogger createLogger(String tag) {
    if (kReleaseMode) {
      return AppLogger(
        tag: tag,
        logMode: 'PROD',
        isEnabled: true,
        useColor: false,
        logSink: CompositeLogSink([
          /// Add Prod sinks
        ]),
      );
    }

    if (kProfileMode) {
      return AppLogger(
        tag: tag,
        logMode: 'PROFILE',
        logSink: CompositeLogSink([ConsoleLogSink()]),
      );
    }

    // Default: Debug Mode
    return AppLogger(
      tag: tag,
      logMode: 'DEV',
      logSink: CompositeLogSink([ConsoleLogSink()]),
    );
  }
}
