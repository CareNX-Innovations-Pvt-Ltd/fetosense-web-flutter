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

  /// Registers a new user with the provided [email] and [password].
  ///
  /// Returns `true` if registration is successful, otherwise `false`.
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

  /// Logs in a user with the provided [email] and [password].
  ///
  /// Optionally accepts a [role] parameter (default is [UserRoles.admin]).
  /// Returns `true` if login is successful, otherwise `false`.
  Future<bool> loginUser(
    String email,
    String password, {
    String role = UserRoles.admin,
  }) async {
    try {
      final session = await account.createEmailPasswordSession(
        email: email,
        password: password,
      );

      final _ = await account.get();

      final result = await databases.listDocuments(
        databaseId: AppConstants.appwriteDatabaseId,
        collectionId: AppConstants.userCollectionId,
        queries: [Query.equal('email', email)],
      );

      late UserModel userModel;
      final doc = result.documents.first;
      userModel = UserModel.fromJson(doc.data);
      if (userModel.role != UserRoles.admin) {
        return false;
      }

      prefs.saveUser(userModel);

      debugPrint('Login successful. Session ID: ${session.$id}');
      return true;
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
