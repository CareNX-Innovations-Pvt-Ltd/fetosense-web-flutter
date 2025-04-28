import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:fetosense_mis/core/network/appwrite_config.dart';
import 'package:fetosense_mis/core/network/dependency_injection.dart';
import 'package:flutter/cupertino.dart';

/// A service for handling user authentication using Appwrite.
///
/// The `AuthService` class provides methods for registering, logging in,
/// logging out, and retrieving the current user's information using Appwrite's
/// authentication APIs. This service simplifies the interaction with the
/// Appwrite account API for user management.
class AuthService {
  /// The Appwrite [Account] instance used for authentication operations.

  /// Creates an [AuthService] instance with the given [client].
  ///
  /// [client] is used to initialize the [Account] instance for interacting with
  /// the Appwrite API.
  final Account account = Account(locator<AppwriteService>().client);

  /// Registers a new user with the given email and password.
  ///
  /// This method attempts to create a new user in Appwrite using the provided
  /// [email] and [password]. If the registration is successful, it returns `true`.
  /// If an error occurs, it returns `false`.
  ///
  /// [email] is the user's email address.
  /// [password] is the user's password.
  ///
  /// Returns `true` if the registration was successful, otherwise `false`.
  Future<bool> registerUser(String email, String password) async {
    try {
      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
      return true;
    } catch (e) {
      print('Signup Error: $e');
      return false;
    }
  }

  /// Logs in a user with the given email and password.
  ///
  /// This method attempts to log the user in by creating an email-password
  /// session with the provided [email] and [password].
  ///
  /// [email] is the user's email address.
  /// [password] is the user's password.
  ///
  /// Returns a [models.Session] object representing the created session.
  Future<models.Session> loginUser(String email, String password) async {
    return await account.createEmailPasswordSession(
      email: email,
      password: password,
    );
  }

  /// Logs out the currently logged-in user.
  ///
  /// This method deletes the current session, effectively logging the user out.
  /// It uses 'current' to target the active session.
  Future<void> logoutUser() async {
    await account.deleteSession(sessionId: 'current');
  }

  /// Retrieves the current authenticated user.
  ///
  /// This method fetches the details of the currently authenticated user.
  ///
  /// Returns a [models.User] object representing the current user.
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
