import 'package:appwrite/appwrite.dart';

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
}
