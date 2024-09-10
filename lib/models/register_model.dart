import 'dart:io';
import 'dart:convert';

class RegisterModel {
  final String fullName;
  final String username;
  final String phoneNumber;
  final String password;
  final String passwordConfirmation;
  final String role;
  late String? imageProfile;

  RegisterModel({
    required this.fullName,
    required this.username,
    required this.phoneNumber,
    required this.password,
    required this.passwordConfirmation,
    required this.role,
    this.imageProfile,
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'username': username,
      'phone_number': phoneNumber,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'role': role,
      'image_profile': imageProfile,
    };
  }

  Future<void> setImageProfile(String imagePath) async {
    List<int> imageBytes = await File(imagePath).readAsBytes();
    imageProfile = base64Encode(imageBytes);
  }
}
