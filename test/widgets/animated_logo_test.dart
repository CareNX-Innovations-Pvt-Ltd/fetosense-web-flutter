import 'package:fetosense_mis/animation/animated_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AnimatedLogo Widget Tests', () {
    testWidgets('renders the AnimatedLogo and contains ScaleTransition',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            const MaterialApp(
              home: Scaffold(
                body: AnimatedLogo(),
              ),
            ),
          );

          // Allow animation to start
          await tester.pump(const Duration(milliseconds: 100));

          expect(find.byType(AnimatedLogo), findsOneWidget);
          expect(find.byType(ScaleTransition), findsOneWidget);
          expect(find.byType(Image), findsOneWidget);
        });

    testWidgets('animation runs over time', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AnimatedLogo(),
          ),
        ),
      );

      final ScaleTransition transition =
      tester.widget(find.byType(ScaleTransition));
      final Animation<double> animation = transition.scale;

      final double initialValue = animation.value;

      // Pump time to let animation progress
      await tester.pump(const Duration(milliseconds: 500));

      // Animation value should have changed
      expect(animation.value != initialValue, true);
    });

    testWidgets('shows fallback icon on image load failure',
            (WidgetTester tester) async {
          // Override image loading to simulate failure
          await tester.pumpWidget(
            MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) {
                    return const AnimatedLogo();
                  },
                ),
              ),
            ),
          );

          // Allow animation and frame building
          await tester.pump(const Duration(milliseconds: 500));

          // Force the errorBuilder by simulating an image error
          final Image image = tester.widget(find.byType(Image));
          final errorBuilder = image.errorBuilder!;
          final widget = errorBuilder.call(
            tester.element(find.byType(Image)),
            Exception('Load failed'),
            StackTrace.current,
          );

          expect(widget, isA<Icon>());
          expect((widget as Icon).icon, Icons.image_not_supported);
        });
  });
}
