import 'dart:convert';

class Pivot {
  int? mitraId;
  int? helperId;

  Pivot({this.mitraId, this.helperId});

  @override
  String toString() => 'Pivot(mitraId: $mitraId, helperId: $helperId)';

  factory Pivot.fromMap(Map<String, dynamic> data) => Pivot(
        mitraId: data['mitra_id'] as int?,
        helperId: data['helper_id'] as int?,
      );

  Map<String, dynamic> toMap() => {
        'mitra_id': mitraId,
        'helper_id': helperId,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Pivot].
  factory Pivot.fromJson(String data) {
    return Pivot.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Pivot] to a JSON string.
  String toJson() => json.encode(toMap());
}
