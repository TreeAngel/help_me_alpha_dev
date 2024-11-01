import 'dart:convert';

class OrderModel {
  final int orderId;
  final String orderStatus;
  final String latitude;
  final String longitude;
  final String description;
  final String orderTime;
  final String user;
  final String userProfile; // URL profil pengguna
  final int price;
  final String problem;
  List<String>? attachment;

  OrderModel({
    required this.orderId,
    required this.orderStatus,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.orderTime,
    required this.user,
    required this.userProfile,
    required this.price,
    required this.problem,
    required this.attachment,
  });

  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      orderId: data['order_id'] as int,
      orderStatus: data['order_status'] as String,
      latitude: data['latitude'] as String,
      longitude: data['longitude'] as String,
      description: data['description'] as String,
      orderTime: data['order_time'] as String,
      user: data['user'] as String,
      userProfile: data['user_profile'] as String,
      price: int.parse(data['price'] as String), // Asumsikan selalu ada dan valid
      problem: data['problem'] as String,
      attachment: List<String>.from(data['attachment']), // Asumsikan selalu list, meski kosong
    );
  }

  Map<String, dynamic> toMap() => {
    'order_id': orderId,
    'order_status': orderStatus,
    'latitude': latitude,
    'longitude': longitude,
    'description': description,
    'order_time': orderTime,
    'user': user,
    'user_profile': userProfile,
    'price': price,
    'problem': problem,
    'attachment': attachment?.isNotEmpty == true ? attachment : [], // Jika ada lampiran
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
}


// class OrderModel {
//   final int orderId;
//   final String userProfileUrl;
//   final String username;
//   final String problemDescription;
//   final String orderTime;
//   final String problem;
//   final String attachmentUrl;
//   final String latitude;

//   OrderModel({
//     required this.orderId,
//     required this.userProfileUrl,
//     required this.username,
//     required this.problemDescription,
//     required this.orderTime,
//     required this.problem,
//     required this.attachmentUrl,
//     required this.latitude,
//   });

//   factory OrderModel.fromJson(Map<String, dynamic> json) {
//     return OrderModel(
//       orderId: json['orderId'],
//       userProfileUrl: json['userProfileUrl'],
//       username: json['username'],
//       problemDescription: json['problemDescription'],
//       orderTime: json['orderTime'],
//       problem: json['problem'],
//       attachmentUrl: json['attachmentUrl'],
//       latitude: json['latitude'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'orderId': orderId,
//       'userProfileUrl': userProfileUrl,
//       'username': username,
//       'problemDescription': problemDescription,
//       'orderTime': orderTime,
//       'problem': problem,
//       'attachmentUrl': attachmentUrl,
//       'latitude': latitude,
//     };
//   }
// }


// // class DataOrder {
// //   final List<OrderModel> data;

// //   DataOrder({required this.data});
// // }

// // class OrderModel {
// //   final int id;
// //   final int userId;
// //   final int mitraId;
// //   final DateTime orderTime;
// //   final double long;
// //   final double lat;
// //   final String status;
// //   final int categoryId;
// //   final String subCategoryId;

// //   OrderModel({
// //     required this.id,
// //     required this.userId,
// //     required this.mitraId,
// //     required this.orderTime,
// //     required this.long,
// //     required this.lat,
// //     required this.status,
// //     required this.categoryId,
// //     required this.subCategoryId,
// //   });
// // }
