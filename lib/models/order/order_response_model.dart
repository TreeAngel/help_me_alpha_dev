import 'dart:convert';
import 'order_model.dart';

class OrderResponseModel {
  List<OrderModel>? data;

  OrderResponseModel({this.data});

  factory OrderResponseModel.fromMap(Map<String, dynamic> data) => 
    OrderResponseModel(
      data: (data['data'] as List<dynamic>?)
          ?.map((e) => OrderModel.fromMap(e as Map<String, dynamic>))
          .toList(),
    );

  Map<String, dynamic> toMap() => {
     'data': data?.map((e) => e.toMap()).toList(),
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
}


// class OfferResponseModel {
//   final int orderId;
//   final String userName;
//   final String problemDescription;
//   final String orderTime;
//   final String problem;
//   final String attachmentUrl;
//   final String latitude;

//   OfferResponseModel({
//     required this.orderId,
//     required this.userName,
//     required this.problemDescription,
//     required this.orderTime,
//     required this.problem,
//     required this.attachmentUrl,
//     required this.latitude,
//   });

//   factory OfferResponseModel.fromJson(Map<String, dynamic> json) {
//     return OfferResponseModel(
//       orderId: json['orderId'],
//       userName: json['userName'],
//       problemDescription: json['problemDescription'],
//       orderTime: json['orderTime'],
//       problem: json['problem'],
//       attachmentUrl: json['attachmentUrl'],
//       latitude: json['latitude'],
//     );
//   }
// }