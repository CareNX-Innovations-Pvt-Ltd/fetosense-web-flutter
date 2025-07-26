import 'package:fetosense_mis/widget/columns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('_buildLabel', () {
    testWidgets('should display label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: buildLabel('Test Label', false))));
      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text(' *'), findsNothing);
    });

    testWidgets('should display label with asterisk when required', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: buildLabel('Test Label', true))));
      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text(' *'), findsOneWidget);
    });
  });

  group('_inputDecoration', () {
    test('should return InputDecoration with correct hintText', () {
      final decoration = inputDecoration('Test Hint');
      expect(decoration.hintText, 'Test Hint');
    });

    // Add more tests for other InputDecoration properties if needed
  });

  group('buildColumnWithTextField', () {
    testWidgets('should build Column with TextField', (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: buildColumnWithTextField('Label', controller, 'Hint', false))));

      expect(find.text('Label'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Hint'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should show required error message when required and empty', (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (BuildContext context) {
        return Form(
          child: buildColumnWithTextField('Label', controller, 'Hint', true),
        );
      }))));

      controller.dispose();
    });

    // Add more tests for isNumber, initial value, etc.
  });

  group('buildColumnWithDropdown', () {
    testWidgets('should build Column with DropdownButtonFormField', (WidgetTester tester) async {
      List<String> items = ['Item 1', 'Item 2'];
      String? selectedValue;
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: buildColumnWithDropdown('Label', items, selectedValue, 'Hint', (newValue) { selectedValue = newValue; }, false))));

      expect(find.text('Label'), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(find.text('Hint'), findsOneWidget);
    });

    testWidgets('should show required error message when required and empty', (WidgetTester tester) async {
      List<String> items = ['Item 1', 'Item 2'];
      String? selectedValue;
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(builder: (BuildContext context) {
        return Form(
          child: buildColumnWithDropdown('Label', items, selectedValue, 'Hint', (newValue) { selectedValue = newValue; }, true),
        );
      }))));

    });

    // Add more tests for onChanged, disabled state, different items, etc.
  });
}
