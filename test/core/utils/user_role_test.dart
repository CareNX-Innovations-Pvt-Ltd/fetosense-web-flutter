import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserRoles', () {
    test('should have correct user role', () {
      expect(UserRoles.user, 'user');
    });

    test('should have correct admin role', () {
      expect(UserRoles.admin, 'admin');
    });

    test('should have correct super admin role', () {
      expect(UserRoles.superAdmin, 'super_admin');
    });
  });
}