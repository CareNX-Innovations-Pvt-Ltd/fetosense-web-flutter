import 'package:appwrite/appwrite.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';

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
            ..setEndpoint(AppConstants.appwriteEndpoint)
            ..setProject(AppConstants.appwriteProjectId)
            ..setSelfSigned(status: true);

  /// Returns the configured Appwrite [Client] instance.
  Client get instance => client;
}
