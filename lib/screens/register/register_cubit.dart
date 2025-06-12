import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

/// Cubit for managing the state and logic of the registration screen.
///
/// Handles user input for email and password, and manages the registration process using [AuthService].
class RegisterCubit extends Cubit<RegisterState> {
  /// The authentication service used for registering users.
  final AuthService authService;

  /// Creates a [RegisterCubit] with the given [authService].
  RegisterCubit({required this.authService}) : super(const RegisterState());

  /// Updates the email in the state.
  void emailChanged(String email) {
    emit(state.copyWith(email: email));
  }

  /// Updates the password in the state.
  void passwordChanged(String password) {
    emit(state.copyWith(password: password));
  }

  /// Registers a new user using the current email and password in the state.
  ///
  /// Emits loading, success, or error states based on the registration result.
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
