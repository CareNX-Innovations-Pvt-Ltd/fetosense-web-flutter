part of 'register_cubit.dart';

@immutable
class RegisterState extends Equatable {
  final String email;
  final String password;
  final String message;
  final bool isLoading;
  final bool isSuccess;

  const RegisterState({
    this.email = '',
    this.password = '',
    this.message = '',
    this.isLoading = false,
    this.isSuccess = false,
  });

  // Create a copy of the current state with updated fields
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
