import 'package:fetosense_mis/screens/dashboard/dashboard_view.dart';
import 'package:fetosense_mis/screens/login/login_view.dart';
import 'package:fetosense_mis/screens/register/register_view.dart';
import 'package:fetosense_mis/screens/splash/splash_view.dart';
import 'package:go_router/go_router.dart';

/// Defines route names used throughout the Fetosense MIS application.
///
/// The [AppRoutes] class provides static constants for all named routes in the app.
abstract class AppRoutes {
  /// Route for the splash screen.
  static const splash = '/';

  /// Route for the login screen.
  static const login = '/login';

  /// Route for the home screen.
  static const home = '/home';

  /// Route for the registration screen.
  static const register = '/register';

  /// Route for the dashboard screen.
  static const dashboard = '/dashboard';

  /// Route for the organization registration screen.
  static const organizationRegistration = '/organization-registration';

  /// Route for the device registration screen.
  static const deviceRegistration = '/device-registration';

  /// Route for the QR code generation screen.
  static const generateQr = '/generate-qr';

  /// Route for the MIS organizations screen.
  static const misOrganizations = '/mis-organizations';

  /// Route for the MIS devices screen.
  static const misDevices = '/mis-devices';

  /// Route for the MIS doctors screen.
  static const misDoctors = '/mis-doctors';

  /// Route for the MIS mothers screen.
  static const misMothers = '/mis-mothers';

  /// Route for the analytics doctors screen.
  static const analyticsDoctors = '/analytics-doctors';

  /// Route for the analytics organizations screen.
  static const analyticsOrganizations = '/analytics-organizations';
}

/// Configures the application's routing using [GoRouter].
///
/// The [AppRouter] class sets up all routes and their corresponding views.
class AppRouter {
  /// The [GoRouter] instance used for navigation.
  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      /// Route for the splash screen.
      GoRoute(
        path: AppRoutes.splash,
        name: '/',
        builder: (context, state) => const SplashView(),
      ),

      /// Route for the login screen.
      GoRoute(
        path: AppRoutes.login,
        name: '/login',
        builder: (context, state) => const LoginView(),
      ),

      /// Route for the registration screen.
      GoRoute(
        path: AppRoutes.register,
        name: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      /// Route for the dashboard screen.
      GoRoute(
        path: AppRoutes.dashboard,
        name: '/dashboard',
        builder: (context, state) => const DashboardScreen(childIndex: 0),
      ),

      /// Route for the organization registration screen.
      GoRoute(
        path: AppRoutes.organizationRegistration,
        name: '/organization-registration',
        builder: (context, state) => const DashboardScreen(childIndex: 1),
      ),

      /// Route for the device registration screen.
      GoRoute(
        path: AppRoutes.deviceRegistration,
        name: '/device-registration',
        builder: (context, state) => const DashboardScreen(childIndex: 2),
      ),

      /// Route for the QR code generation screen.
      GoRoute(
        path: AppRoutes.generateQr,
        name: '/generate-qr',
        builder: (context, state) => const DashboardScreen(childIndex: 3),
      ),

      /// Route for the MIS organizations screen.
      GoRoute(
        path: AppRoutes.misOrganizations,
        name: '/mis-organizations',
        builder: (context, state) => const DashboardScreen(childIndex: 4),
      ),

      /// Route for the MIS devices screen.
      GoRoute(
        path: AppRoutes.misDevices,
        name: '/mis-devices',
        builder: (context, state) => const DashboardScreen(childIndex: 5),
      ),

      /// Route for the MIS doctors screen.
      GoRoute(
        path: AppRoutes.misDoctors,
        name: '/mis-doctors',
        builder: (context, state) => const DashboardScreen(childIndex: 6),
      ),

      /// Route for the MIS mothers screen.
      GoRoute(
        path: AppRoutes.misMothers,
        name: '/mis-mothers',
        builder: (context, state) => const DashboardScreen(childIndex: 7),
      ),

      /// Route for the analytics doctors screen.
      GoRoute(
        path: AppRoutes.analyticsDoctors,
        name: '/analytics-doctors',
        builder: (context, state) => const DashboardScreen(childIndex: 8),
      ),

      /// Route for the analytics organizations screen.
      GoRoute(
        path: AppRoutes.analyticsOrganizations,
        name: '/analytics-organizations',
        builder: (context, state) => const DashboardScreen(childIndex: 9),
      ),
    ],
  );
}
