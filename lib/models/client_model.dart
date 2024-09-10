import 'dart:convert';

class ClientModel {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String username;
  final String role;
  final String? imageProfile;

  ClientModel({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.username,
    required this.role,
    this.imageProfile,
  });

  // Codec<String, dynamic> toModel {
  //   return {

  //   }
  // }

  // factory ClientModel.fromModel(Map<String, dynamic> json) => ClientModel(
  //   id: json['id'],
  //   fullName: json['full_name'],
  //   phoneNumber: json['phone_number'],
  //   username: json['username'],
  //   role: json['role'],
  //   imageProfile: json['image_profile'],
  // );

  // factory ClientModel.fromJson(String source) => ClientModel.fromModel(json.decode(source));

  // String toJson() => json.encode(toModel());

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'username': username,
      'role': role,
      'image_profile': imageProfile,
    };
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id']?.toInt() ?? 0,
      fullName: map['full_name'] ?? '',
      phoneNumber: map['phone_number'] ?? '',
      username: map['username'] ?? '',
      role: map['role'] ?? '',
      imageProfile: map['image_profile'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ClientModel.fromJson(String source) =>
      ClientModel.fromMap(json.decode(source));
}
