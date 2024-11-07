import 'dart:convert';

import 'helper.dart';

class UserMitraModel {
  int? id;
  String? name;
  double? latitude;
  double? longitude;
  int? saldo;
  String? nomorRekening;
  String? category;
  int? isVerified;
  List<Helper>? helpers;

  UserMitraModel({
    this.id,
    this.name,
    this.latitude,
    this.longitude,
    this.saldo,
    this.nomorRekening,
    this.category,
    this.isVerified,
    this.helpers,
  });

  @override
  String toString() {
    return 'UserMitraModel(id: $id, name: $name, latitude: $latitude, longitude: $longitude, saldo: $saldo, nomorRekening: $nomorRekening, category: $category, isVerified: $isVerified, helpers: $helpers)';
  }

  factory UserMitraModel.fromMap(Map<String, dynamic> data) {
    return UserMitraModel(
      id: data['id'] as int?,
      name: data['name'] as String?,
      latitude: data['latitude'] as double?,
      longitude: data['longitude'] as double?,
      saldo: data['saldo'] as int?,
      nomorRekening: data['nomor_rekening'] as String?,
      category: data['category_id'] as String?,
      isVerified: data['is_verified'] as int?,
      helpers: (data['helpers'] as List<dynamic>?)
          ?.map((e) => Helper.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'latitude': latitude,
        'longitude': longitude,
        'saldo': saldo,
        'nomor_rekening': nomorRekening,
        'category_id': category,
        'is_verified': isVerified,
        'helpers': helpers?.map((e) => e.toMap()).toList(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserMitraModel].
  factory UserMitraModel.fromJson(String data) {
    return UserMitraModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserMitraModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
