import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_stat_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DeviceStatCard displays count, label, and icon correctly', (WidgetTester tester) async {
    const testCount = '10';
    const testLabel = 'Connected';
    const testIcon = Icons.bluetooth;
    const testColor = Colors.blue;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              DeviceStatCard(
                count: testCount,
                label: testLabel,
                icon: testIcon,
                color: testColor,
              ),
            ],
          ),
        ),
      ),
    );

    // Check if the count text is displayed
    expect(find.text(testCount), findsOneWidget);

    // Check if the label text is displayed
    expect(find.text(testLabel), findsOneWidget);

    // Check if the icon is displayed
    final iconFinder = find.byIcon(testIcon);
    expect(iconFinder, findsOneWidget);

    // Check if Container uses Expanded (structure test)
    final expandedFinder = find.byType(Expanded);
    expect(expandedFinder, findsOneWidget);
  });

  testWidgets('DeviceStatCard uses proper color opacity in gradients and shadows', (WidgetTester tester) async {
    const color = Colors.green;

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Row(
            children: [
              DeviceStatCard(
                count: '5',
                label: 'Available',
                icon: Icons.devices,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(DeviceStatCard),
        matching: find.byType(Container),
      ).first,
    );

    final decoration = container.decoration as BoxDecoration;

    // Check if the gradient contains the right colors
    expect(decoration.gradient, isA<LinearGradient>());
    final gradient = decoration.gradient as LinearGradient;
    expect(gradient.colors[0], equals(color.withOpacity(0.8)));
    expect(gradient.colors[1], equals(color.withOpacity(0.6)));

    // Check if box shadow is applied
    expect(decoration.boxShadow, isNotNull);
    expect(decoration.boxShadow!.first.color, equals(color.withOpacity(0.4)));
  });
}
