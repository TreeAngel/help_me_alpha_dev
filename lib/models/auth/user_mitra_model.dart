class UserMitraModel {
  final int? id;
  final String? identifier;
  final String? name;
  final int? saldo;
  final double? lat;
  final double? long;
  final String? category;

  const UserMitraModel({
    this.id,
    this.identifier,
    this.name,
    this.saldo,
    this.lat,
    this.long,
    this.category,
  });

  factory UserMitraModel.fromModel(Map<String, dynamic> json) => UserMitraModel(
        id: json['id'],
        identifier: json['owner_identifier'],
        name: json['name'],
        saldo: json['saldo'],
        lat: json['latitude'],
        long: json['longitude'],
        category: json['category'],
      );
}
