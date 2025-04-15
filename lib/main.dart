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

/// The entry point of the application.
void main() {
  // Create and configure the Appwrite client
  Client client =
      Client()
        // Uncomment for production environment
        // ..setEndpoint('https://appwrite.fetosense.com/v1')
        // Local environment setup
        ..setEndpoint('http://172.172.241.56/v1')
        ..setProject('67d94dac003bd3e50fc8'); // Appwrite Project ID

  // Run the Flutter app
  runApp(MyApp(client: client));
}

/// Main application widget that provides routing to different screens.
///
/// The `MyApp` widget is the root of the application and defines the routes for navigation.
/// It takes an instance of the [Client] as a parameter to be used across the app.
class MyApp extends StatelessWidget {
  final Client client;

  // Constructor to accept the client instance.
  MyApp({required this.client});

  @override
  Widget build(BuildContext context) {
    // Return the MaterialApp with defined routes and initial screen.
    return MaterialApp(
      title: 'Flutter Web + Appwrite', // Title for the app
      debugShowCheckedModeBanner:
          false, // Hide the debug banner in the top right
      theme: ThemeData.dark(), // Use dark theme for the app
      initialRoute: '/', // The initial route when the app is launched
      routes: {
        '/': (context) => LoginScreen(client: client), // Login screen route
        '/register':
            (context) =>
                RegisterScreen(client: client), // Register screen route
        // '/home': (context) => HomeScreen(client: client), // Home screen route (commented out)
        '/dashboard':
            (context) => DashboardScreen(
              client: client,
              childIndex: 0,
            ), // Dashboard screen with an initial index of 0
        '/organization-registration':
            (context) => DashboardScreen(
              client: client,
              childIndex: 1,
            ), // Organization Registration route
        '/device-registration':
            (context) => DashboardScreen(
              client: client,
              childIndex: 2,
            ), // Device Registration route
        '/generate-qr':
            (context) => DashboardScreen(
              client: client,
              childIndex: 3,
            ), // Generate QR Code route
        '/mis-organizations':
            (context) => DashboardScreen(
              client: client,
              childIndex: 4,
            ), // MIS Organizations route
        '/mis-devices':
            (context) => DashboardScreen(
              client: client,
              childIndex: 5,
            ), // MIS Devices route
        '/mis-doctors':
            (context) => DashboardScreen(
              client: client,
              childIndex: 6,
            ), // MIS Doctors route
        '/mis-mothers':
            (context) => DashboardScreen(
              client: client,
              childIndex: 7,
            ), // MIS Mothers route
        '/analytics-doctors':
            (context) => DashboardScreen(client: client, childIndex: 8),
        '/analytics-organizations':
            (context) => DashboardScreen(client: client, childIndex: 9),
      },
    );
  }
}

// main function
// This is the entry point for the application and sets up the Appwrite client
// to be used by the various routes and screens in the application.
