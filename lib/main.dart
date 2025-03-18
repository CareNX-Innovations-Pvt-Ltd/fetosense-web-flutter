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
        ..setProject('67d94dac003bd3e50fc8');

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
            (context) => DashboardScreen(client: client), // Home Page Route
        '/organization-registration': (context) => OrganizationRegistration(),
        '/device-registration': (context) => DeviceRegistration(),
        '/generate-qr': (context) => GenerateQRPage(),
        '/mis-organizations':
            (context) => OrganizationDetailsPage(client: client),
      },
    );
  }
}
