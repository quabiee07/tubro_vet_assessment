import 'package:turbo_vets_assessment/features/messaging/domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    super.id,
    required super.text,
    required super.sender,
    required super.timestamp,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as int?,
      text: map['text'] as String,
      sender: map['sender'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      text: message.text,
      sender: message.sender,
      timestamp: message.timestamp,
    );
  }
}
