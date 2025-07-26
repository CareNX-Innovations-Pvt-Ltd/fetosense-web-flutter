import 'package:fetosense_mis/widget/custom_date_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomDatePicker Widget Tests', () {
    late TextEditingController controller;
    late DateTime? selectedDate;
    late bool dateClearedCalled;
    late DateTime? selectedDateResult;

    setUp(() {
      controller = TextEditingController();
      selectedDate = null;
      dateClearedCalled = false;
      selectedDateResult = null;
    });

    Widget buildTestWidget(Widget child) {
      return MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(size: Size(800, 600)),
          child: Scaffold(
            body: child,
          ),
        ),
      );
    }

    testWidgets('Widget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        Builder(
          builder: (context) => customDatePicker(
            context: context,
            label: 'Test Date',
            selectedDate: selectedDate,
            controller: controller,
            onDateCleared: () {
              dateClearedCalled = true;
            },
            onDateSelected: (date) {
              selectedDateResult = date;
            },
          ),
        ),
      ));

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Test Date'), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);

      final clearButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(clearButton.onPressed, isNull); // Disabled because no date
    });

    testWidgets('Clear button clears date and calls callback', (WidgetTester tester) async {
      selectedDate = DateTime(2023, 1, 1);
      controller.text = '2023-01-01';

      await tester.pumpWidget(buildTestWidget(
        Builder(
          builder: (context) => customDatePicker(
            context: context,
            label: 'Test Date',
            selectedDate: selectedDate,
            controller: controller,
            onDateCleared: () {
              dateClearedCalled = true;
              selectedDate = null;
              controller.clear();
            },
            onDateSelected: (_) {},
          ),
        ),
      ));

      expect(find.byType(IconButton), findsOneWidget);
      final clearButton = find.byType(IconButton);
      await tester.tap(clearButton);
      await tester.pump();

      expect(dateClearedCalled, isTrue);
      expect(controller.text, '');
    });

    testWidgets('Tapping the field opens date picker', (WidgetTester tester) async {
      await tester.pumpWidget(buildTestWidget(
        Builder(
          builder: (context) => customDatePicker(
            context: context,
            label: 'Test Date',
            selectedDate: selectedDate,
            controller: controller,
            onDateCleared: () {},
            onDateSelected: (date) {
              selectedDateResult = date;
            },
          ),
        ),
      ));

      expect(find.byType(TextFormField), findsOneWidget);
      await tester.tap(find.byType(TextFormField));
      await tester.pumpAndSettle(); // Wait for date picker to appear

      expect(find.byType(CalendarDatePicker), findsOneWidget); // Validate date picker appears
    });
  });
}
