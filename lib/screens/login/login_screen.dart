import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/auth_service.dart';

/// A StatefulWidget that represents the login screen.
///
/// This screen allows the user to log in by entering their username and password. It includes form validation
/// for required fields, as well as a checkbox for the "I'm not a robot" verification. Upon successful login,
/// the user is redirected to the dashboard page.
///
/// The [client] is the Appwrite client instance used to interact with the Appwrite backend.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;
  String message = "";

  /// Logs in the user using the provided username and password.
  /// If successful, navigates to the dashboard screen. Otherwise, displays an error message.
  void loginUser() async {
    try {
      await AuthService().loginUser(
        usernameController.text,
        passwordController.text,
      );

      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      print("Error logging in: $e"); // Add this line for debugging
      setState(() {
        message = "Login failed. Please check credentials.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          // fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: usernameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF252525),
                          prefixIcon: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white, // White separator line
                                  width: 1, // Thickness of separator
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ), // White-bordered icon
                          ),
                          hintText: "Username",
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.white,
                            ), // White outer border
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.white,
                            ), // White outer border
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.cyanAccent,
                            ), // Highlight color on focus
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: obscurePassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFF252525),
                          prefixIcon: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.white, // White separator line
                                  width: 1.5, // Thickness of separator
                                ),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: const Icon(
                              Icons.lock,
                              color: Colors.white,
                            ), // White-bordered icon
                          ),
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.white54),
                          border: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.white,
                            ), // White outer border
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.white,
                            ), // White outer border
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: Colors.cyanAccent,
                            ), // Highlight color on focus
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
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
                          onPressed:
                              loginUser, // Call loginUser when the button is tapped
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan[700],
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .zero, // Makes button corners square
                            ),
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          message,
                          style: const TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
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
                          // Remove the extra `/` at the beginning
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
                              borderRadius:
                                  BorderRadius
                                      .zero, // Makes button corners square
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
}
