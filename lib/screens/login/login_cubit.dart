import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'login_state.dart';

/// Cubit for managing the state and logic of the login screen.
///
/// Handles user input, password visibility, and authentication logic.
class LoginCubit extends Cubit<LoginState> {
  /// Creates a [LoginCubit] and initializes the state.
  LoginCubit() : super(LoginInitial());

  /// Controller for the username input field.
  final usernameController = TextEditingController();

  /// Controller for the password input field.
  final passwordController = TextEditingController();

  /// Whether the password is currently obscured.
  bool obscurePassword = true;

  /// Toggles the visibility of the password field.
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(LoginTogglePassword(obscurePassword));
  }

  /// Attempts to log in the user with the provided credentials.
  ///
  /// Emits [LoginLoading], [LoginSuccess], or [LoginFailure] based on the result.
  /// Navigates to the dashboard on success, or shows an error on failure.
  Future<void> loginUser(BuildContext context) async {
    emit(LoginLoading());
    try {
      final bool success = await AuthService().loginUser(
        usernameController.text,
        passwordController.text,
      );
      if (context.mounted && success) {
        emit(LoginSuccess());
        locator<PreferenceHelper>().setAutoLogin(true);
        context.go(AppRoutes.dashboard);
      } else {
        emit(LoginFailure('Doctors/User cannot access the dashboard.'));
      }
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }
}
