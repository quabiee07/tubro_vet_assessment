import 'package:equatable/equatable.dart';

class Message extends Equatable {
  final int? id;
  final String text;
  final String sender;
  final DateTime timestamp;

  const Message({
    this.id,
    required this.text,
    required this.sender,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, text, sender, timestamp];
}