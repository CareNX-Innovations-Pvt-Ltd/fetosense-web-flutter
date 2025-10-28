import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/screens/register/register_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock AuthService
class MockAuthService extends Mock implements AuthService {}

void main() {
  late RegisterCubit cubit;
  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthService = MockAuthService();
    cubit = RegisterCubit(authService: mockAuthService);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is correct', () {
    expect(cubit.state.email, '');
    expect(cubit.state.password, '');
    expect(cubit.state.isLoading, false);
    expect(cubit.state.isSuccess, false);
    expect(cubit.state.message, '');
  });

  group('emailChanged', () {
    test('updates email in state', () {
      cubit.emailChanged('test@example.com');
      expect(cubit.state.email, 'test@example.com');
    });
  });

  group('passwordChanged', () {
    test('updates password in state', () {
      cubit.passwordChanged('123456');
      expect(cubit.state.password, '123456');
    });
  });

  group('registerUser', () {
    test('emits loading then success when registration succeeds', () async {
      cubit.emailChanged('user@test.com');
      cubit.passwordChanged('password');

      when(() => mockAuthService.registerUser('user@test.com', 'password'))
          .thenAnswer((_) async => true);

      final expectedStates = [
        cubit.state.copyWith(isLoading: true, message: ''),
        cubit.state.copyWith(
          isLoading: false,
          isSuccess: true,
          message: 'User registered successfully!',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.registerUser();
    });

    test('emits loading then failure when registration fails', () async {
      cubit.emailChanged('user@test.com');
      cubit.passwordChanged('password');

      when(() => mockAuthService.registerUser('user@test.com', 'password'))
          .thenAnswer((_) async => false);

      final expectedStates = [
        cubit.state.copyWith(isLoading: true, message: ''),
        cubit.state.copyWith(
          isLoading: false,
          isSuccess: false,
          message: 'Registration failed!',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.registerUser();
    });

    test('emits loading then error when exception is thrown', () async {
      cubit.emailChanged('user@test.com');
      cubit.passwordChanged('password');

      when(() => mockAuthService.registerUser('user@test.com', 'password'))
          .thenThrow(Exception('Network Error'));

      final expectedStates = [
        cubit.state.copyWith(isLoading: true, message: ''),
        cubit.state.copyWith(
          isLoading: false,
          message: 'Error: Exception: Network Error',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expectedStates));

      await cubit.registerUser();
    });
  });
}
