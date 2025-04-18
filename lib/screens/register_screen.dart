import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:appwrite/appwrite.dart';

/// A StatefulWidget for the Registration Screen.
///
/// This screen allows a user to register by providing their email and password.
/// It uses the `AuthService` class to handle user registration through the Appwrite backend.
class RegisterScreen extends StatefulWidget {
  final Client client;

  /// Constructor to pass the [Client] object to the widget.
  RegisterScreen({required this.client});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final AuthService authService;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String message = "";

  @override
  void initState() {
    super.initState();
    authService = AuthService(widget.client);
  }

  /// Registers the user by calling the [AuthService]'s `registerUser` method.
  ///
  /// The method checks the user's registration status and updates the message
  /// accordingly. It displays success or failure message based on the result.
  void registerUser() async {
    bool success = await authService.registerUser(
      emailController.text,
      passwordController.text,
    );

    setState(() {
      message =
          success ? "User registered successfully!" : "Registration failed!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Email Text Field for user input
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            // Password Text Field for user input
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Register Button to trigger user registration
            ElevatedButton(onPressed: registerUser, child: Text("Register")),
            SizedBox(height: 20),
            // Message displaying success or failure
            Text(message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
