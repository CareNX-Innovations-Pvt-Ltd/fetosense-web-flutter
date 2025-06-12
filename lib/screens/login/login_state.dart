part of 'login_cubit.dart';

/// Base class for all login states.
@immutable
sealed class LoginState {}

/// State representing the initial state of the login screen.
class LoginInitial extends LoginState {}

/// State representing that a login attempt is in progress.
class LoginLoading extends LoginState {}

/// State representing a successful login.
class LoginSuccess extends LoginState {}

/// State representing a failed login attempt.
class LoginFailure extends LoginState {
  /// The error message describing the failure.
  final String message;
  LoginFailure(this.message);
}

/// State representing a change in password visibility.
class LoginTogglePassword extends LoginState {
  /// Whether the password is currently obscured.
  final bool obscurePassword;
  LoginTogglePassword(this.obscurePassword);
}
