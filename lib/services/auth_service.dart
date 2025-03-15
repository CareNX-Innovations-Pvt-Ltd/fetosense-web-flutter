import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;

class AuthService {
  final Account account;

  AuthService(Client client) : account = Account(client);

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

  Future<models.Session> loginUser(String email, String password) async {
    return await account.createEmailPasswordSession(
      email: email, 
      password: password
    );
  }

  Future<void> logoutUser() async {
    await account.deleteSession(sessionId: 'current');
  }

  Future<models.User> getCurrentUser() async {
    return await account.get();
  }
}
