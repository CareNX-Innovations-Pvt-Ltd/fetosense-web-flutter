import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';
import 'package:fetosense_mis/screens/login/login_cubit.dart';
import 'package:fetosense_mis/screens/organization_registration/organization_registration_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

/// The entry point of the Fetosense MIS application.
///
/// Initializes preferences, sets up dependency injection, and runs the app.
void main() async {
  PreferenceHelper.init();
  setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());

}

//main.dart
/// The root widget of the Fetosense MIS application.
///
/// Sets up multiple Bloc providers for state management and configures the router.
class MyApp extends StatelessWidget {
  /// Creates a [MyApp] widget.
  ///
  /// The [key] parameter is optional and can be used to specify a widget key.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Provides [LoginCubit] for authentication state management.
        BlocProvider(create: (context) => LoginCubit()),

        /// Provides [OrganizationRegistrationCubit] for organization registration state.
        BlocProvider(create: (context) => OrganizationRegistrationCubit()),

        /// Provides [DeviceDetailsCubit] for device details state management.
        BlocProvider(create: (context) => DeviceDetailsCubit()),

        /// Provides [DoctorDetailsCubit] for doctor details state management.
        BlocProvider(create: (context) => DoctorDetailsCubit()),
      ],
      child: MaterialApp.router(
        /// The title of the application displayed in the browser tab.
        title: 'Flutter Web + Appwrite',

        /// Hides the debug banner in non-debug builds.
        debugShowCheckedModeBanner: false,

        /// Sets the light theme for the application.
        theme: ThemeData.light(),

        /// Configures the router for navigation using [AppRouter].
        routerConfig: AppRouter().router,
      ),
    );
  }
}
