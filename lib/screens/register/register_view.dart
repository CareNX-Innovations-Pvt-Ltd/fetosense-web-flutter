import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/screens/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The main screen for user registration.
///
/// Provides a [RegisterCubit] to manage registration state and renders the [RegisterView].
class RegisterScreen extends StatelessWidget {
  /// Creates a [RegisterScreen] widget.
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(authService: AuthService()),
      child: const RegisterView(),
    );
  }
}

/// The main view for the registration form.
///
/// Uses [BlocBuilder] to listen to [RegisterCubit] state and renders the registration form UI.
class RegisterView extends StatelessWidget {
  /// Creates a [RegisterView] widget.
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Email Text Field for user input
                TextField(
                  onChanged:
                      (value) =>
                          context.read<RegisterCubit>().emailChanged(value),
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                // Password Text Field for user input
                TextField(
                  onChanged:
                      (value) =>
                          context.read<RegisterCubit>().passwordChanged(value),
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // Register Button to trigger user registration
                state.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed:
                          () => context.read<RegisterCubit>().registerUser(),
                      child: const Text("Register"),
                    ),
                const SizedBox(height: 20),
                // Message displaying success or failure
                if (state.message.isNotEmpty)
                  Text(
                    state.message,
                    style: TextStyle(
                      color: state.isSuccess ? Colors.green : Colors.red,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
