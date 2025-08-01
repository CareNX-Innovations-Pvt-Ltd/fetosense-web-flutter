import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:appwrite/appwrite.dart';

void main() {
  group('AppwriteService', () {
    late AppwriteService service;

    setUp(() {
      service = AppwriteService();
    });

    test('initializes client with correct endpoint', () {
      expect(service.client.endPoint, AppConstants.appwriteEndpoint);
    });

    test('initializes client with correct project ID', () {
      expect(service.client.config['project'], AppConstants.appwriteProjectId);
    });

    test('client is self-signed', () {
      expect(service.client.config['selfSigned'], true);
    });

    test('instance getter returns the same client', () {
      expect(service.instance, service.client);
    });
  });
}
