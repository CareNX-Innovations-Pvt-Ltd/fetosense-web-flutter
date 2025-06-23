/// A utility class containing application-wide constant values and keys.
///
/// The [AppConstants] class provides static constant values for routes, Appwrite credentials,
/// and various app settings keys used throughout the Fetosense MIS application.
abstract class AppConstants {
  /// Route name for instant test screens.
  static const String instantTest = 'instant-test';

  /// Route name for registered mother screens.
  static const String registeredMother = 'registered';

  /// Route name for test screens.
  static const String testRoute = 'test-route';

  /// Route name for home screens.
  static const String homeRoute = 'home-route';

  /// Route name for mother details screens.
  static const String motherDetailsRoute = 'mother-detail-route';

  static const String appwriteEndpoint = 'http://20.6.93.31/v1';
  static const String appwriteProjectId = '684c18890002a74fff23';
  static const String appwriteDatabaseId = '684c19ee00122a8eec2a';
  static const String userCollectionId = '684c19fa00162a9cbc57';
  static const String deviceCollectionId = '684c1a0200383bd0527c';
  static const String testsCollectionId = '684c1a13001f5e7a17c5';
  static const String configCollectionId = '67fe36d100234405442e';

  /// Key for default test duration in app settings.
  static const String defaultTestDurationKey = 'defaultTestDurationKey';

  /// Key for FHR alerts in app settings.
  static const String fhrAlertsKey = 'fhrAlertsKey';

  /// Key for movement marker in app settings.
  static const String movementMarkerKey = 'movementMarkerKey';

  /// Key for patient ID in app settings.
  static const String patientIdKey = 'patientIdKey';

  /// Key for Fisher score in app settings.
  static const String fisherScoreKey = 'fisherScoreKey';

  /// Key for twin reading in app settings.
  static const String twinReadingKey = 'twinReadingKey';

  /// Key for email in sharing section.
  static const String emailKey = 'emailKey';

  /// Key for sharing audio in sharing section.
  static const String shareAudioKey = 'shareAudioKey';

  /// Key for sharing report in sharing section.
  static const String shareReportKey = 'shareReportKey';

  /// Key for default print scale in printing section.
  static const String defaultPrintScaleKey = 'scale';

  /// Key for doctor comments in printing section.
  static const String doctorCommentKey = 'comments';

  /// Key for auto interpretations in printing section.
  static const String autoInterpretationsKey = 'interpretations';

  /// Key for highlighting patterns in printing section.
  static const String highlightPatternsKey = 'highlight';

  /// Key for displaying logo in printing section.
  static const String displayLogoKey = 'displayLogoKey';
}
