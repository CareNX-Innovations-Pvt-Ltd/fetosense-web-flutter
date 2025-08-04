import 'package:fetosense_mis/widget/appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mocktail/mocktail.dart';

class MockCallback extends Mock {
  void call();
}

void main() {
  testWidgets('AppBar displays logo, menu icon, user email, and handles all interactions', (tester) async {
    final toggleSidebar = MockCallback();
    final onLogout = MockCallback();
    const email = 'testuser@example.com';

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: buildAppBar(toggleSidebar, email, onLogout),
        ),
      ),
    );

    // Check logo
    final logo = find.byType(Image);
    expect(logo, findsOneWidget);

    // Check user email
    expect(find.text(email), findsOneWidget);

    // Check sidebar menu button and tap
    final menuButton = find.byIcon(Icons.menu);
    expect(menuButton, findsOneWidget);
    await tester.tap(menuButton);
    verify(() => toggleSidebar()).called(1);

    // Check account icon
    final accountIcon = find.byIcon(Icons.account_circle);
    expect(accountIcon, findsOneWidget);
    await tester.tap(accountIcon);
    await tester.pumpAndSettle();

    // Ensure popup appears
    expect(find.byType(PopupMenuItem<String>), findsOneWidget);
    expect(find.text('Logout'), findsOneWidget);

    // Tap logout
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    verify(() => onLogout()).called(1);
  });
}
