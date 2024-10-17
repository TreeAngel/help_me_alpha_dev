import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'message_error_model.dart';

@immutable
class ApiErrorResponseModel {
  final MessageErrorModel? error;
  final String? message;

  const ApiErrorResponseModel({this.error, this.message});

  @override
  String toString() => 'AuthErrorResponse(error: $error, message: $message)';

  factory ApiErrorResponseModel.fromMap(Map<String, dynamic> data) {
    return ApiErrorResponseModel(
      error: data['error'] == null
          ? null
          : MessageErrorModel.fromMap(data['error'] as Map<String, dynamic>),
        message: data['message'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'error': error?.toMap(),
        'message': message,
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
    String? message,
  }) {
    return ApiErrorResponseModel(
      error: error ?? this.error,
      message: message ?? this.message,
    );
  }
}
