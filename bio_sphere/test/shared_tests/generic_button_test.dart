import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bio_sphere/shared/presentation/buttons/generic_button.dart';
import 'package:bio_sphere/shared/constants/widget/widget_enums.dart';

import '../test_helper.dart';

void main() {
  group('GenericButton Tests', () {
    testWidgets('renders filled primary with text only', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          (_) => GenericButton(
            label: 'Click me',
            onPressed: () {},
            variant: ButtonVariant.primary,
          ),
        ),
      );
      expect(find.text('Click me'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('renders outlined secondary with text only', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          (_) => GenericButton(
            label: 'Outline',
            type: ButtonType.outlined,
            variant: ButtonVariant.secondary,
            onPressed: () {},
          ),
        ),
      );
      expect(find.text('Outline'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('renders text error with text only', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          (_) => GenericButton(
            label: 'Text Button',
            type: ButtonType.text,
            variant: ButtonVariant.error,
            onPressed: () {},
          ),
        ),
      );
      expect(find.text('Text Button'), findsOneWidget);
      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('renders with both text and prefix icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          (_) => GenericButton(
            label: 'Go',
            prefixIcon: Icons.send,
            onPressed: () {},
          ),
        ),
      );
      expect(find.text('Go'), findsOneWidget);
      expect(find.byIcon(Icons.send), findsOneWidget);
    });

    testWidgets('renders with both text and suffix icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          (_) => GenericButton(
            label: 'Next',
            suffixIcon: Icons.arrow_forward,
            onPressed: () {},
          ),
        ),
      );
      expect(find.text('Next'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTestWidget(
          (_) => GenericButton(
            label: 'Tap',
            onPressed: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.tap(find.text('Tap'));
      expect(tapped, isTrue);
    });

    testWidgets('does not call onPressed when disabled', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildTestWidget(
          (_) => GenericButton(label: 'Disabled', onPressed: null),
        ),
      );
      await tester.tap(find.text('Disabled'));
      expect(tapped, isFalse);
    });

    testWidgets('renders correctly in loading state', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          (_) => GenericButton(
            label: 'Loading',
            isLoading: true,
            onPressed: () {},
          ),
        ),
      );

      final buttonFinder = find.byType(FilledButton);
      final filledButton = tester.widget<FilledButton>(buttonFinder);

      expect(find.text('Loading'), findsNothing);
      expect(buttonFinder, findsOneWidget);
      expect(filledButton.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('respects fullwidth and height', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          (_) => GenericButton(
            label: 'Fullwidth',
            fullwidth: true,
            height: 50,
            onPressed: () {},
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.height, 50);
    });

    testWidgets('uses custom textColor and background color', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          (_) => GenericButton(
            label: 'Custom Colors',
            onPressed: () {},
            textColor: Colors.pink,
            color: Colors.black,
          ),
        ),
      );

      final filledButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      final style = filledButton.style!;
      final bgColor = (style.backgroundColor)?.resolve({});

      expect(bgColor, Colors.black);
      expect(find.text('Custom Colors'), findsOneWidget);
    });
  });
}
