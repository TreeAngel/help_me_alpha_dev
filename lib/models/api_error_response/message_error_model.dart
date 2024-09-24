import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class MessageErrorModel {
  final String? error;
  final String? message;
  final List<String>? fullname;
  final List<String>? username;
  final List<String>? phoneNumber;
  final List<String>? password;
  final List<String>? role;
  final List<String>? newPassword;
  final List<String>? verificationCode;

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
        fullname: data['fullname'] as List<String>?,
        username: data['username'] as List<String>?,
        phoneNumber: data['phone_number'] as List<String>?,
        password: data['password'] as List<String>?,
        role: data['role'] as List<String>?,
        newPassword: data['new_password'] as List<String>?,
        verificationCode: data['verification_code'] as List<String>?,
      );

  Map<String, dynamic> toMap() => {
        'error': error,
        'message': message,
        'fullname': fullname,
        'username': username,
        'phone_number': phoneNumber,
        'password': password,
        'role': role,
        'new_password': newPassword,
        'verification_code': verificationCode,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [MessageErrorModel].
  factory MessageErrorModel.fromJson(String data) {
    return MessageErrorModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [MessageErrorModel] to a JSON string.
  String toJson() => json.encode(toMap());

  MessageErrorModel copyWith({
    String? error,
    String? message,
    List<String>? fullname,
    List<String>? username,
    List<String>? phoneNumber,
    List<String>? password,
    List<String>? role,
    List<String>? newPassword,
    List<String>? verificationCode,
  }) {
    return MessageErrorModel(
      error: error ?? this.error,
      message: message ?? this.message,
      fullname: fullname ?? this.fullname,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      role: role ?? this.role,
      newPassword: newPassword ?? this.newPassword,
      verificationCode: verificationCode ?? this.verificationCode,
    );
  }
}
