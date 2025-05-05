import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/core/models/user_model.dart';
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';
import 'package:fetosense_mis/core/utils/preferences.dart';
import 'package:fetosense_mis/core/utils/user_role.dart' show UserRoles;
import 'package:flutter/cupertino.dart';

/// A service for handling user authentication using Appwrite.
///
/// The `AuthService` class provides methods for registering, logging in,
/// logging out, and retrieving the current user's information using Appwrite's
/// authentication APIs. This service simplifies the interaction with the
/// Appwrite account API for user management.

class AuthService {
  final Account account = Account(locator<AppwriteService>().client);
  final Databases databases = Databases(locator<AppwriteService>().client);
  final prefs = locator<PreferenceHelper>();

  Future<bool> registerUser(String email, String password) async {
    try {
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      debugPrint('Signup Error: $e');
      return false;
    }
  }

  Future<String> loginUser(
    String email,
    String password, {
    String role = UserRoles.user,
  }) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final user = await account.get();

      final result = await databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.misUserCollectionId,
        queries: [Query.equal('email', email)],
      );

      late UserModel userModel;

      if (result.documents.isEmpty) {
        await databases.createDocument(
          databaseId: AppConstants.appwriteDatabaseId,
          collectionId: AppConstants.misUserCollectionId,
          documentId: user.$id,
          data: {
            'userId': user.$id,
            'email': email,
            'role': role,
            'createdAt': DateTime.now().toIso8601String(),
          },
        );
        userModel = UserModel(userId: user.$id, email: email, role: role);
      } else {
        final doc = result.documents.first;
        userModel = UserModel.fromJson(doc.data);
      }

      prefs.saveUser(userModel);

      debugPrint('Login successful. Session ID: ${session.$id}');
      return session.userId;
    } on AppwriteException catch (e) {
      throw Exception('Failed to sign in: ${e.message}');
    }
  }

  Future<void> logoutUser() async {
    await account.deleteSession(sessionId: 'current');
    prefs.removeUser();
  }

  Future<models.User> getCurrentUser() async {
    try {
      final user = await account.get();
      debugPrint('Logged in user: ${user.email}');
      return user;
    } on AppwriteException catch (e) {
      throw Exception('Failed to get user: ${e.message}');
    }
  }
}
