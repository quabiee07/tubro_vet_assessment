import 'package:flutter/material.dart';
import 'package:turbo_vets_assessment/core/domain/usecase/usecase.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/usecase/delete_message_usecase.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/usecase/get_messages_usecase.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/usecase/send_message_usecase.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/bloc/message_event.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/bloc/message_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turbo_vets_assessment/services/support_agent_service.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final DeleteMessage deleteMessage;
  final SupportAgentService _agent = SupportAgentService();
  MessageBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.deleteMessage,
  }) : super(MessageInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<SendAgentMessageEvent>(_onSendAgentMessage);
    on<DeleteMessageEvent>(_onDeleteMessage);
    on<TriggerAutoReplyEvent>(_onTriggerAutoReply);
  }

  Future<void> _onLoadMessages(
    LoadMessages event,
    Emitter<MessageState> emit,
  ) async {
    emit(MessageLoading());
    final result = await getMessages(NoParams());
    result.fold(
      (failure) => emit(const MessageError('Failed to load messages')),
      (messages) {
        debugPrint('✅ Loaded ${messages.length} messages');
        emit(MessageLoaded(messages));
      },
    );
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    debugPrint('📤 Sending message: ${event.message.text}');
    final result = await sendMessage(SendMessageParams(message: event.message));

    result.fold(
      (failure) {
        debugPrint('❌ Failed to send message');
        emit(const MessageError('Failed to send message'));
      },
      (_) {
        debugPrint('✅ Message sent successfully');
        add(LoadMessages());

        // Trigger auto-reply if enabled and message is from user
        if (event.triggerAutoReply &&
            !_agent.isAgentMessage(event.message.sender)) {
          debugPrint('🤖 Triggering auto-reply for: ${event.message.text}');
          add(TriggerAutoReplyEvent(event.message.text));
        }
      },
    );
  }

  Future<void> _onSendAgentMessage(
    SendAgentMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    debugPrint('🤖 Sending agent message: ${event.message.text}');
    final result = await sendMessage(SendMessageParams(message: event.message));

    result.fold(
      (failure) {
        debugPrint('❌ Failed to send agent message');
        emit(const MessageError('Failed to send agent message'));
      },
      (_) {
        debugPrint('✅ Agent message sent successfully');
        add(LoadMessages());
      },
    );
  }

  Future<void> _onDeleteMessage(
    DeleteMessageEvent event,
    Emitter<MessageState> emit,
  ) async {
    final result = await deleteMessage(DeleteMessageParams(id: event.id));
    result.fold(
      (failure) => emit(const MessageError('Failed to delete message')),
      (_) => add(LoadMessages()),
    );
  }

  Future<void> _onTriggerAutoReply(
    TriggerAutoReplyEvent event,
    Emitter<MessageState> emit,
  ) async {
    debugPrint('⏳ Generating auto-reply for: ${event.userMessage}');

    try {
      // Get intelligent response based on user message with delay
      final agentMessage = await _agent.getDelayedResponse(
        event.userMessage,
        minSeconds: 1,
        maxSeconds: 3,
      );

      debugPrint('💬 Agent response: ${agentMessage.text}');

      // Send agent message
      add(SendAgentMessageEvent(agentMessage));
    } catch (e) {
      debugPrint('❌ Error in auto-reply: $e');
    }
  }
}
