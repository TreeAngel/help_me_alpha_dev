import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'order_model.dart';

class OrderResponseModel extends Equatable {
  final String? message;
  final OrderModel? order;

  const OrderResponseModel({this.message, this.order});

  factory OrderResponseModel.fromMap(Map<String, dynamic> data) =>
      OrderResponseModel(
        message: data['message'] as String?,
        order: data['order'] == null
            ? null
            : OrderModel.fromMap(data['order'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'message': message,
        'order': order?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderResponseModel].
  factory OrderResponseModel.fromJson(String data) {
    return OrderResponseModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());

  OrderResponseModel copyWith({
    String? message,
    OrderModel? order,
  }) {
    return OrderResponseModel(
      message: message ?? this.message,
      order: order ?? this.order,
    );
  }

  @override
  List<Object?> get props => [message, order];
}
