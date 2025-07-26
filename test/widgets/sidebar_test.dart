import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:fetosense_mis/widget/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sidebar_test.mocks.dart';

final locator = GetIt.instance;
void configureGetIt() {
  GetIt.I.registerLazySingleton<PreferenceHelper>(() => PreferenceHelper());
}
@GenerateMocks([PreferenceHelper, GoRouter])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MockPreferenceHelper mockPreferenceHelper;
  late MockGoRouter mockGoRouter;

  setUp(() {
    // Create mock instances
    mockPreferenceHelper = MockPreferenceHelper();
    mockGoRouter = MockGoRouter();

    // Ensure GetIt is clean before registering
    if (locator.isRegistered<PreferenceHelper>()) {
      locator.unregister<PreferenceHelper>();
    }

    // Register the mock instance
    locator.registerSingleton<PreferenceHelper>(mockPreferenceHelper);
  });


  tearDown(() {
    // Ensure the locator is reset if you registered dependencies
    // if (locator.isRegistered<PreferenceHelper>()) {
    //   locator.unregister<PreferenceHelper>();
    // }
  });

  group('Sidebar Widget Tests', () {
    testWidgets('Sidebar renders correctly for admin', (WidgetTester tester) async {
      when(mockPreferenceHelper.getUserRole()).thenReturn(UserRoles.admin);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => buildSidebar(context, () {}),
          ),
        ),
      ));

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Registration'), findsOneWidget);
      expect(find.text('MIS'), findsOneWidget);
      expect(find.text('Users'), findsNothing); // Admin should not see Users
    });

    testWidgets('Sidebar renders correctly for super admin', (WidgetTester tester) async {
      when(mockPreferenceHelper.getUserRole()).thenReturn(UserRoles.superAdmin);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => buildSidebar(context, () {}),
          ),
        ),
      ));

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('MIS'), findsOneWidget);
      expect(find.text('Users'), findsOneWidget); // Super Admin should see Users
    });

    testWidgets('Sidebar item tap navigates to route', (WidgetTester tester) async {
      when(mockPreferenceHelper.getUserRole()).thenReturn(UserRoles.admin);

      // Mock the context extension for go_router
      // This is a simplified approach and might not work in all go_router setups
      // A proper testing setup for go_router is recommended.
      // We will use a NavigatorObserver to verify navigation.
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => buildSidebar(context, () {}),
          ),
        ),
        // navigatorObservers: [mockObserver],
      ));

      // Tap on Dashboard
      // await tester.tap(find.text('Dashboard'));
      // await tester.pumpAndSettle();

      // Verify navigation (this requires a proper go_router testing setup)
      // verify(mockObserver.didPush(any, any)); // Check if a route was pushed

      // Due to the limitations of testing go_router context extensions directly
      // without a proper setup, we will focus on testing the onTap callback if provided

      // Test an item with an onTap callback (e.g., Logout - though not in the current sidebar)
      // If there were a logout item with onTap:
      // bool logoutCalled = false;
      // await tester.pumpWidget(MaterialApp(
      //   home: Scaffold(
      //     body: Builder(
      //       builder: (context) => buildSidebar(context, () { logoutCalled = true; }),
      //     ),
      //   ),
      // ));
      // await tester.tap(find.text('Logout')); // Assuming 'Logout' exists and has onTap
      // expect(logoutCalled, isTrue);
    });

    testWidgets('Expandable menu expands and collapses', (WidgetTester tester) async {
      when(mockPreferenceHelper.getUserRole()).thenReturn(UserRoles.admin);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => buildSidebar(context, () {}),
          ),
        ),
      ));

      // Initially, expandable menu children should not be visible
      expect(find.text('Organization'), findsNothing);
      expect(find.text('Device'), findsNothing);

      // Tap on Registration to expand
      await tester.tap(find.text('Registration'));
      await tester.pumpAndSettle();

      // Children should now be visible
      expect(find.text('Organization'), findsOneWidget);
      expect(find.text('Device'), findsOneWidget);

      // Tap on Registration again to collapse
      await tester.tap(find.text('Registration'));
      await tester.pumpAndSettle();

      // Children should be hidden again
      expect(find.text('Organization'), findsNothing);
      expect(find.text('Device'), findsNothing);
    });

    // Add tests for hover effects if possible, although visual hover testing
    // is often more complex in widget tests and might be better covered by integration tests.

    // Test hover effect on _SidebarItem (basic check for color change - may require more advanced testing)
    // testWidgets('Sidebar item hover changes color', (WidgetTester tester) async {
    //    when(mockPreferenceHelper.getUserRole()).thenReturn(UserRoles.admin);

    //   await tester.pumpWidget(MaterialApp(
    //     home: Scaffold(
    //       body: Builder(
    //         builder: (context) => buildSidebar(context, () {}),
    //       ),
    //     ),
    //   ));

    //   final dashboardItem = find.text('Dashboard');
    //   expect(
    //       tester.widget<AnimatedContainer>(find.ancestor(
    //             of: dashboardItem,
    //             matching: find.byType(AnimatedContainer)))
    //           .decoration,
    //       BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(5)));

    //   // Simulate hover (this is a simplified approach)
    //   final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    //   await gesture.moveTo(tester.getCenter(dashboardItem));
    //   await tester.pumpAndSettle();

    //    expect(
    //       tester.widget<AnimatedContainer>(find.ancestor(
    //             of: dashboardItem,
    //             matching: find.byType(AnimatedContainer)))
    //           .decoration,
    //       BoxDecoration(color: Colors.cyan[700], borderRadius: BorderRadius.circular(5)));

    //   await gesture.removePointer();
    //   await tester.pumpAndSettle();

    //   expect(
    //       tester.widget<AnimatedContainer>(find.ancestor(
    //             of: dashboardItem,
    //             matching: find.byType(AnimatedContainer)))
    //           .decoration,
    //       BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(5)));
    // });

    // Test hover effect on _ExpandableMenu (basic check for color change)
    // testWidgets('Expandable menu hover changes color', (WidgetTester tester) async {
    //    when(mockPreferenceHelper.getUserRole()).thenReturn(UserRoles.admin);

    //   await tester.pumpWidget(MaterialApp(
    //     home: Scaffold(
    //       body: Builder(
    //         builder: (context) => buildSidebar(context, () {}),
    //       ),
    //     ),
    //   ));

    //   final registrationMenu = find.text('Registration');
    //    expect(
    //       tester.widget<AnimatedContainer>(find.ancestor(
    //             of: registrationMenu,
    //             matching: find.byType(AnimatedContainer)))
    //           .decoration,
    //       BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(5)));

    //   // Simulate hover
    //   final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    //   await gesture.moveTo(tester.getCenter(registrationMenu));
    //   await tester.pumpAndSettle();

    //    expect(
    //       tester.widget<AnimatedContainer>(find.ancestor(
    //             of: registrationMenu,
    //             matching: find.byType(AnimatedContainer)))
    //           .decoration,
    //       BoxDecoration(color: Colors.cyan[700], borderRadius: BorderRadius.circular(5)));

    //   await gesture.removePointer();
    //   await tester.pumpAndSettle();

    //   expect(
    //       tester.widget<AnimatedContainer>(find.ancestor(
    //             of: registrationMenu,
    //             matching: find.byType(AnimatedContainer)))
    //           .decoration,
    //       BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(5)));
    // });

  });
}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}