import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/screens/dashboard/dashboard_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/services/auth_service.dart';
import 'login_cubit.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/app_routes.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(locator.get<AuthService>()),
      child: const LoginViewBody(),
    );
  }
}

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => LoginViewBodyState();
}

class LoginViewBodyState extends State<LoginViewBody> {
  bool isChecked = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    cubit.usernameController.text = 'pranav@carenx.com';
    cubit.passwordController.text = '12345678';

    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.replaceNamed(AppRoutes.dashboard);
          }
        },
        child: Row(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.black, Color.fromARGB(255, 17, 65, 74)],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2.5,
                    left: MediaQuery.of(context).size.width / 8,
                    child: Image.asset(
                      'assets/images/login/fetosense.png',
                      width: 350,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),

            // Right Section (Login Form)
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 140.0),
                  child: BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      String errorMessage = '';
                      bool obscurePassword = cubit.obscurePassword;

                      if (state is LoginFailure) {
                        errorMessage = state.message;
                      }
                      if (state is LoginTogglePassword) {
                        obscurePassword = state.obscurePassword;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              context.read<DashboardCubit>().logout(context);
                            },
                            child: const Text(
                              "Welcome Back 👋",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Login to your account",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 32),

                          TextField(
                            controller: cubit.usernameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: customInputDecoration(
                              "Email",
                              Icons.person,
                            ),
                          ),
                          const SizedBox(height: 20),

                          TextField(
                            controller: cubit.passwordController,
                            obscureText: obscurePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: customInputDecoration(
                              "Password",
                              Icons.lock,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed:
                                    () => cubit.togglePasswordVisibility(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          const SizedBox(height: 20),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isChecked) {
                                  cubit.loginUser(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan[700],
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child:
                                  state is LoginLoading
                                      ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                      : const Text(
                                        "Login",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          if (errorMessage.isNotEmpty)
                            Text(
                              errorMessage,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

InputDecoration customInputDecoration(String label, IconData icon) {
  return InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(color: Colors.white60),
    prefixIcon: Icon(icon, color: Colors.white70),
    filled: true,
    fillColor: Colors.white10,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 18.0,
      horizontal: 20.0,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.white30),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.cyanAccent, width: 1.5),
    ),
  );
}
