import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'message_error_model.dart';

@immutable
class ApiErrorResponseModel {
  final MessageErrorModel? error;

  const ApiErrorResponseModel({this.error});

  @override
  String toString() => 'AuthErrorResponse(error: $error)';

  factory ApiErrorResponseModel.fromMap(Map<String, dynamic> data) {
    return ApiErrorResponseModel(
      error: data['error'] == null
          ? null
          : MessageErrorModel.fromMap(data['error'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toMap() => {
        'error': error?.toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ApiErrorResponseModel].
  factory ApiErrorResponseModel.fromJson(String data) {
    return ApiErrorResponseModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ApiErrorResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());

  ApiErrorResponseModel copyWith({
    MessageErrorModel? error,
  }) {
    return ApiErrorResponseModel(
      error: error ?? this.error,
    );
  }
}
