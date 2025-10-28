import 'package:fetosense_mis/screens/organization_details/widgets/edit_popup_widgets/tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TileCard', () {
    testWidgets('renders label and value text correctly', (tester) async {
      const widget = MaterialApp(
        home: Scaffold(
          body: TileCard(label: 'Organization', value: 'Fetosense Labs'),
        ),
      );

      await tester.pumpWidget(widget);

      // Verify text contents
      expect(find.text('Organization'), findsOneWidget);
      expect(find.text('Fetosense Labs'), findsOneWidget);

      // Verify gradient and decoration properties
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());

      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors.first, const Color(0xFF1E1F20));
      expect(gradient.colors.last, const Color(0xFF121314));
      expect(gradient.begin, Alignment.topLeft);
      expect(gradient.end, Alignment.bottomRight);

      // Verify shadow and border
      expect(decoration.boxShadow, isNotEmpty);
      expect(decoration.borderRadius, isNotNull);
      expect(decoration.border, isA<Border>());
    });

    testWidgets('applies opacity and font styles correctly', (tester) async {
      const widget = MaterialApp(
        home: Scaffold(
          body: TileCard(label: 'Doctor', value: 'Dr. Smith'),
        ),
      );

      await tester.pumpWidget(widget);

      // Verify label text style
      final labelText = tester.widget<Text>(find.text('Doctor'));
      final labelStyle = labelText.style!;
      expect(labelStyle.color!.opacity, closeTo(0.9, 0.01));
      expect(labelStyle.fontWeight, FontWeight.bold);
      expect(labelStyle.fontSize, 13);

      // Verify spacing and value style
      expect(find.byType(SizedBox), findsOneWidget);
      final valueText = tester.widget<Text>(find.text('Dr. Smith'));
      final valueStyle = valueText.style!;
      expect(valueStyle.color, Colors.grey);
      expect(valueStyle.fontSize, 12);
    });

    testWidgets('has correct padding and margin', (tester) async {
      const widget = MaterialApp(
        home: Scaffold(
          body: TileCard(label: 'Device', value: 'Device-001'),
        ),
      );

      await tester.pumpWidget(widget);

      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, const EdgeInsets.all(14));
      expect(container.margin, const EdgeInsets.only(top: 10));
      expect(container.constraints, isNull);
    });
  });
}
