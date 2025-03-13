import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:appwrite/appwrite.dart';

class RegisterScreen extends StatefulWidget {
  final Client client;
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
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: registerUser, child: Text("Register")),
            SizedBox(height: 20),
            Text(message, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
