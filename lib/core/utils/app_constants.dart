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

  /// Appwrite API endpoint URL.
  static const String appwriteEndpoint = 'http://172.172.241.56/v1';

  /// Appwrite project ID.
  static const String appwriteProjectId = '67ecd82100347201f279';

  /// Appwrite database ID.
  static const String appwriteDatabaseId = '67ece4a7002a0a732dfd';

  /// Appwrite user collection ID.
  static const String userCollectionId = '67f36a7e002c46ea05f0';

  /// Appwrite device collection ID.
  static const String deviceCollectionId = '67f36766002068046589';

  /// Appwrite tests collection ID.
  static const String testsCollectionId = '67f3790a0024f8f61684';

  /// Appwrite config collection ID.
  static const String configCollectionId = '67fe36d100234405442e';

  /// Appwrite MIS user collection ID.
  static const String misUserCollectionId = '681857100017b4b2e416';

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
