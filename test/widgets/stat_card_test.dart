import 'package:fetosense_mis/screens/organization_details/widgets/edit_popup_widgets/stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StatCard', () {
    testWidgets('renders correctly with all fields', (tester) async {
      const widget = MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              StatCard(
                count: '42',
                label: 'Total Tests',
                icon: Icons.analytics,
                color: Colors.teal,
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(widget);

      // Verify the main elements are present
      expect(find.byType(StatCard), findsOneWidget);
      expect(find.text('42'), findsOneWidget);
      expect(find.text('Total Tests'), findsOneWidget);
      expect(find.byIcon(Icons.analytics), findsOneWidget);

      // Verify Expanded & Container structure
      final expanded = tester.widget<Expanded>(find.byType(Expanded));
      expect(expanded.flex, equals(1));

      final container = tester.widget<Container>(find.byType(Container).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
      expect(decoration.boxShadow, isNotEmpty);
      expect(decoration.borderRadius, isNotNull);

      // Verify gradient colors use opacity variants of the base color
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors.length, 2);
      expect(gradient.colors[0].opacity, closeTo(0.9, 0.01));
      expect(gradient.colors[1].opacity, closeTo(0.7, 0.01));

      // Verify shadow properties
      final boxShadow = decoration.boxShadow!.first;
      expect(boxShadow.color.opacity, closeTo(0.4, 0.01));
      expect(boxShadow.blurRadius, 8);
      expect(boxShadow.offset, const Offset(0, 4));
    });

    testWidgets('renders with different color and icon', (tester) async {
      const widget = MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              StatCard(
                count: '99',
                label: 'Doctors',
                icon: Icons.person,
                color: Colors.red,
              ),
            ],
          ),
        ),
      );

      await tester.pumpWidget(widget);

      // Verify alternate text & icon appear
      expect(find.text('99'), findsOneWidget);
      expect(find.text('Doctors'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      // Verify inner icon decoration has circular shape
      final innerContainer = tester.widgetList<Container>(find.byType(Container)).toList()[1];
      final innerDecoration = innerContainer.decoration as BoxDecoration;
      expect(innerDecoration.shape, BoxShape.circle);
    });
  });
}
