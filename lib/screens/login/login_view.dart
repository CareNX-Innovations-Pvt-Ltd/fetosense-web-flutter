import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/screens/login/widgets/captcha_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_cubit.dart';

/// The main login view widget.
///
/// Provides a [LoginCubit] to manage login state and renders the [_LoginViewBody].
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

class _LoginViewBody extends StatefulWidget {
  const _LoginViewBody();

  @override
  State<_LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<_LoginViewBody> {
  bool isChecked = false;
  @override
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LoginCubit>();
    cubit.usernameController.text = 'pranav@carenx.com';
    cubit.passwordController.text = '12345678';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Row(
        children: [
          // 🔹 Left half - Full image
          Expanded(
            child: Stack(
              children: [
                // Background Image
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,

                      end: Alignment.bottomRight,
                      colors: [
                        Colors.black,

                        Color.fromARGB(
                          255,
                          17,
                          65,
                          74,
                        ), // Target teal shade (66, 149, 164)
                      ],
                    ),
                  ),
                ),

                // Overlay: Fetosense Logo (centered or positioned as needed)
                Positioned(
                  top: MediaQuery.of(context).size.height / 2.5,

                  left: MediaQuery.of(context).size.width / 8,
                  child: Image.asset(
                    'assets/images/login/fetosense.png',
                    width: 350,
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder:
                        (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported,
                          color: Colors.white70,
                          size: 80,
                        ),
                  ),
                ),
              ],
            ),
          ),

          // 🔸 Right half - Login form centered
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome Back 👋",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Login to your account",
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 32),

                        TextField(
                          controller: cubit.usernameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: _customInputDecoration(
                            "Email",
                            Icons.person,
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextField(
                          controller: cubit.passwordController,
                          obscureText: obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: _customInputDecoration(
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
                              onPressed: () => cubit.togglePasswordVisibility(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        CaptchaCheckbox(
                          onVerified: (value) {
                            setState(() {
                              isChecked = value;
                            });
                            debugPrint("CAPTCHA verified: $isChecked");
                          },
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isChecked) {
                                cubit.loginUser(context);
                              } else {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        backgroundColor: Colors.grey.shade900,
                                        title: const Text(
                                          "Verification Required",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        content: const Text(
                                          "Please verify you're not a robot.",
                                          style: TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                            child: const Text(
                                              "OK",
                                              style: TextStyle(
                                                color: Colors.tealAccent,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan[700],
                              padding: const EdgeInsets.symmetric(vertical: 14),
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
    );
  }
}

InputDecoration _customInputDecoration(String label, IconData icon) {
  return InputDecoration(
    hintText: label,
    hintStyle: const TextStyle(color: Colors.white60),
    prefixIcon: Icon(icon, color: Colors.white70),
    filled: true,
    fillColor: Colors.white10, // soft translucent
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
