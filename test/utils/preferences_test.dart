import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';

void main() {
  group('PreferenceHelper', () {
    late PreferenceHelper preferenceHelper;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await PreferenceHelper.init();
      preferenceHelper = PreferenceHelper();
    });

    test('should set and get auto-login preference', () {
      preferenceHelper.setAutoLogin(true);
      expect(preferenceHelper.getAutoLogin(), true);

      preferenceHelper.setAutoLogin(false);
      expect(preferenceHelper.getAutoLogin(), false);
    });

    test('should save and retrieve user data', () async {
      final user = UserModel( role: 'admin', userId: '', email: '', organizationId: '');
      await preferenceHelper.saveUser(user);

      final retrievedUser = preferenceHelper.getUser();
      // expect(retrievedUser?.id, user.id);
      // expect(retrievedUser?.name, user.name);
      expect(retrievedUser?.role, user.role);
    });

    test('should remove user data', () async {
      final user = UserModel( role: 'admin', userId: '', email: '', organizationId: '');
      await preferenceHelper.saveUser(user);

      preferenceHelper.removeUser();
      expect(preferenceHelper.getUser(), null);
    });

    test('should set and get integer value', () {
      preferenceHelper.setInt('testInt', 42);
      expect(preferenceHelper.getInt('testInt'), 42);
    });

    test('should set and get boolean value', () {
      preferenceHelper.setBool('testBool', true);
      expect(preferenceHelper.getBool('testBool'), true);
    });

    test('should set and get string value', () {
      preferenceHelper.setString('testString', 'Hello');
      expect(preferenceHelper.getString('testString'), 'Hello');
    });

    test('should return default user role if user not found', () {
      expect(preferenceHelper.getUserRole(), 'admin');
    });
  });
}