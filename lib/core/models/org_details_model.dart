import 'package:appwrite/models.dart' as models;

///
/// Model representing the details of an organization and related statistics.
///
/// Contains a list of organization documents and counts for devices, mothers, tests, and doctors.
class OrganizationDetailsModel {
  /// The list of organization documents.
  final List<models.Document> organizations;

  /// The total number of devices associated with the organization(s).
  final int deviceCount;

  /// The total number of mothers associated with the organization(s).
  final int motherCount;

  /// The total number of tests conducted by the organization(s).
  final int testCount;

  /// The total number of doctors associated with the organization(s).
  final int doctorCount;

  /// Creates an [OrganizationDetailsModel] with the given details and statistics.
  OrganizationDetailsModel({
    required this.organizations,
    required this.deviceCount,
    required this.motherCount,
    required this.testCount,
    required this.doctorCount,
  });

  /// Returns a copy of this model with updated fields if provided.
  ///
  /// If a parameter is not provided, the current value is used.
  OrganizationDetailsModel copyWith({
    List<models.Document>? organizations,
    int? deviceCount,
    int? motherCount,
    int? testCount,
    int? doctorCount,
  }) {
    return OrganizationDetailsModel(
      organizations: organizations ?? this.organizations,
      deviceCount: deviceCount ?? this.deviceCount,
      motherCount: motherCount ?? this.motherCount,
      testCount: testCount ?? this.testCount,
      doctorCount: doctorCount ?? this.doctorCount,
    );
  }
}
