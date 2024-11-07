import 'dart:convert';

import 'pivot.dart';

class Helper {
  int? helperId;
  String? name;
  Pivot? pivot;

  Helper({this.helperId, this.name, this.pivot});

  @override
  String toString() {
    return 'Helper(helperId: $helperId, name: $name, pivot: $pivot)';
  }

  factory Helper.fromMap(Map<String, dynamic> data) => Helper(
        helperId: data['helper_id'] as int?,
        name: data['name'] as String?,
        pivot: data['pivot'] == null
            ? null
            : Pivot.fromMap(data['pivot'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'helper_id': helperId,
        'name': name,
        'pivot': pivot?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [Helper].
  factory Helper.fromJson(String data) {
    return Helper.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [Helper] to a JSON string.
  String toJson() => json.encode(toMap());
}
