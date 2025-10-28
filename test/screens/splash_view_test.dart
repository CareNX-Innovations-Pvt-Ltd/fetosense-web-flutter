import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/screens/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'organization_analytics_test.dart';

class MockPreferenceHelper extends Mock implements PreferenceHelper {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockPreferenceHelper mockPrefs;
  late MockGoRouter mockRouter;

  setUp(() {
    mockPrefs = MockPreferenceHelper();
    mockRouter = MockGoRouter();

    // Override locator
    locator.registerSingleton<PreferenceHelper>(mockPrefs);
  });

  tearDown(() {
    locator.reset();
  });

  testWidgets('SplashView navigates to dashboard when auto-login is true',
          (WidgetTester tester) async {
        when(() => mockPrefs.getAutoLogin()).thenReturn(true);

        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SplashView(),
                ),
                GoRoute(
                  path: '/dashboard',
                  builder: (_, __) => const Text('Dashboard'),
                ),
              ],
            ),
          ),
        );

        // Wait for the 2-second delay
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // Verify dashboard is shown
        expect(find.text('Dashboard'), findsOneWidget);
      });

  testWidgets('SplashView navigates to login when auto-login is false',
          (WidgetTester tester) async {
        when(() => mockPrefs.getAutoLogin()).thenReturn(false);

        await tester.pumpWidget(
          MaterialApp.router(
            routerConfig: GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (_, __) => const SplashView(),
                ),
                GoRoute(
                  path: '/login',
                  builder: (_, __) => const Text('Login'),
                ),
              ],
            ),
          ),
        );

        // Wait for the 2-second delay
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // Verify login is shown
        expect(find.text('Login'), findsOneWidget);
      });

  testWidgets('SplashView shows waiting screen initially',
          (WidgetTester tester) async {
        when(() => mockPrefs.getAutoLogin()).thenReturn(false);

        await tester.pumpWidget(
          const MaterialApp(home: SplashView()),
        );

        expect(find.byType(Image), findsOneWidget);
      });
}
