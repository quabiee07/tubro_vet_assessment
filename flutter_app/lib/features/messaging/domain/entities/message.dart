import 'package:equatable/equatable.dart';

enum MessageType { text, image }

class Message extends Equatable {
  final int? id;
  final String text;
  final String sender;
  final DateTime timestamp;
  final MessageType type;
  final String? imagePath;

  const Message({
    this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
    this.type = MessageType.text,
    this.imagePath,
  });

  @override
  List<Object?> get props => [id, text, sender, timestamp, type, imagePath];
}