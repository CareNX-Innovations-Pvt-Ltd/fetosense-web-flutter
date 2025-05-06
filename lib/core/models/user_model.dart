class UserModel {
  final String userId;
  final String email;
  final String role;
  final String organizationId;

  UserModel({
    required this.userId,
    required this.email,
    required this.role,
    required this.organizationId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['documentId'] ?? '',
      email: json['email'] ?? '',
      role: json['designation'] ?? '',
      organizationId: json['organizationId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentId': userId,
      'email': email,
      'designation': role,
      'organizationId': organizationId,
    };
  }
}
