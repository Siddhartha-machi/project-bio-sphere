import 'package:bio_sphere/dev_utils/dev_util_enums.dart';
import 'package:bio_sphere/dev_utils/logging/log_sink.dart';
import 'package:bio_sphere/dev_utils/logging/console_log_sink.dart';

class AppLogger {
  final String tag;
  final bool useColor;
  final String logMode;
  final bool isEnabled;
  final LogSink logSink;

  const AppLogger({
    this.tag = 'APP',
    this.logMode = 'Dev',
    this.useColor = true,
    this.isEnabled = true,
    this.logSink = const ConsoleLogSink(),
  });

  Future<void> log(String message, {LogLevel level = LogLevel.info}) async {
    if (!isEnabled) return;

    final formatted = _attachTimeStamp(message);
    final colored = _applyColor(formatted, level);

    await logSink.write(colored, '$tag :: $logMode', level);
  }

  Future<void> info(String message) => log(message, level: LogLevel.info);
  Future<void> debug(String message) => log(message, level: LogLevel.debug);
  Future<void> warning(String message) => log(message, level: LogLevel.warning);
  Future<void> error(String message) => log(message, level: LogLevel.error);

  String _attachTimeStamp(String message) {
    final now = DateTime.now();
    final formattedTime =
        '[${now.day}-${now.month}-${now.year}::${now.hour}:${now.minute.toString().padLeft(2, '0')}]';
    return '$formattedTime $message';
  }

  String _applyColor(String message, LogLevel level) {
    if (!useColor) return message;
    switch (level) {
      case LogLevel.debug:
        return '\x1B[34m$message\x1B[0m'; // Blue
      case LogLevel.info:
        return '\x1B[32m$message\x1B[0m'; // Green
      case LogLevel.warning:
        return '\x1B[33m$message\x1B[0m'; // Yellow
      case LogLevel.error:
        return '\x1B[31m$message\x1B[0m'; // Red
    }
  }
}
