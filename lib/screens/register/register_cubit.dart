import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService authService;

  RegisterCubit({required this.authService}) : super(const RegisterState());

  // Update email in state
  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  // Update password in state
  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  // Register user method
  Future<void> registerUser() async {
    // Show loading state
    emit(state.copyWith(isLoading: true, message: ''));

    try {
      // Call the authentication service
      bool success = await authService.registerUser(
        state.email,
        state.password,
      );

      // Update state based on result
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: success,
          message:
              success
                  ? 'User registered successfully!'
                  : 'Registration failed!',
        ),
      );
    } catch (e) {
      // Handle errors
      emit(state.copyWith(isLoading: false, message: 'Error: ${e.toString()}'));
    }
  }
}
