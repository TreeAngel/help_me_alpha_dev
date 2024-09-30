import 'dart:convert';

import 'package:equatable/equatable.dart';

class OrderHistoryModel extends Equatable {
  final int? orderId;
  final String? latitude;
  final String? longitude;
  final String? description;
  final String? orderTime;
  final String? user;
  final String? userProfile;
  final String? price;
  final String? category;
  final List<dynamic>? attachment;


  const OrderHistoryModel({
    this.orderId,
    this.latitude,
    this.longitude,
    this.description,
    this.orderTime,
    this.user,
    this.userProfile,
    this.price,
    this.category,
    this.attachment,
  });

  factory OrderHistoryModel.fromMap(Map<String, dynamic> data) {
    return OrderHistoryModel(
      orderId: data['order_id'] as int?,
      latitude: data['latitude'] as String?,
      longitude: data['longitude'] as String?,
      description: data['description'] as String?,
      orderTime: data['order_time'] as String?,
      user: data['user'] as String?,
      userProfile: data['user_profile'] as String?,
      price: data['price'] as String?,
      category: data['category'] as String?,
      attachment: data['attachment'] as List<dynamic>?,
    );
  }

  Map<String, dynamic> toMap() => {
        'order_id': orderId,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'order_time': orderTime,
        'user': user,
        'user_profile': userProfile,
        'price': price,
        'category': category,
        'attachment': attachment,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderHistoryModel].
  factory OrderHistoryModel.fromJson(String data) {
    return OrderHistoryModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderHistoryModel] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderHistoryModel copyWith({
    int? orderId,
    String? latitude,
    String? longitude,
    String? description,
    String? orderTime,
    String? user,
    String? userProfile,
    String? price,
    String? category,
    List<dynamic>? attachment
  }) {
    return OrderHistoryModel(
      orderId: orderId ?? this.orderId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      description: description ?? this.description,
      orderTime: orderTime ?? this.orderTime,
      user: user ?? this.user,
      userProfile: userProfile ?? this.userProfile,
      price: price ?? this.price,
      category: category ?? this.category,
      attachment: attachment ?? this.attachment,
    );
  }

  @override
  List<Object?> get props {
    return [
      orderId,
      latitude,
      longitude,
      description,
      orderTime,
      user,
      userProfile,
      price,
      category,
      attachment,
    ];
  }
}
