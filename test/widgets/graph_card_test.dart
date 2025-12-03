import 'package:fetosense_mis/screens/dashboard/widget/graph_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GraphCard Widget Tests', () {
    testWidgets('GraphCard renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GraphCard(tests: [],),
          ),
        ),
      );

      // Verify the FadeTransition is present
      expect(find.byType(FadeTransition), findsOneWidget);

      // Verify the Card is present
      expect(find.byType(Card), findsOneWidget);

      // Verify the LineChart is present
      expect(find.byType(LineChart), findsOneWidget);

      // Verify the "Not enough data available" text is present
      expect(find.text('Not enough data available'), findsOneWidget);
    });

    testWidgets('GraphCard animation works', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GraphCard(tests: [],),
          ),
        ),
      );

      // Verify initial opacity is 0
      FadeTransition fadeTransition =
          tester.widget<FadeTransition>(find.byType(FadeTransition));
      expect(fadeTransition.opacity.value, equals(0.0));

      // Trigger animation
      await tester.pumpAndSettle();

      // Verify final opacity is 1
      fadeTransition =
          tester.widget<FadeTransition>(find.byType(FadeTransition));
      expect(fadeTransition.opacity.value, equals(1.0));
    });
  });
}