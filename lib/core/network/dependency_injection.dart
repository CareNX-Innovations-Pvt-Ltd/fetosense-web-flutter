/// Dependency injection setup using the GetIt service locator.
///
/// This file registers singleton instances for services used throughout the app.
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:get_it/get_it.dart';

/// The global [GetIt] instance used for dependency injection.
GetIt locator = GetIt.instance;

/// Registers singleton services with the [locator].
///
/// Call this function at app startup to ensure all dependencies are available.
void setupLocator() {
  locator.registerSingleton(AppwriteService());
  locator.registerSingleton(PreferenceHelper());
}
