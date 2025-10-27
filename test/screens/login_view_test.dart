import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/screens/login/login_cubit.dart';
import 'package:fetosense_mis/screens/login/login_view.dart';
import 'package:fetosense_mis/screens/login/widgets/captcha_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';


class MockAuthService extends Mock implements AuthService {}
class MockLoginCubit extends Mock implements LoginCubit {}

void main() {
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
  });

  testWidgets('LoginView interaction coverage', (WidgetTester tester) async {
    // Provide a real cubit with the mocked auth service
    final cubit = LoginCubit(mockAuthService);

    // Build the LoginView
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<LoginCubit>.value(
          value: cubit,
          child: const LoginViewBody(),
        ),
      ),
    );

    // Verify initial UI is present
    expect(find.text("Welcome Back 👋"), findsOneWidget);
    expect(find.text("Login to your account"), findsOneWidget);

    // Enter username & password
    await tester.enterText(find.byType(TextField).first, 'test@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password123');

    // Toggle password visibility
    await tester.tap(find.byIcon(Icons.visibility_off));
    await tester.pump();
    expect(cubit.obscurePassword, false);

    // Press login button without CAPTCHA checked
    await tester.tap(find.text("Login"));
    await tester.pumpAndSettle();
    expect(find.text("Please verify you're not a robot."), findsOneWidget);

    // Simulate checking CAPTCHA
    final state = tester.state<LoginViewBodyState>(find.byType(LoginViewBody));
    state.setState(() {
      state.isChecked = true;
    });
    await tester.pump();

    // Mock loginUser to just complete without error
    when(() => mockAuthService.loginUser(any(), any()))
        .thenAnswer((_) async => true);

    // Press login button with CAPTCHA checked
    await tester.tap(find.text("Login"));
    await tester.pumpAndSettle();

    // You can also simulate a login failure
    cubit.emit(LoginFailure('Invalid credentials'));
    await tester.pump();
    expect(find.text("Invalid credentials"), findsOneWidget);

    // Loading state
    cubit.emit(LoginLoading());
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
