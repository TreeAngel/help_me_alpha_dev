class RegisterUserModel {
  final String fullName;
  final String username;
  final String phoneNumber;
  final String password;
  final String passwordConfirmation;
  final String role;
  final String? fcmToken;

  RegisterUserModel({
    required this.fullName,
    required this.username,
    required this.phoneNumber,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
    this.fcmToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'username': username,
      'phone_number': phoneNumber,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role,
      'fcm_token': fcmToken,
    };
  }
}

class RegisterMitraModel {
  final String name;
  final double lat;
  final double long;
  final int categoryId;
  final String accountNumber;
  final List<int> helpersId;

  RegisterMitraModel({
    required this.name,
    required this.lat,
    required this.long,
    required this.categoryId,
    required this.accountNumber,
    required this.helpersId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'latitude': lat,
      'longitude': long,
      'category_id': categoryId,
      'nomor_rekening': accountNumber,
      'helper_ids': helpersId,
    };
  }
}
