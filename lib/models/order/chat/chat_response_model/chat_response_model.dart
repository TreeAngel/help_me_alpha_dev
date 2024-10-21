import 'dart:convert';

class ChatResponseModel {
  int? id;
  int? senderId;
  String? message;
  String? attachment;
  DateTime? createdAt;

  ChatResponseModel({
    this.id,
    this.senderId,
    this.message,
    this.attachment,
    this.createdAt,
  });

  @override
  String toString() =>
      'ChatResponseModel(id: $id, senderId: $senderId, message: $message, attachment: $attachment, createdAt: $createdAt)';

  factory ChatResponseModel.fromMap(Map<String, dynamic> data) {
    return ChatResponseModel(
      id: data['id'] as int?,
      senderId: data['sender_id'] as int?,
      message: data['message'] as String?,
      attachment: data['attachment'] as String?,
      createdAt: data['created_at'] == null
          ? null
          : DateTime.parse(data['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'sender_id': senderId,
        'message': message,
        'attachment': attachment,
        'created_at': createdAt?.toIso8601String(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [ChatResponseModel].
  factory ChatResponseModel.fromJson(String data) {
    return ChatResponseModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [ChatResponseModel] to a JSON string.
  String toJson() => json.encode(toMap());
}
