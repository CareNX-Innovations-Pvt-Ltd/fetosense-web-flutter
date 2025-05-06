import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/screens/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(authService: AuthService()),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
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
                  onChanged: (value) =>
                      context.read<RegisterCubit>().emailChanged(value),
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                // Password Text Field for user input
                TextField(
                  onChanged: (value) =>
                      context.read<RegisterCubit>().passwordChanged(value),
                  decoration: const InputDecoration(labelText: "Password"),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                // Register Button to trigger user registration
                state.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () =>
                      context.read<RegisterCubit>().registerUser(),
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