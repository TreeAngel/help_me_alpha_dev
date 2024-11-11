import 'dart:convert';

class OrderReceived {
  int? id;
  String? category;
  String? problem;
  double? latitude;
  double? longitude;
  String? description;
  List<dynamic>? attachments;

  OrderReceived({
    this.id,
    this.category,
    this.problem,
    this.latitude,
    this.longitude,
    this.description,
    this.attachments,
  });

  factory OrderReceived.fromMap(Map<String, dynamic> data) => OrderReceived(
        id: (data['id'] ?? data['order_id']) is int
            ? (data['id'] ?? data['order_id'])
            : int.parse((data['id'] ?? data['order_id'])),
        category: data['category'] as String?,
        problem: data['problem'] as String?,
        latitude: double.parse(data['latitude']),
        longitude: double.parse(data['longitude']),
        description: data['description'] as String?,
        attachments: (data['attachments'] ?? data['attachment']) is String
            ? (data['attachments'] ?? data['attachment'] as String).split(',')
            : (data['attachments'] ?? data['attachment']),
      );

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderReceived].
  factory OrderReceived.fromJson(String data) {
    return OrderReceived.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  @override
  String toString() {
    return 'OrderRecieved(id: $id, category: $category, problem: $problem, latitude: $latitude, longitude: $longitude, description: $description, attachments: $attachments)';
  }
}
