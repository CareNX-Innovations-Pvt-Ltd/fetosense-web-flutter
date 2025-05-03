import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_routes.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/screens/device_details/device_details_cubit.dart';
import 'package:fetosense_mis/screens/doctor_details/doctor_details_cubit.dart';
import 'package:fetosense_mis/screens/login/login_cubit.dart';
import 'package:fetosense_mis/screens/organization_registration/organization_registration_cubit.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        BlocProvider(
          create: (context) => OrganizationRegistrationCubit(),
        ),
        BlocProvider(
          create: (context) => DeviceDetailsCubit(),
        ),
        BlocProvider(
          create: (context) => DoctorDetailsCubit(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Flutter Web + Appwrite',
        debugShowCheckedModeBanner:
            false,
        theme: ThemeData.light(),
        routerConfig: AppRouter().router,
      ),
    );
  }
}
