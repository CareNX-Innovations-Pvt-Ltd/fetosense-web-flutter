import 'package:appwrite/appwrite.dart';
import 'package:fetosense_mis/core/utils/app_constants.dart';

class AppwriteService {
  final Client client;

  AppwriteService()
    : client =
          Client()
            ..setEndpoint(AppConstants.appwriteEndpoint)
            ..setProject(AppConstants.appwriteProjectId)
            ..setSelfSigned(status: true);

  Client get instance => client;
}
