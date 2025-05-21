import 'package:appwrite/models.dart' as models;

class OrganizationDetailsModel {
  final List<models.Document> organizations;
  final int deviceCount;
  final int motherCount;
  final int testCount;
  final int doctorCount;

  OrganizationDetailsModel({
    required this.organizations,
    required this.deviceCount,
    required this.motherCount,
    required this.testCount,
    required this.doctorCount,
  });

  // Create a copy of this model with some fields updated
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