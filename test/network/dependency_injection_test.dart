import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  final locator = GetIt.instance;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    locator.reset();
  });

  test('setupLocator registers all required singletons', () {
    setupLocator();

    expect(locator.isRegistered<AppwriteService>(), isTrue);
    expect(locator.isRegistered<PreferenceHelper>(), isTrue);
    expect(locator.isRegistered<AuthService>(), isTrue);

    expect(locator<AppwriteService>(), isA<AppwriteService>());
    expect(locator<PreferenceHelper>(), isA<PreferenceHelper>());
    expect(locator<AuthService>(), isA<AuthService>());
  });
}
