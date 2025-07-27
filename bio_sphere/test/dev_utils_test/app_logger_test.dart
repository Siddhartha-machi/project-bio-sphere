import 'package:flutter_test/flutter_test.dart';

import 'package:bio_sphere/dev_utils/dev_util_enums.dart';
import 'package:bio_sphere/dev_utils/logging/log_sink.dart';
import 'package:bio_sphere/dev_utils/logging/app_logger.dart';

/// Create a test log sink to test the logs
class TestLogSink implements LogSink {
  final List<String> logs = [];

  @override
  Future<void> write(String message, String tag, LogLevel level) async {
    logs.add('[$tag][$level] $message');
  }
}

void main() {
  group('AppLogger', () {
    late TestLogSink testSink;

    setUp(() {
      testSink = TestLogSink();
    });

    test('logs info level', () async {
      final logger = AppLogger(
        logSink: testSink,
        tag: 'TEST',
        isEnabled: true,
        useColor: false,
      );

      await logger.info('Info message');
      expect(testSink.logs.length, 1);
      expect(testSink.logs.first.contains('[TEST :: Dev]'), true);
      expect(testSink.logs.first.contains('Info message'), true);
    });

    test('logs all levels correctly', () async {
      final logger = AppLogger(
        logSink: testSink,
        tag: 'MULTI',
        useColor: false,
      );

      await logger.debug('Debug message');
      await logger.info('Info message');
      await logger.warning('Warning message');
      await logger.error('Error message');

      expect(testSink.logs.length, 4);
      expect(testSink.logs[0], contains('Debug message'));
      expect(testSink.logs[1], contains('Info message'));
      expect(testSink.logs[2], contains('Warning message'));
      expect(testSink.logs[3], contains('Error message'));
    });

    test('includes timestamp if withTimestamp is true', () async {
      final logger = AppLogger(logSink: testSink, useColor: false);

      await logger.info('Timestamp test');
      final log = testSink.logs.first;

      expect(
        log.contains(
          RegExp(r'\[\d{1,2}-\d{1,2}-\d{4}::\d{1,2}:\d{2}\] Timestamp test'),
        ),
        true,
      );
    });

    test('applies ANSI color if useColor is true', () async {
      final logger = AppLogger(logSink: testSink, useColor: true);

      await logger.error('Colored error');
      final log = testSink.logs.first;

      expect(log.contains('\x1B[31m'), true); // Red for error
    });

    test('does not log if isEnabled is false', () async {
      final logger = AppLogger(logSink: testSink, isEnabled: false);

      await logger.info('Should not log');
      expect(testSink.logs.isEmpty, true);
    });

    test('default values used when not provided', () async {
      final logger = AppLogger(logSink: testSink);
      await logger.debug('Defaults test');

      final log = testSink.logs.first;
      expect(log.contains('Defaults test'), true);
    });

    test('color codes match log levels', () async {
      final logger = AppLogger(logSink: testSink, useColor: true);

      await logger.debug('debug');
      await logger.info('info');
      await logger.warning('warn');
      await logger.error('err');

      final debugColor = '\x1B[34m';
      final infoColor = '\x1B[32m';
      final warnColor = '\x1B[33m';
      final errorColor = '\x1B[31m';

      expect(testSink.logs[0], contains(debugColor));
      expect(testSink.logs[1], contains(infoColor));
      expect(testSink.logs[2], contains(warnColor));
      expect(testSink.logs[3], contains(errorColor));
    });
  });
}
