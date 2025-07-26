import 'package:bloc_test/bloc_test.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/screens/login/login_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([AuthService, PreferenceHelper, GoRouter, BuildContext])
void main() {
  group('LoginCubit', () {
    late LoginCubit loginCubit;
    late MockAuthService mockAuthService;
    late MockPreferenceHelper mockPreferenceHelper;
    late MockBuildContext mockBuildContext;
    late MockGoRouter mockGoRouter;

    setUp(() {
      mockAuthService = MockAuthService();
      mockPreferenceHelper = MockPreferenceHelper();
      mockBuildContext = MockBuildContext();
      mockGoRouter = MockGoRouter();

      // Provide the mock instances to the dependency injection system
      locator.registerSingleton<AuthService>(mockAuthService);
      locator.registerSingleton<PreferenceHelper>(mockPreferenceHelper);

      // Mock the GoRouter extension on BuildContext
      when(mockGoRouter.go(any)).thenAnswer((_) {});
      when(mockBuildContext.mounted).thenReturn(true);

      loginCubit = LoginCubit(mockAuthService); // Pass the mocked instance
    });


    tearDown(() {
      loginCubit.close();
      // Unregister the singletons after each test
      locator.unregister<AuthService>();
      locator.unregister<PreferenceHelper>();
    });

    test('initial state is LoginInitial', () {
      expect(loginCubit.state, isA<LoginInitial>());
    });

    blocTest<LoginCubit, LoginState>(
      'emits LoginTogglePassword when togglePasswordVisibility is called',
      build: () => loginCubit,
      act: (cubit) => cubit.togglePasswordVisibility(),
      expect: () => [isA<LoginTogglePassword>()],
    );

    // blocTest<LoginCubit, LoginState>(
    //   'emits LoginLoading and then LoginSuccess and navigates on successful login',
    //   build: () {
    //     when(mockAuthService.loginUser(any, any))
    //         .thenAnswer((_) async => true);
    //     return loginCubit;
    //   },
    //   act: (cubit) async {
    //     cubit.usernameController.text = 'testuser';
    //     cubit.passwordController.text = 'password';
    //     await cubit.loginUser(mockBuildContext);
    //   },
    //   expect: () => [isA<LoginLoading>(), isA<LoginSuccess>()],
    //   verify: (_) {
    //     verify(mockAuthService.loginUser('testuser', 'password')).called(1);
    //     verify(mockPreferenceHelper.setAutoLogin(true)).called(1);
    //     verify(mockGoRouter.go(AppRoutes.dashboard)).called(1);
    //   },
    // );

    blocTest<LoginCubit, LoginState>(
      'emits LoginLoading and then LoginFailure on unsuccessful login',
      build: () {
        when(mockAuthService.loginUser(any, any))
            .thenAnswer((_) async => false);
        return loginCubit;
      },
      act: (cubit) async {
        cubit.usernameController.text = 'testuser';
        cubit.passwordController.text = 'password';
        await cubit.loginUser(mockBuildContext);
      },
      expect: () => [isA<LoginLoading>(), isA<LoginFailure>()],
      verify: (_) {
        verify(mockAuthService.loginUser('testuser', 'password')).called(1);
        verifyNever(mockPreferenceHelper.setAutoLogin(any));
        verifyNever(mockGoRouter.go(any));
      },
    );

    blocTest<LoginCubit, LoginState>(
      'emits LoginLoading and then LoginFailure on exception during login',
      build: () {
        when(mockAuthService.loginUser(any, any))
            .thenThrow(Exception('Login failed'));
        return loginCubit;
      },
      act: (cubit) async {
        cubit.usernameController.text = 'testuser';
        cubit.passwordController.text = 'password';
        await cubit.loginUser(mockBuildContext);
      },
      expect: () => [isA<LoginLoading>(), isA<LoginFailure>()],
      verify: (_) {
        verify(mockAuthService.loginUser('testuser', 'password')).called(1);
        verifyNever(mockPreferenceHelper.setAutoLogin(any));
        verifyNever(mockGoRouter.go(any));
      },
    );

    blocTest<LoginCubit, LoginState>(
      'does not navigate if context is not mounted',
      build: () {
        when(mockAuthService.loginUser(any, any))
            .thenAnswer((_) async => true);
        when(mockBuildContext.mounted).thenReturn(false);
        return loginCubit;
      },
      act: (cubit) async {
        cubit.usernameController.text = 'testuser';
        cubit.passwordController.text = 'password';
        await cubit.loginUser(mockBuildContext);
      },
      expect: () => [isA<LoginLoading>(), isA<LoginSuccess>()],
      verify: (_) {
        verify(mockAuthService.loginUser('testuser', 'password')).called(1);
        verify(mockPreferenceHelper.setAutoLogin(true)).called(1);
        verifyNever(mockGoRouter.go(any));
      },
    );
  });
}
