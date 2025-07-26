import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel', () {
    test('should create a UserModel instance', () {
      final user = UserModel(
        userId: '123',
        email: 'test@example.com',
        role: 'user',
        organizationId: 'org456',
      );
      expect(user.userId, '123');
      expect(user.email, 'test@example.com');
      expect(user.role, 'user');
      expect(user.organizationId, 'org456');
    });

    test('should create a UserModel from a JSON map', () {
      final json = {
        'documentId': '789',
        'email': 'another@example.com',
        'designation': 'admin',
        'organizationId': 'org012',
      };
      final user = UserModel.fromJson(json);
      expect(user.userId, '789');
      expect(user.email, 'another@example.com');
      expect(user.role, 'admin');
      expect(user.organizationId, 'org012');
    });

    test('should handle missing keys in fromJson', () {
      final json = {
        'documentId': 'abc',
        'email': 'missing@example.com',
        // designation and organizationId are missing
      };
      final user = UserModel.fromJson(json);
      expect(user.userId, 'abc');
      expect(user.email, 'missing@example.com');
      expect(user.role, ''); // Expecting default empty string
      expect(user.organizationId, ''); // Expecting default empty string
    });

    test('should convert a UserModel to a JSON map', () {
      final user = UserModel(
        userId: '123',
        email: 'test@example.com',
        role: 'user',
        organizationId: 'org456',
      );
      final json = user.toJson();
      expect(json['documentId'], '123');
      expect(json['email'], 'test@example.com');
      expect(json['designation'], 'user');
      expect(json['organizationId'], 'org456');
    });
  });
}
