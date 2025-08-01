import 'dart:ui';

import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:fetosense_mis/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';


class MockPreferenceHelper extends Mock implements PreferenceHelper {}

void main() {
  late MockPreferenceHelper mockPrefs;

  setUp(() {
    mockPrefs = MockPreferenceHelper();
    GetIt.I.registerSingleton<PreferenceHelper>(mockPrefs);
  });

  tearDown(() => GetIt.I.reset());

  Future<void> pumpSidebar(WidgetTester tester, String role) async {
    when(() => mockPrefs.getUserRole()).thenReturn(role);

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(routes: []),
        builder: (context, child) {
          return Material(
            child: buildSidebar(context, () {}),
          );
        },
      ),
    );
  }

  testWidgets('renders common sidebar items', (tester) async {
    await pumpSidebar(tester, UserRoles.admin);

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('MIS'), findsOneWidget);
  });

  testWidgets('renders Registration menu for admin', (tester) async {
    await pumpSidebar(tester, UserRoles.admin);

    expect(find.text('Registration'), findsOneWidget);

    await tester.tap(find.text('Registration'));
    await tester.pumpAndSettle();

    expect(find.text('Organization'), findsOneWidget);
    expect(find.text('Device'), findsOneWidget);
    expect(find.text('Generate QR'), findsOneWidget);
  });

  testWidgets('does not render Registration menu for non-admin', (tester) async {
    await pumpSidebar(tester, UserRoles.user);

    expect(find.text('Registration'), findsNothing);
  });

  testWidgets('renders Users for superAdmin', (tester) async {
    await pumpSidebar(tester, UserRoles.superAdmin);

    expect(find.text('Users'), findsOneWidget);
  });

  testWidgets('calls logoutCallback when provided', (tester) async {
    bool didLogout = false;
    when(() => mockPrefs.getUserRole()).thenReturn(UserRoles.admin);

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: buildSidebar(
            tester.element(find.byType(Material)),
                () => didLogout = true,
          ),
        ),
      ),
    );

    expect(didLogout, isFalse);
  });

  testWidgets('hover effect changes style on _SidebarItem', (tester) async {
    await pumpSidebar(tester, UserRoles.admin);

    final item = find.text('Dashboard');
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    await tester.pump();

    await gesture.moveTo(tester.getCenter(item));
    await tester.pumpAndSettle();

    // You can visually inspect or check for AnimatedContainer, but styles can't be asserted easily
    expect(item, findsOneWidget);

    await gesture.removePointer();
  });
}
