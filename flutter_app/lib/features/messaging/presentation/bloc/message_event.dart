import 'package:equatable/equatable.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/entities/message.dart';

abstract class MessageEvent extends Equatable {
  const MessageEvent();

  @override
  List<Object> get props => [];
}

class LoadMessages extends MessageEvent {}

class SendMessageEvent extends MessageEvent {
  final Message message;
  final bool triggerAutoReply;

  const SendMessageEvent(this.message, {this.triggerAutoReply = true});

  @override
  List<Object> get props => [message, triggerAutoReply];
}

class SendAgentMessageEvent extends MessageEvent {
  final Message message;

  const SendAgentMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}


class DeleteMessageEvent extends MessageEvent {
  final int id;

  const DeleteMessageEvent(this.id);

  @override
  List<Object> get props => [id];
}

class TriggerAutoReplyEvent extends MessageEvent {
  final String userMessage;

  const TriggerAutoReplyEvent(this.userMessage);

  @override
  List<Object> get props => [userMessage];
}