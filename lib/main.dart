import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'screens/login_screen.dart'; // Import LoginScreen
import 'screens/register_screen.dart'; // Import RegisterScreen

void main() {
  Client client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1') // Appwrite API Endpoint
    ..setProject('67d157b9003b4e1a231c'); // Your Appwrite Project ID

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final Client client;
  MyApp({required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web + Appwrite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // Dark theme to match your login screen
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(client: client), // Default Login Screen
        '/register': (context) => RegisterScreen(client: client), // Register Screen Route
      },
    );
  }
}
