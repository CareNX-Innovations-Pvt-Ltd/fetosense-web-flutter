part of 'login_cubit.dart';

@immutable
sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}

class LoginTogglePassword extends LoginState {
  final bool obscurePassword;
  LoginTogglePassword(this.obscurePassword);
}
