import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:bio_sphere/shared/presentation/ui_feedback/in_app_feedback.dart';

_buildTestWidget(WidgetTester tester, WidgetBuilder builder) async {
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(home: Builder(builder: builder));
      },
    ),
  );
}

void main() {
  group('SnackBarNotifier', () {
    testWidgets('shows success snackbar', (WidgetTester tester) async {
      final testKey = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            key: testKey,
            body: Builder(
              builder: (context) {
                return ElevatedButton(
                  onPressed: () {
                    InAppFeedback.snackBars.success(context, 'Success!');
                  },
                  child: const Text('Show Success Snackbar'),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Success Snackbar'));
      await tester.pump(); // show snackbar

      expect(find.text('Success!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows error snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  InAppFeedback.snackBars.error(context, 'Error!');
                },
                child: const Text('Show error Snackbar'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show error Snackbar'));
      await tester.pump(); // show snackbar

      expect(find.text('Error!'), findsOneWidget);
      expect(find.byIcon(Icons.error), findsOneWidget);
    });

    testWidgets('shows info snackbar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  InAppFeedback.snackBars.info(context, 'Info!');
                },
                child: const Text('Show info Snackbar'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show info Snackbar'));
      await tester.pump(); // show snackbar

      expect(find.text('Info!'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
    });
  });
  group('DialogNotifier', () {
    testWidgets('shows success dialog', (WidgetTester tester) async {
      await _buildTestWidget(
        tester,
        (BuildContext context) => ElevatedButton(
          onPressed: () {
            InAppFeedback.popups.success(context, 'Success dialog!');
          },
          child: const Text('Show Success Dialog'),
        ),
      );

      await tester.tap(find.text('Show Success Dialog'));
      await tester.pumpAndSettle(); // wait for dialog

      expect(find.text('Success!'), findsOneWidget);
      expect(find.text('Success dialog!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('shows confirm dialog and accepts', (
      WidgetTester tester,
    ) async {
      bool? result;

      await _buildTestWidget(
        tester,
        (context) => ElevatedButton(
          onPressed: () async {
            result = await InAppFeedback.popups.confirm(
              context,
              'Do you confirm?',
            );
          },
          child: const Text('Show Confirm'),
        ),
      );

      await tester.tap(find.text('Show Confirm'));
      await tester.pumpAndSettle(); // show dialog

      expect(find.text('Are you sure?'), findsOneWidget);
      expect(find.text('Do you confirm?'), findsOneWidget);

      await tester.tap(find.text('Yes, I am sure'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });

    testWidgets('shows confirm dialog and cancels', (
      WidgetTester tester,
    ) async {
      bool? result;

      await _buildTestWidget(
        tester,
        (context) => ElevatedButton(
          onPressed: () async {
            result = await InAppFeedback.popups.confirm(
              context,
              'Do you cancel?',
            );
          },
          child: const Text('Show Confirm'),
        ),
      );

      await tester.tap(find.text('Show Confirm'));
      await tester.pumpAndSettle();

      expect(find.text('Do you cancel?'), findsOneWidget);

      await tester.tap(find.text('No, cancel'));
      await tester.pumpAndSettle();

      expect(result, isFalse);
    });

    testWidgets('shows success dialog with correct content', (
      WidgetTester tester,
    ) async {
      await _buildTestWidget(
        tester,
        (context) => ElevatedButton(
          onPressed: () {
            InAppFeedback.popups.success(context, 'Everything worked!');
          },
          child: const Text('Show Success'),
        ),
      );

      await tester.tap(find.text('Show Success'));
      await tester.pumpAndSettle();

      expect(find.text('Success!'), findsOneWidget);
      expect(find.text('Everything worked!'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('Okay'), findsOneWidget);
    });

    testWidgets('shows error dialog with correct content', (
      WidgetTester tester,
    ) async {
      await _buildTestWidget(
        tester,
        (context) => ElevatedButton(
          onPressed: () {
            InAppFeedback.popups.error(context, 'Something went wrong.');
          },
          child: const Text('Show Error'),
        ),
      );

      await tester.tap(find.text('Show Error'));
      await tester.pumpAndSettle();

      expect(find.text('Uh oh!'), findsOneWidget);
      expect(find.text('Something went wrong.'), findsOneWidget);
      expect(find.byIcon(Icons.error_sharp), findsOneWidget);
      expect(find.text('Okay'), findsOneWidget);
    });

    testWidgets('shows info dialog with correct content', (
      WidgetTester tester,
    ) async {
      await _buildTestWidget(
        tester,
        (context) => ElevatedButton(
          onPressed: () {
            InAppFeedback.popups.info(context, 'This is some helpful info.');
          },
          child: const Text('Show Info'),
        ),
      );

      await tester.tap(find.text('Show Info'));
      await tester.pumpAndSettle();

      expect(find.text('Heads up!'), findsOneWidget);
      expect(find.text('This is some helpful info.'), findsOneWidget);
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.text('Okay'), findsOneWidget);
    });
  });
}
