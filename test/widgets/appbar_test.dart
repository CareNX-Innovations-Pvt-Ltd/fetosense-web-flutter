import 'package:fetosense_mis/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Mock the necessary dependencies
class MockVoidCallback extends Mock {
  void call();
}

void main() {
  group('AppBar Tests', () {
    testWidgets('AppBar displays logo, menu icon, user email, and account icon', (WidgetTester tester) async {
      final mockToggleSidebar = MockVoidCallback();
      final mockOnLogout = MockVoidCallback();
      const userEmail = 'testuser@example.com';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: buildAppBar(mockToggleSidebar.call, userEmail, mockOnLogout.call),
        ),
      ));

      // Verify logo is displayed
      expect(find.byType(Image), findsOneWidget);
      // You might want to add a more specific check for the image asset if possible

      // Verify menu icon is displayed
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Verify user email is displayed
      expect(find.text(userEmail), findsOneWidget);

      // Verify account icon is displayed
      expect(find.byIcon(Icons.account_circle), findsOneWidget);
    });

    testWidgets('Tapping menu icon calls toggleSidebar', (WidgetTester tester) async {
      final mockToggleSidebar = MockVoidCallback();
      final mockOnLogout = MockVoidCallback();
      const userEmail = 'testuser@example.com';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: buildAppBar(mockToggleSidebar.call, userEmail, mockOnLogout.call),
        ),
      ));

      await tester.tap(find.byIcon(Icons.menu));
      verify(mockToggleSidebar.call()).called(1);
    });

  });
}
