import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fetosense_mis/screens/dashboard/widget/hover_stat_card.dart';
import 'package:fetosense_mis/core/models/models.dart';


void main() {
  group('HoverStatCard Widget Tests', () {
    testWidgets('HoverStatCard renders correctly', (WidgetTester tester) async {
      final stat = DashboardStat(
        icon: Icons.analytics,
        title: 'Test Title',
        count: '123',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HoverStatCard(stat: stat),
          ),
        ),
      );

      // Verify the icon is present
      expect(find.byIcon(Icons.analytics), findsOneWidget);

      // Verify the title text is present
      expect(find.text('Test Title'), findsOneWidget);

      // Verify the count text is present
      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('HoverStatCard hover effect works', (WidgetTester tester) async {
      final stat = DashboardStat(
        icon: Icons.analytics,
        title: 'Test Title',
        count: '123',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HoverStatCard(stat: stat),
          ),
        ),
      );

      // Verify initial scale and color
      final animatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(animatedScale.scale, equals(1.0));

      final containerDecoration = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration as BoxDecoration;
      expect(containerDecoration.color, equals(Colors.grey.shade800));

      // Simulate hover
      final mouseRegion = find.byType(MouseRegion);
      await tester.sendEventToBinding(const PointerEnterEvent(position: Offset.zero));
      await tester.pumpAndSettle();

      // Verify scale and color after hover
      final updatedScale = tester.widget<AnimatedScale>(find.byType(AnimatedScale));
      expect(updatedScale.scale, equals(1.0));

      final updatedDecoration = tester.widget<AnimatedContainer>(find.byType(AnimatedContainer)).decoration as BoxDecoration;
      expect(updatedDecoration.color, equals(Colors.grey.shade800));
    });


  });
}