import 'package:fetosense_mis/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/organization_registration.dart';
import 'screens/device_registration.dart';
import 'screens/generate_qr_page.dart';
import 'screens/organization_details_page.dart';

void main() {
  Client client =
      Client()
        ..setEndpoint('http://172.172.241.56/v1')
        ..setProject('67ecd82100347201f279');

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
        // '/home': (context) => HomeScreen(client: client), // Home Page Route
        '/dashboard':
            (context) => DashboardScreen(
              client: client,
              childIndex: 0,
            ), // Home Page Route
        '/organization-registration':
            (context) => DashboardScreen(client: client, childIndex: 1),

        '/device-registration':
            (context) => DashboardScreen(client: client, childIndex: 2),
        '/generate-qr':
            (context) => DashboardScreen(client: client, childIndex: 3),
        '/mis-organizations':
            (context) => DashboardScreen(client: client, childIndex: 4),
        '/mis-devices':
            (context) => DashboardScreen(client: client, childIndex: 5),
        '/mis-doctors':
            (context) => DashboardScreen(client: client, childIndex: 6),
        '/mis-mothers':
            (context) => DashboardScreen(client: client, childIndex: 7),
      },
    );
  }
}

//main
//RANDOM COMMENT
