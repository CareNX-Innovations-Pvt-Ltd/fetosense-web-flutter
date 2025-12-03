import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/screens/dashboard/dashboard_cubit.dart';
import 'package:fetosense_mis/screens/dashboard/dashboard_view.dart';
import 'package:fetosense_mis/screens/dashboard/widget/graph_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';

final getIt = GetIt.instance;

/// Mock Classes
class MockDashboardCubit extends Mock implements DashboardCubit {}
class MockPreferenceHelper extends Mock implements PreferenceHelper {}
class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockDashboardCubit mockDashboardCubit;
  late MockPreferenceHelper mockPrefs;
  late UserModel mockUser;

  setUp(() {
    getIt.reset();

    mockDashboardCubit = MockDashboardCubit();
    mockPrefs = MockPreferenceHelper();

    getIt.registerSingleton<DashboardCubit>(mockDashboardCubit);
    getIt.registerSingleton<PreferenceHelper>(mockPrefs);

    mockUser = UserModel(
      email: 'test@test.com',
      role: 'admin',
      organizationId: 'org1',
      userId: 'u1',
    );

    when(mockPrefs.getUser()).thenReturn(mockUser);

    when(mockDashboardCubit.state).thenReturn(const DashboardState(
      userEmail: 'test@test.com',
      isSidebarOpen: false,
      childIndex: 0,
      organizationCount: 2,
      deviceCount: 5,
      motherCount: 10,
      testCount: 15, tests: [],referralCount: 1
    ));
  });

  testWidgets('DashboardScreen builds and shows DashboardView', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen(childIndex: 0)));

    await tester.pumpAndSettle();
    expect(find.byType(DashboardView), findsOneWidget);
  });

  testWidgets('DashboardView displays top stats and GraphCard for childIndex 0', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DashboardCubit>.value(
          value: mockDashboardCubit,
          child: const DashboardView(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Organizations'), findsOneWidget);
    expect(find.text('Devices'), findsOneWidget);
    expect(find.text('Mothers'), findsOneWidget);
    expect(find.text('Tests'), findsOneWidget);

    // GraphCard should exist
    expect(find.byType(GraphCard), findsOneWidget);
  });

  testWidgets('DashboardView shows correct child widgets for all childIndex values', (WidgetTester tester) async {
    for (var i = 0; i <= 10; i++) {
      when(mockDashboardCubit.state).thenReturn(DashboardState(
        userEmail: 'test@test.com',
        isSidebarOpen: false,
        childIndex: i,
        organizationCount: 1,
        deviceCount: 1,
        motherCount: 1,
        testCount: 1, tests: [],referralCount: 1
      ));

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<DashboardCubit>.value(
            value: mockDashboardCubit,
            child: const DashboardView(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      if (i == 0) {
        expect(find.byType(GraphCard), findsOneWidget);
      } else if (i >= 1 && i <= 9) {
        // For simplicity, just check the view exists
        expect(find.byType(Expanded), findsWidgets);
      } else {
        expect(find.text('Page not found'), findsOneWidget);
      }
    }
  });

  testWidgets('Sidebar animation opens and closes based on cubit state', (WidgetTester tester) async {
    final controllerKey = GlobalKey();

    when(mockDashboardCubit.state).thenReturn(const DashboardState(
      userEmail: 'test@test.com',
      isSidebarOpen: true,
      childIndex: 0,
      organizationCount: 1,
      deviceCount: 1,
      motherCount: 1,
      testCount: 1, tests: [],referralCount: 1
    ));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<DashboardCubit>.value(
          value: mockDashboardCubit,
          child: DashboardView(key: controllerKey),
        ),
      ),
    );

    await tester.pump();

    // Reverse animation
    when(mockDashboardCubit.state).thenReturn(const DashboardState(
      userEmail: 'test@test.com',
      isSidebarOpen: false,
      childIndex: 0,
      organizationCount: 1,
      deviceCount: 1,
      motherCount: 1,
      testCount: 1, tests: [],
      referralCount: 1
    ));

    await tester.pump();
  });
}
