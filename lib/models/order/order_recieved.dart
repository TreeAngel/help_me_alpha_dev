import 'dart:convert';

class OrderRecieved {
  int? id;
  String? category;
  String? problem;
  String? latitude;
  String? longitude;
  String? description;
  List<dynamic>? attachments;

  OrderRecieved({
    this.id,
    this.category,
    this.problem,
    this.latitude,
    this.longitude,
    this.description,
    this.attachments,
  });

  factory OrderRecieved.fromMap(Map<String, dynamic> data) => OrderRecieved(
        id: data['id'] as int?,
        category: data['category'] as String?,
        problem: data['problem'] as String?,
        latitude: data['latitude'] as String?,
        longitude: data['longitude'] as String?,
        description: data['description'] as String?,
        attachments: data['attachments'] as List<dynamic>?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'category': category,
        'problem': problem,
        'latitude': latitude,
        'longitude': longitude,
        'description': description,
        'attachments': attachments,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [OrderRecieved].
  factory OrderRecieved.fromJson(String data) {
    return OrderRecieved.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [OrderRecieved] to a JSON string.
  String toJson() => json.encode(toMap());
}
