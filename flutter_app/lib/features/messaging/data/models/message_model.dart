import '../../domain/entities/message.dart';

class MessageModel extends Message {
  const MessageModel({
    super.id,
    required super.text,
    required super.sender,
    required super.timestamp,
    super.type,
    super.imagePath,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] as int?,
      text: map['text'] as String,
      sender: map['sender'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      type: MessageType.values[map['type'] as int? ?? 0],
      imagePath: map['imagePath'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'sender': sender,
      'timestamp': timestamp.toIso8601String(),
      'type': type.index,
      'imagePath': imagePath,
    };
  }

  factory MessageModel.fromEntity(Message message) {
    return MessageModel(
      id: message.id,
      text: message.text,
      sender: message.sender,
      timestamp: message.timestamp,
      type: message.type,
      imagePath: message.imagePath,
    );
  }
}