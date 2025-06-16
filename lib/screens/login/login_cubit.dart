import 'package:bloc/bloc.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(LoginTogglePassword(obscurePassword));
  }

  Future<void> loginUser(BuildContext context) async {
    emit(LoginLoading());
    try {
      await AuthService().loginUser(
        usernameController.text,
        passwordController.text,
      );
      if (context.mounted) {
        emit(LoginSuccess());
        locator<PreferenceHelper>().setAutoLogin(true);
        context.go(AppRoutes.dashboard);
      }
    } catch (e) {
      emit(LoginFailure("Something went wrong."));
    }
  }
}
