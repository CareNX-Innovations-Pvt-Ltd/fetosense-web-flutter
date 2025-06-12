/// Model representing a user in the system.
///
/// Contains user identification, email, role, and organization association.
class UserModel {
  /// Unique identifier for the user.
  final String userId;

  /// Email address of the user.
  final String email;

  /// Role or designation of the user (e.g., admin, doctor).
  final String role;

  /// Identifier for the organization the user belongs to.
  final String organizationId;

  /// Creates a [UserModel] with the given details.
  UserModel({
    required this.userId,
    required this.email,
    required this.role,
    required this.organizationId,
  });

  /// Creates a [UserModel] from a JSON map.
  ///
  /// The [json] parameter must contain keys: 'documentId', 'email', 'designation', and 'organizationId'.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['documentId'] ?? '',
      email: json['email'] ?? '',
      role: json['designation'] ?? '',
      organizationId: json['organizationId'] ?? '',
    );
  }

  /// Converts this [UserModel] instance to a JSON map.
  ///
  /// Returns a map with keys: 'documentId', 'email', 'designation', and 'organizationId'.
  Map<String, dynamic> toJson() {
    return {
      'documentId': userId,
      'email': email,
      'designation': role,
      'organizationId': organizationId,
    };
  }
}
