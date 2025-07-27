import 'package:bio_sphere/dev_utils/dev_util_enums.dart';

abstract class LogSink {
  Future<void> write(String message, String tag, LogLevel level);
}
