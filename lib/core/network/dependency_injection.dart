import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator(){
  locator.registerSingleton(AppwriteService());
  locator.registerSingleton(PreferenceHelper());
}
