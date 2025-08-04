import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/services/auth_service.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../cubit/dashboard_cubit_test.dart';


class MockAccount extends Mock implements Account {}

class MockDatabases extends Mock implements Databases {}

class MockPreferenceHelper extends Mock implements PreferenceHelper {}

class MockAppwriteService extends Mock implements AppwriteService {}

void main() {
  late MockAccount mockAccount;
  late MockDatabases mockDatabases;
  late MockPreferenceHelper mockPrefs;
  late AuthService authService;

  const testEmail = 'test@example.com';
  const testPassword = 'password123';
  const testRole = UserRoles.admin;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockAccount = MockAccount();
    mockDatabases = MockDatabases();
    mockPrefs = MockPreferenceHelper();

    authService = AuthService(
      account: mockAccount,
      databases: mockDatabases,
      prefs: mockPrefs,
    );
  });


  group('AuthService', () {
    test('registerUser returns true on success', () async {
      when(() =>
          mockAccount.create(
            userId: any(named: 'userId'),
            email: testEmail,
            password: testPassword,
          )).thenAnswer((_) async =>
          models.User(
            $id: 'uid',
            name: '',
            status: false,
            emailVerification: false,
            prefs: models.Preferences(data: {}),
            $createdAt: '',
            $updatedAt: '',
            registration: '',
            labels: [],
            passwordUpdate: '',
            phone: '',
            phoneVerification: false,
            mfa: false,
            targets: [],
            accessedAt: '',
            email: '',
          ));

      final result = await authService.registerUser(testEmail, testPassword);

      expect(result, true);
      verify(() =>
          mockAccount.create(
            userId: any(named: 'userId'),
            email: testEmail,
            password: testPassword,
          )).called(1);
    });

    test('registerUser returns false on exception', () async {
      when(() => mockAccount.create(
        userId: any(named: 'userId'),
        email: testEmail,
        password: testPassword,
      )).thenThrow(Exception('signup failed'));

      final result = await authService.registerUser(testEmail, testPassword);

      expect(result, false);
    });


    test('registerUser returns false on failure', () async {
      when(() =>
          mockAccount.create(
            userId: any(named: 'userId'),
            email: testEmail,
            password: testPassword,
          )).thenThrow(AppwriteException('Error'));

      final result = await authService.registerUser(testEmail, testPassword);

      expect(result, false);
    });

    test('loginUser returns true for valid admin user', () async {
      final session = models.Session(
          $id: 'sessionId',
          userId: 'uid',
          provider: '',
          $createdAt: '',
          $updatedAt: '',
          expire: '',
          providerUid: '',
          providerAccessToken: '',
          providerAccessTokenExpiry: '',
          providerRefreshToken: '',
          ip: '',
          osCode: '',
          osName: '',
          osVersion: '',
          clientType: '',
          clientCode: '',
          clientName: '',
          clientVersion: '',
          clientEngine: '',
          clientEngineVersion: '',
          deviceName: '',
          deviceBrand: '',
          deviceModel: '',
          countryCode: '',
          countryName: '',
          current: false,
          factors: [],
          secret: '',
          mfaUpdatedAt: ''
      );
      final user = models.User(
        $id: 'uid',
        name: '',
        status: false,
        emailVerification: false,
        prefs: models.Preferences(data: {}),
        $createdAt: '',
        $updatedAt: '',
        registration: '',
        labels: [],
        passwordUpdate: '',
        phone: '',
        phoneVerification: false,
        mfa: false,
        targets: [],
        accessedAt: '',
        email: '',
      );
      final userModel = UserModel(email: testEmail,
          role: UserRoles.admin,
          userId: '',
          organizationId: '');
      final document = models.Document(data: userModel.toJson(),
          $id: '1',
          $collectionId: '',
          $databaseId: '',
          $createdAt: '',
          $updatedAt: '',
          $permissions: []);

      when(() =>
          mockAccount.createEmailPasswordSession(
            email: testEmail,
            password: testPassword,
          )).thenAnswer((_) async => session);

      when(() => mockAccount.get()).thenAnswer((_) async => user);

      when(() =>
          mockDatabases.listDocuments(
            databaseId: AppConstants.appwriteDatabaseId,
            collectionId: AppConstants.userCollectionId,
            queries: any(named: 'queries'),
          )).thenAnswer((_) async =>
          models.DocumentList(documents: [document], total: 1));

      when(() => mockPrefs.saveUser(any())).thenReturn(Future.value());

      final result = await authService.loginUser(testEmail, testPassword);

      expect(result, true);
      verify(() => mockPrefs.saveUser(any())).called(1);
    });

    test('loginUser returns false for non-admin user', () async {
      final session = models.Session(
          $id: 'sessionId',
          userId: 'uid',
          provider: '',
          $createdAt: '',
          $updatedAt: '',
          expire: '',
          providerUid: '',
          providerAccessToken: '',
          providerAccessTokenExpiry: '',
          providerRefreshToken: '',
          ip: '',
          osCode: '',
          osName: '',
          osVersion: '',
          clientType: '',
          clientCode: '',
          clientName: '',
          clientVersion: '',
          clientEngine: '',
          clientEngineVersion: '',
          deviceName: '',
          deviceBrand: '',
          deviceModel: '',
          countryCode: '',
          countryName: '',
          current: false,
          factors: [],
          secret: '',
          mfaUpdatedAt: ''
      );
      final user = models.User(
        $id: 'uid',
        name: '',
        status: false,
        emailVerification: false,
        prefs: models.Preferences(data: {}),
        $createdAt: '',
        $updatedAt: '',
        registration: '',
        labels: [],
        passwordUpdate: '',
        phone: '',
        phoneVerification: false,
        mfa: false,
        targets: [],
        accessedAt: '',
        email: '',
      );
      final userModel = UserModel(
          email: testEmail, role: 'doctor', userId: '', organizationId: '');
      final document = models.Document(data: userModel.toJson(),
          $id: '1',
          $collectionId: '',
          $databaseId: '',
          $createdAt: '',
          $updatedAt: '',
          $permissions: []);

      when(() =>
          mockAccount.createEmailPasswordSession(
            email: testEmail,
            password: testPassword,
          )).thenAnswer((_) async => session);

      when(() => mockAccount.get()).thenAnswer((_) async => user);

      when(() =>
          mockDatabases.listDocuments(
            databaseId: AppConstants.appwriteDatabaseId,
            collectionId: AppConstants.userCollectionId,
            queries: any(named: 'queries'),
          )).thenAnswer((_) async =>
          models.DocumentList(documents: [document], total: 1));

      final result = await authService.loginUser(testEmail, testPassword);

      expect(result, false);
    });

    test('logoutUser calls deleteSession and removeUser', () async {
      when(() => mockAccount.deleteSession(sessionId: 'current')).thenAnswer((
          _) async => {});
      when(() => mockPrefs.removeUser()).thenReturn(null);

      await authService.logoutUser();

      verify(() => mockAccount.deleteSession(sessionId: 'current')).called(1);
      verify(() => mockPrefs.removeUser()).called(1);
    });

    test('loginUser throws Exception on AppwriteException', () async {
      when(() => mockAccount.createEmailPasswordSession(
        email: testEmail,
        password: testPassword,
      )).thenThrow(AppwriteException('Login failed'));

      expect(
            () => authService.loginUser(testEmail, testPassword),
        throwsA(isA<Exception>()),
      );
    });


    test('getCurrentUser returns user on success', () async {
      final user = models.User(
        $id: 'uid',
        name: '',
        status: false,
        emailVerification: false,
        prefs: models.Preferences(data: {}),
        $createdAt: '',
        $updatedAt: '',
        registration: '',
        labels: [],
        passwordUpdate: '',
        phone: '',
        phoneVerification: false,
        mfa: false,
        targets: [],
        accessedAt: '',
        email: '',
      );
      when(() => mockAccount.get()).thenAnswer((_) async => user);

      final result = await authService.getCurrentUser();

      expect(result.email, testEmail);
    });

    test('getCurrentUser throws Exception on failure', () async {
      when(() => mockAccount.get()).thenThrow(
          AppwriteException('User not found'));

      expect(() => authService.getCurrentUser(), throwsException);
    });
  });

  test('getCurrentUser throws Exception on AppwriteException', () async {
    when(() => mockAccount.get())
        .thenThrow(AppwriteException('Fetch failed'));

    expect(() => authService.getCurrentUser(), throwsA(isA<Exception>()));
  });

}
