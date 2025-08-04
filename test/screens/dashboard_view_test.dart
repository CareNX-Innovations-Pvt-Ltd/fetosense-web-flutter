import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/screens/dashboard/dashboard_cubit.dart';
import 'package:fetosense_mis/screens/dashboard/dashboard_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

final getIt = GetIt.instance;

/// Mock Classes
class MockDashboardCubit extends Mock implements DashboardCubit {}
class MockPreferenceHelper extends Mock implements PreferenceHelper {}
class MockAppwriteService extends Mock implements AppwriteService {}
class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockDashboardCubit mockDashboardCubit;
  late MockPreferenceHelper mockPrefs;
  late MockAppwriteService mockAppwriteService;
  late MockAuthService mockAuthService;

  setUp(() {
    getIt.reset();

    mockDashboardCubit = MockDashboardCubit();
    mockPrefs = MockPreferenceHelper();
    mockAppwriteService = MockAppwriteService();
    mockAuthService = MockAuthService();

    getIt.registerSingleton<DashboardCubit>(mockDashboardCubit);
    getIt.registerSingleton<PreferenceHelper>(mockPrefs);
    getIt.registerSingleton<AppwriteService>(mockAppwriteService);
    getIt.registerSingleton<AuthService>(mockAuthService);

    when(mockPrefs.getUser()).thenReturn(UserModel(
      email: 'test@test.com',
      role: 'admin',
      organizationId: 'org1', userId: 'u1',
    ));

    when(mockDashboardCubit.state).thenReturn(const DashboardState(
      userEmail: 'test@test.com',
      isSidebarOpen: false,
      childIndex: 0,
      organizationCount: 2,
      deviceCount: 5,
      motherCount: 10,
      testCount: 15,
    ));
  });

  testWidgets('DashboardView displays stats and GraphCard for childIndex 0', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DashboardCubit>.value(
          value: mockDashboardCubit,
          child: const DashboardView(),
        ),
      ),
    );

    expect(find.text('Organizations'), findsOneWidget);
    expect(find.text('Devices'), findsOneWidget);
    expect(find.text('Mothers'), findsOneWidget);
    expect(find.text('Tests'), findsOneWidget);
  });

  testWidgets('DashboardScreen builds and initializes DashboardCubit', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: DashboardScreen(childIndex: 0),
      ),
    );

    // Wait for cubit init to settle
    await tester.pumpAndSettle();

    expect(find.byType(DashboardView), findsOneWidget);
  });
}
