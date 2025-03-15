import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/organization_registration.dart';

void main() {
  Client client = Client()
    ..setEndpoint('https://cloud.appwrite.io/v1')
    ..setProject('67d157b9003b4e1a231c');

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
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(client: client),
        '/register': (context) => RegisterScreen(client: client),
        '/home': (context) => HomeScreen(client: client), // Home Page Route
        '/organization-registration': (context) => OrganizationRegistration(),

      },
    );
  }
}
