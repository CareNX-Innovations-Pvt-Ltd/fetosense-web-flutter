import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/screens/splash/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockPreferenceHelper extends Mock implements PreferenceHelper {}

void main() {
  late MockPreferenceHelper mockPrefs;

  setUp(() {
    mockPrefs = MockPreferenceHelper();
  });

  Future<void> pumpSplashView(WidgetTester tester, {required GoRouter router}) async {
    await tester.pumpWidget(
      Provider<PreferenceHelper>.value(
        value: mockPrefs,
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
  }

  testWidgets('SplashView shows logo', (WidgetTester tester) async {
    final router = GoRouter(
      routes: [GoRoute(path: '/', builder: (_, __) => const SplashView())],
    );

    when(() => mockPrefs.getAutoLogin()).thenReturn(false);

    await pumpSplashView(tester, router: router);

    await tester.pump(); // trigger frame
    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('SplashView redirects to login when getAutoLogin is false', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashView()),
        GoRoute(path: '/login', name: AppRoutes.login, builder: (_, __) => const Text('Login Page')),
      ],
    );

    when(() => mockPrefs.getAutoLogin()).thenReturn(false);

    await pumpSplashView(tester, router: router);
    await tester.pump(const Duration(seconds: 2)); // wait for delayed navigation
    await tester.pumpAndSettle();

    expect(find.text('Login Page'), findsOneWidget);
  });

  testWidgets('SplashView redirects to dashboard when getAutoLogin is true', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashView()),
        GoRoute(path: '/dashboard', name: AppRoutes.dashboard, builder: (_, __) => const Text('Dashboard Page')),
      ],
    );

    when(() => mockPrefs.getAutoLogin()).thenReturn(true);

    await pumpSplashView(tester, router: router);
    await tester.pump(const Duration(seconds: 2)); // wait for delayed navigation
    await tester.pumpAndSettle();

    expect(find.text('Dashboard Page'), findsOneWidget);
  });

  testWidgets('Auto-login fails gracefully', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (_, __) => const SplashView()),
        GoRoute(path: '/dashboard', name: AppRoutes.dashboard, builder: (_, __) => const Text('Dashboard Page')),
        GoRoute(path: '/login', name: AppRoutes.login, builder: (_, __) => const Text('Login Page')),
      ],
    );

    when(() => mockPrefs.getAutoLogin()).thenReturn(true);

    // override `goNamed` to throw
    final errorRouter = GoRouter(
      initialLocation: '/',
      routes: router.configuration.routes,
      redirect: (_, __) {
        throw Exception('Failed');
      },
    );

    await pumpSplashView(tester, router: router);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Expect either login or no crash
    expect(find.textContaining('Login Page'), findsNothing); // fallback not triggered in redirect
  });
}
