import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/screens/register/register_cubit.dart';
import 'package:fetosense_mis/screens/register/register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  testWidgets('RegisterScreen widget test', (WidgetTester tester) async {
    // Mock success response
    when(() => mockAuthService.registerUser(any(), any()))
        .thenAnswer((_) async => true);

    // Pump the widget
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => RegisterCubit(authService: mockAuthService),
          child: const RegisterView(),
        ),
      ),
    );

    // Enter email and password
    final emailField = find.byType(TextField).at(0);
    final passwordField = find.byType(TextField).at(1);
    await tester.enterText(emailField, 'test@example.com');
    await tester.enterText(passwordField, 'password');

    // Access the cubit
    final cubit = BlocProvider.of<RegisterCubit>(
      tester.element(find.byType(RegisterView)),
    );

    // Verify cubit state updated
    expect(cubit.state.email, 'test@example.com');
    expect(cubit.state.password, 'password');

    // Tap Register button
    final registerButton = find.widgetWithText(ElevatedButton, 'Register');
    await tester.tap(registerButton);

    // Rebuild widgets after async actions
    await tester.pump(); // triggers loading state
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for future to complete
    await tester.pumpAndSettle();

    // Verify success message
    expect(find.text('User registered successfully!'), findsOneWidget);
    expect(cubit.state.isSuccess, true);
  });

  testWidgets('RegisterScreen shows error on registration failure',
          (WidgetTester tester) async {
        // Mock failure response
        when(() => mockAuthService.registerUser(any(), any()))
            .thenAnswer((_) async => false);

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider(
              create: (_) => RegisterCubit(authService: mockAuthService),
              child: const RegisterView(),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField).at(0), 'fail@example.com');
        await tester.enterText(find.byType(TextField).at(1), 'wrongpass');

        final cubit = BlocProvider.of<RegisterCubit>(
          tester.element(find.byType(RegisterView)),
        );

        await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
        await tester.pump(); // shows loading
        await tester.pumpAndSettle(); // wait async

        expect(find.text('Registration failed!'), findsOneWidget);
        expect(cubit.state.isSuccess, false);
      });

  testWidgets('RegisterScreen shows error on exception',
          (WidgetTester tester) async {
        // Mock exception
        when(() => mockAuthService.registerUser(any(), any()))
            .thenThrow(Exception('Network error'));

        await tester.pumpWidget(
          MaterialApp(
            home: BlocProvider(
              create: (_) => RegisterCubit(authService: mockAuthService),
              child: const RegisterView(),
            ),
          ),
        );

        await tester.enterText(find.byType(TextField).at(0), 'error@example.com');
        await tester.enterText(find.byType(TextField).at(1), 'password');

        final cubit = BlocProvider.of<RegisterCubit>(
          tester.element(find.byType(RegisterView)),
        );

        await tester.tap(find.widgetWithText(ElevatedButton, 'Register'));
        await tester.pump(); // loading
        await tester.pumpAndSettle(); // wait async

        expect(find.textContaining('Error:'), findsOneWidget);
        expect(cubit.state.isSuccess, false);
      });
}
