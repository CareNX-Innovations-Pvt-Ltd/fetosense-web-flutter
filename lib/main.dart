import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';

/// The entry point of the application.
void main() {
  PreferenceHelper.init();
  setupLocator();
  runApp(const MyApp());
}

/// Main application widget that provides routing to different screens.
///
/// The `MyApp` widget is the root of the application and defines the routes for navigation.
/// It takes an instance of the [Client] as a parameter to be used across the app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Web + Appwrite',
      debugShowCheckedModeBanner:
          false,
      theme: ThemeData.dark(),
      routerConfig: AppRouter().router,
    );
  }
}
