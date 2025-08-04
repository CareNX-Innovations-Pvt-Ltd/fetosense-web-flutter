import 'package:fetosense_mis/screens/device_details/device_edit/widgets/device_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DeviceTextField Widget Tests', () {
    testWidgets('displays label and hint correctly', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeviceTextField(
              label: 'Device Name',
              controller: controller,
              hint: 'Enter device name',
              enabled: true,
            ),
          ),
        ),
      );

      expect(find.text('Device Name'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Enter device name'), findsOneWidget);
    });

    testWidgets('displays pre-filled controller text', (WidgetTester tester) async {
      final controller = TextEditingController(text: 'L8-Device');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeviceTextField(
              label: 'Device ID',
              controller: controller,
              hint: 'Enter device ID',
              enabled: true,
            ),
          ),
        ),
      );

      expect(find.text('L8-Device'), findsOneWidget);
    });

    testWidgets('TextField is enabled when enabled = true', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeviceTextField(
              label: 'Device',
              controller: controller,
              hint: 'Type something',
              enabled: true,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isTrue);
    });

    testWidgets('TextField is disabled when enabled = false', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DeviceTextField(
              label: 'Device',
              controller: controller,
              hint: 'Disabled field',
              enabled: false,
            ),
          ),
        ),
      );

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.enabled, isFalse);
    });
  });
}
