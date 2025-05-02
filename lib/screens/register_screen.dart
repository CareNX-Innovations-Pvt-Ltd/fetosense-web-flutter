// import 'package:fetosense_mis/core/services/auth_service.dart';
// import 'package:flutter/material.dart';
// import 'package:appwrite/appwrite.dart';
//
// /// A StatefulWidget for the Registration Screen.
// ///
// /// This screen allows a user to register by providing their email and password.
// /// It uses the `AuthService` class to handle user registration through the Appwrite backend.
// class RegisterScreen extends StatefulWidget {
//
//   /// Constructor to pass the [Client] object to the widget.
//   const RegisterScreen({super.key});
//
//   @override
//   RegisterScreenState createState() => RegisterScreenState();
// }
//
// class RegisterScreenState extends State<RegisterScreen> {
//   final AuthService authService = AuthService();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   String message = "";
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   /// Registers the user by calling the [AuthService]'s `registerUser` method.
//   ///
//   /// The method checks the user's registration status and updates the message
//   /// accordingly. It displays success or failure message based on the result.
//   void registerUser() async {
//     bool success = await authService.registerUser(
//       emailController.text,
//       passwordController.text,
//     );
//
//     setState(() {
//       message =
//           success ? "User registered successfully!" : "Registration failed!";
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Register")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Email Text Field for user input
//             TextField(
//               controller: emailController,
//               decoration: const InputDecoration(labelText: "Email"),
//             ),
//             // Password Text Field for user input
//             TextField(
//               controller: passwordController,
//               decoration: const InputDecoration(labelText: "Password"),
//               obscureText: true,
//             ),
//             const SizedBox(height: 20),
//             // Register Button to trigger user registration
//             ElevatedButton(onPressed: registerUser, child: const Text("Register")),
//             const SizedBox(height: 20),
//             // Message displaying success or failure
//             Text(message, style: const TextStyle(color: Colors.red)),
//           ],
//         ),
//       ),
//     );
//   }
// }
