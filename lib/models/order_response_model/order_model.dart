import 'dart:convert';

import 'package:equatable/equatable.dart';

class OrderModel extends Equatable {
  final int? id;
  final String? latitude;
  final String? longitude;
  final String? description;
  final List<String>? attachments;

  const OrderModel({
    this.id,
    this.latitude,
    this.longitude,
    this.description,
    this.attachments,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data) => OrderModel(
        id: data['id'] as int?,
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        description: data['description'] as String?,
        attachments: data['attachments'] as List<String>?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'attachments': attachments,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderModel].
  factory OrderModel.fromJson(String data) {
    return OrderModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderModel] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderModel copyWith({
    int? id,
    String? latitude,
    String? longitude,
    String? description,
    List<String>? attachments,
  }) {
    return OrderModel(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      attachments: attachments ?? this.attachments,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      latitude,
      longitude,
      description,
      attachments,
    ];
  }
}
