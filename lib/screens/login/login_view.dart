import 'package:fetosense_mis/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_cubit.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(),
      child: const _LoginViewBody(),
    );
  }
}

class _LoginViewBody extends StatelessWidget {
  const _LoginViewBody();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    cubit.usernameController.text = 'pranav@carenx.com';
    cubit.passwordController.text = '12345678';
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: Center(
        child: Container(
          width: 850,
          height: 400,
          decoration: BoxDecoration(
            color: const Color(0xFF252525),
            borderRadius: BorderRadius.circular(0),
            border: Border.all(color: Colors.white, width: 0.5),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: cubit.usernameController,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration("Username", Icons.person),
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: cubit.passwordController,
                            obscureText: obscurePassword,
                            style: const TextStyle(color: Colors.white),
                            decoration: _inputDecoration("Password", Icons.lock).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.white,
                                ),
                                onPressed: () => cubit.togglePasswordVisibility(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Checkbox(
                                value: false,
                                onChanged: (value) {},
                                activeColor: Colors.blue,
                              ),
                              const Text(
                                "I'm not a robot",
                                style: TextStyle(color: Colors.white54),
                              ),
                              const Spacer(),
                              const Icon(Icons.security, color: Colors.white54),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              onPressed: () => cubit.loginUser(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.cyan[700],
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: state is LoginLoading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text(
                                "Login",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (errorMessage.isNotEmpty)
                            Center(
                              child: Text(
                                errorMessage,
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  color: const Color(0xFF252525),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          AuthService().logoutUser();
                        },
                        child: Image.asset(
                          'assets/images/login/fetosense.png',
                          height: 80,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.image_not_supported,
                              size: 80,
                              color: Colors.grey,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Fetosense - India's most advanced product for Fetal Heart Monitoring",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white60, fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan[700],
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: const Text(
                            "Home Page",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFF252525),
      prefixIcon: Container(
        decoration: const BoxDecoration(
          border: Border(
            right: BorderSide(color: Colors.white, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Icon(icon, color: Colors.white),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.white),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.white),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(color: Colors.cyanAccent),
      ),
    );
  }
}
