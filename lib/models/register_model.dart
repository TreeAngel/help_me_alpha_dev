class RegisterModel {
  final String fullName;
  final String username;
  final String phoneNumber;
  final String password;
  final String passwordConfirmation;
  final String role;
  final String? fcmToken;

  RegisterModel({
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
