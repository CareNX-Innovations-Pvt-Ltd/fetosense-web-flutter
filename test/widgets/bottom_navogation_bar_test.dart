import 'package:fetosense_mis/widget/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BottomNavBar displays company name and version', (WidgetTester tester) async {
    // Build the BottomNavBar widget.
    await tester.pumpWidget(const MaterialApp(home: Scaffold(bottomNavigationBar: BottomNavBar())));

    // Verify that the company name and version are displayed.
    expect(find.text('CareNX Innovations Pvt/Ltd.'), findsOneWidget);
    expect(find.text('Version V1.1.1 Powered By '), findsOneWidget);
    expect(find.text('CareNX'), findsOneWidget);

    // Verify that the current year is displayed.
    final int currentYear = DateTime.now().year;
    expect(find.text('$currentYear'), findsOneWidget);
  });
}