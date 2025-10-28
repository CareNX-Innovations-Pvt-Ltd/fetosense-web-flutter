import 'package:fetosense_mis/screens/login/widgets/captcha_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CaptchaCheckbox', () {
    testWidgets('renders unchecked initially', (tester) async {
      bool verified = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CaptchaCheckbox(onVerified: (v) => verified = v),
          ),
        ),
      );

      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text("I'm not a robot"), findsOneWidget);
      expect(find.byIcon(Icons.verified_user), findsOneWidget);
      expect(verified, isFalse);
    });

    testWidgets('shows captcha dialog when not verified and user cancels', (tester) async {
      bool verified = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CaptchaCheckbox(onVerified: (v) => verified = v),
          ),
        ),
      );

      // Tap checkbox → opens dialog
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(find.text("Verify you're human"), findsOneWidget);

      // Tap Cancel
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Dialog dismissed, verification not granted
      expect(find.text("Verify you're human"), findsNothing);
      expect(verified, isFalse);
    });

    testWidgets('shows captcha dialog and verifies on positive press', (tester) async {
      bool verified = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CaptchaCheckbox(onVerified: (v) => verified = v),
          ),
        ),
      );

      // Tap checkbox → opens dialog
      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      // Confirm button pressed
      await tester.tap(find.text("I'm not a robot"));
      await tester.pumpAndSettle();

      // After confirmation, verified should be true
      expect(verified, isTrue);

      // Icon color reflects verification
      final icon = tester.widget<Icon>(find.byIcon(Icons.verified_user));
      expect(icon.color, Colors.green);
    });

    testWidgets('allows direct checkbox toggle once verified', (tester) async {
      bool verifiedValue = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CaptchaCheckbox(onVerified: (v) => verifiedValue = v),
          ),
        ),
      );

      // Manually mark verified by simulating internal state
      final state = tester.state(find.byType(CaptchaCheckbox)) as dynamic;
      state.setState(() {
        state._captchaPassed = true;
        state._isChecked = true;
      });

      await tester.pump();

      // Uncheck directly
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      expect(verifiedValue, isFalse);
    });

    testWidgets('icon shows white when not verified', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CaptchaCheckbox(onVerified: print),
          ),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.verified_user));
      expect(icon.color, Colors.white70);
    });
  });
}
