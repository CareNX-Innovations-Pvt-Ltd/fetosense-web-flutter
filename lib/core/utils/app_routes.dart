import 'package:fetosense_mis/screens/dashboard/dashboard_view.dart';
import 'package:fetosense_mis/screens/login/login_view.dart';
import 'package:fetosense_mis/screens/register/register_view.dart';
import 'package:fetosense_mis/screens/splash/splash_view.dart';
import 'package:go_router/go_router.dart';

abstract class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const organizationRegistration = '/organization-registration';
  static const deviceRegistration = '/device-registration';
  static const generateQr = '/generate-qr';
  static const misOrganizations = '/mis-organizations';
  static const misDevices = '/mis-devices';
  static const misDoctors = '/mis-doctors';
  static const misMothers = '/mis-mothers';
  static const analyticsDoctors = '/analytics-doctors';
  static const analyticsOrganizations = '/analytics-organizations';
}

class AppRouter {
  late final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: '/',
        builder: (context, state) => const SplashView(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: '/login',
        builder: (context, state) => const LoginView(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        name: '/dashboard',
        builder: (context, state) => const DashboardScreen(childIndex: 0),
      ),
      GoRoute(
        path: AppRoutes.organizationRegistration,
        name: '/organization-registration',
        builder: (context, state) => const DashboardScreen(childIndex: 1),
      ),
      GoRoute(
        path: AppRoutes.deviceRegistration,
        name: '/device-registration',
        builder: (context, state) => const DashboardScreen(childIndex: 2),
      ),
      GoRoute(
        path: AppRoutes.generateQr,
        name: '/generate-qr',
        builder: (context, state) => const DashboardScreen(childIndex: 3),
      ),
      GoRoute(
        path: AppRoutes.misOrganizations,
        name: '/mis-organizations',
        builder: (context, state) => const DashboardScreen(childIndex: 4),
      ),
      GoRoute(
        path: AppRoutes.misDevices,
        name: '/mis-devices',
        builder: (context, state) => const DashboardScreen(childIndex: 5),
      ),
      GoRoute(
        path: AppRoutes.misDoctors,
        name: '/mis-doctors',
        builder: (context, state) => const DashboardScreen(childIndex: 6),
      ),
      GoRoute(
        path: AppRoutes.misMothers,
        name: '/mis-mothers',
        builder: (context, state) => const DashboardScreen(childIndex: 7),
      ),
      GoRoute(
        path: AppRoutes.analyticsDoctors,
        name: '/analytics-doctors',
        builder: (context, state) => const DashboardScreen(childIndex: 8),
      ),
      GoRoute(
        path: AppRoutes.analyticsOrganizations,
        name: '/analytics-organizations',
        builder: (context, state) => const DashboardScreen(childIndex: 9),
      ),
    ],
  );
}
