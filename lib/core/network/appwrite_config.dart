import 'package:appwrite/appwrite.dart';

/// Service class for configuring and providing an Appwrite [Client] instance.
///
/// This class sets up the Appwrite client with the required endpoint, project ID,
/// and allows self-signed certificates for development purposes.
class AppwriteService {
  /// The Appwrite [Client] used for making API requests.
  final Client client;

  /// Creates an [AppwriteService] and initializes the [client] with endpoint, project, and self-signed status.
  AppwriteService()
    : client =
          Client()
            ..setEndpoint('http://172.172.241.56/v1')
            ..setProject('67ecd82100347201f279')
            ..setSelfSigned(status: true);

  /// Returns the configured Appwrite [Client] instance.
  Client get instance => client;
}
