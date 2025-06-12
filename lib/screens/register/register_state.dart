part of 'register_cubit.dart';

/// State class for the registration screen.
///
/// Holds the email, password, message, loading, and success state for the registration form.
/// Used by [RegisterCubit] to manage the UI state for user registration.
@immutable
class RegisterState extends Equatable {
  /// The email entered by the user.
  final String email;

  /// The password entered by the user.
  final String password;

  /// The message to display (success or error).
  final String message;

  /// Whether the registration process is currently loading.
  final bool isLoading;

  /// Whether the registration was successful.
  final bool isSuccess;

  /// Creates a [RegisterState] with the given values.
  const RegisterState({
    this.email = '',
    this.password = '',
    this.message = '',
    this.isLoading = false,
    this.isSuccess = false,
  });

  /// Creates a copy of the current state with updated fields.
  RegisterState copyWith({
    String? email,
    String? password,
    String? message,
    bool? isLoading,
    bool? isSuccess,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object> get props => [email, password, message, isLoading, isSuccess];
}
