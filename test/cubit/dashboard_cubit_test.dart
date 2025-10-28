import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:fetosense_mis/screens/dashboard/dashboard_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import '../screens/organization_analytics_test.dart';

import 'package:go_router/go_router.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockDatabases extends Mock implements Databases {}

class MockPreferenceHelper extends Mock implements PreferenceHelper {}

class MockUser extends Mock implements models.User {}

void main() {
  late DashboardCubit cubit;
  late MockAuthService mockAuth;
  late MockDatabases mockDb;
  late MockPreferenceHelper mockPrefs;
  late models.User appwriteUser;

  setUp(() {
    mockAuth = MockAuthService();
    mockDb = MockDatabases();
    mockPrefs = MockPreferenceHelper();

    // Override locator services
    locator.registerSingleton<AuthService>(mockAuth);
    locator.registerSingleton<PreferenceHelper>(mockPrefs);
    locator.registerSingleton<AppwriteService>(AppwriteService());

    appwriteUser = MockUser();
    when(() => appwriteUser.email).thenReturn('test@example.com');
  });

  tearDown(() {
    locator.reset();
  });

  test('initial state', () {
    cubit = DashboardCubit(
      authService: mockAuth,
      databases: mockDb,
      prefs: mockPrefs,
    );

    expect(cubit.state.userEmail, '');
    expect(cubit.state.isSidebarOpen, false);
    expect(cubit.state.childIndex, 0);
  });

  test('toggleSidebar flips state', () {
    cubit = DashboardCubit(
      authService: mockAuth,
      databases: mockDb,
      prefs: mockPrefs,
    );

    final initial = cubit.state.isSidebarOpen;
    cubit.toggleSidebar();
    expect(cubit.state.isSidebarOpen, !initial);
  });

  test('changeChildIndex updates state', () {
    cubit = DashboardCubit(
      authService: mockAuth,
      databases: mockDb,
      prefs: mockPrefs,
    );

    cubit.changeChildIndex(2);
    expect(cubit.state.childIndex, 2);
  });

  test('getUserData with null user returns early', () async {
    when(() => mockPrefs.getUser()).thenReturn(null);

    cubit = DashboardCubit(
      authService: mockAuth,
      databases: mockDb,
      prefs: mockPrefs,
    );

    await cubit.getUserData();
    expect(cubit.state.userEmail, '');
  });

  test('getUserData success for admin user', () async {
    final userData = UserModel(
      userId: 'userId',
      email: 'email',
      role: UserRoles.admin, // make sure this matches your enum
      organizationId: 'organizationId',
    );

    when(() => mockPrefs.getUser()).thenReturn(userData);
    when(() => mockAuth.getCurrentUser()).thenAnswer((_) async => appwriteUser);

    when(
          () => mockDb.listDocuments(
        databaseId: any(named: 'databaseId'),
        collectionId: any(named: 'collectionId'),
        queries: any(named: 'queries'),
      ),
    ).thenAnswer((_) async => models.DocumentList(total: 5, documents: []));

    cubit = DashboardCubit(
      authService: mockAuth,
      databases: mockDb,
      prefs: mockPrefs,
    );

    await cubit.getUserData();

    expect(cubit.state.userEmail, 'test@example.com');
    expect(cubit.state.organizationCount, 5);
    expect(cubit.state.motherCount, 5);
  });

  test('getUserData success for restricted user', () async {
    final userData = UserModel(
      userId: 'userId',
      email: 'email',
      role: 'restricted', // non-admin role
      organizationId: 'organizationId',
    );

    when(() => mockPrefs.getUser()).thenReturn(userData);
    when(() => mockAuth.getCurrentUser()).thenAnswer((_) async => appwriteUser);

    when(
          () => mockDb.listDocuments(
        databaseId: any(named: 'databaseId'),
        collectionId: any(named: 'collectionId'),
        queries: any(named: 'queries'),
      ),
    ).thenAnswer((_) async => models.DocumentList(total: 2, documents: []));

    cubit = DashboardCubit(
      authService: mockAuth,
      databases: mockDb,
      prefs: mockPrefs,
    );

    await cubit.getUserData();

    expect(cubit.state.userEmail, 'test@example.com');
    expect(cubit.state.organizationCount, 2);
  });

  testWidgets('logout calls AuthService and navigates', (tester) async {
    cubit = DashboardCubit(
      authService: mockAuth,
      databases: mockDb,
      prefs: mockPrefs,
    );

    final mockContext = GlobalKey<NavigatorState>();
    final goRouter = GoRouter(
      initialLocation: '/',
      navigatorKey: mockContext,
      routes: [],
    );

    when(() => mockAuth.logoutUser()).thenAnswer((_) async {});

    await tester.pumpWidget(MaterialApp.router(routerConfig: goRouter));

    await cubit.logout(mockContext.currentContext!);
    verify(() => mockAuth.logoutUser()).called(1);
  });
}
