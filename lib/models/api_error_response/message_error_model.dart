import 'package:flutter/foundation.dart';

@immutable
class MessageErrorModel {
  final String? error;
  final String? message;
  final List<dynamic>? fullname;
  final List<dynamic>? username;
  final List<dynamic>? phoneNumber;
  final List<dynamic>? password;
  final List<dynamic>? role;
  final List<dynamic>? newPassword;
  final List<dynamic>? verificationCode;

  const MessageErrorModel({
    this.error,
    this.message,
    this.fullname,
    this.username,
    this.phoneNumber,
    this.password,
    this.role,
    this.newPassword,
    this.verificationCode,
  });

  @override
  String toString() {
    return 'Error(error: $error, message: $message, fullname: $fullname, username: $username, phoneNumber: $phoneNumber, password: $password, role: $role, newPassword: $newPassword, verificationCode: $verificationCode';
  }

  factory MessageErrorModel.fromMap(Map<String, dynamic> data) =>
      MessageErrorModel(
        error: data['error'] as String?,
        message: data['message'] as String?,
        fullname: data['full_name'] as List<dynamic>?,
        username: data['username'] as List<dynamic>?,
        phoneNumber: data['phone_number'] as List<dynamic>?,
        password: data['password'] as List<dynamic>?,
        role: data['role'] as List<dynamic>?,
        newPassword: data['new_password'] as List<dynamic>?,
        verificationCode: data['verification_code'] as List<dynamic>?,
      );
}
