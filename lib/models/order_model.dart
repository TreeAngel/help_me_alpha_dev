class DataOrder {
  final List<OrderModel> data;

  DataOrder({required this.data});
}

class OrderModel {
  final int id;
  final int userId;
  final int mitraId;
  final DateTime orderTime;
  final double long;
  final double lat;
  final String status;
  final int categoryId;
  final String subCategoryId;

  OrderModel({
    required this.id,
    required this.userId,
    required this.mitraId,
    required this.orderTime,
    required this.long,
    required this.lat,
    required this.status,
    required this.categoryId,
    required this.subCategoryId,
  });
}
