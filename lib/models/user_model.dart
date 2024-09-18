class DataUser {
  final UserModel user;

  DataUser({required this.user});

  factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        user: UserModel.fromModel(
          Map<String, dynamic>.from(json['user']),
        ),
      );
}

class UserModel {
  final int? id;
  final String? fullName;
  final String? phoneNumber;
  final String? username;
  final String? role;
  final int? isActive;
  final String? email;
  final String? emailVerifiedAt;
  final String? imageProfile;

  const UserModel({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.username,
    this.role,
    this.isActive,
    this.email,
    this.emailVerifiedAt,
    this.imageProfile,
  });

  factory UserModel.fromModel(Map<String, dynamic> json) => UserModel(
        id: json['id'],
        fullName: json['full_name'],
        phoneNumber: json['phone_number'],
        username: json['username'],
        role: json['role'],
        isActive: json['is_active'],
        email: json['email'],
        emailVerifiedAt: json['email_verified_at'],
        imageProfile: json['image_profile'],
      );
}
