import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:turbo_vets_assessment/core/presentation/res/colors.dart';
import 'package:turbo_vets_assessment/core/presentation/res/fonts.dart';
import 'package:turbo_vets_assessment/core/presentation/res/images.dart';
import 'package:turbo_vets_assessment/core/presentation/res/vectors.dart';
import 'package:turbo_vets_assessment/core/presentation/utilities/date_util.dart';
import 'package:turbo_vets_assessment/core/presentation/utilities/image_picker_util.dart';
import 'package:turbo_vets_assessment/core/presentation/widgets/clickable.dart';
import 'package:turbo_vets_assessment/core/presentation/widgets/svg_image.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/entities/message.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/bloc/message_bloc.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/bloc/message_event.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/bloc/message_state.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/widgets/message_bubble.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/widgets/typing_indicator.dart';
import 'package:turbo_vets_assessment/services/support_agent_service.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key, required this.name});
  final String name;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _chatController = TextEditingController();
  final _scrollController = ScrollController();
  final _chatFocus = FocusNode();
  final String _currentUser = 'Me';
  final ValueNotifier<bool> _isVisible = ValueNotifier(false);
  final ValueNotifier<bool> _isAgentTyping = ValueNotifier(false);
  final ImagePickerUtil _imagePickerUtil = ImagePickerUtil();

  @override
  void initState() {
    _scrollController.addListener(() {
      _isVisible.value = _scrollController.offset > 0;
    });
    super.initState();
    context.read<MessageBloc>().add(LoadMessages());
    _sendInitialGreeting();
  }

  void _sendInitialGreeting() {
    Future.delayed(Duration(seconds: 1), () {
      final greeting = SupportAgentService().getGreeting();
      final greetingMessage = Message(
        text: greeting,
        sender: SupportAgentService.agentName,
        timestamp: DateTime.now(),
        type: MessageType.text,
      );
      if (!mounted) return;

      context.read<MessageBloc>().add(
        SendMessageEvent(greetingMessage, triggerAutoReply: true),
      );
    });
  }

  @override
  void dispose() {
    _chatController.dispose();
    _scrollController.dispose();
    _chatFocus.dispose();
    _isVisible.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels !=
            _scrollController.position.minScrollExtent) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 800),
        curve: Curves.fastLinearToSlowEaseIn,
      );

      _isVisible.value = false;
    }
  }

  void _sendMessage() {
    if (_chatController.text.trim().isEmpty) return;

    final message = Message(
      text: _chatController.text.trim(),
      sender: _currentUser,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );

    // Show typing indicator
    _isAgentTyping.value = true;

    context.read<MessageBloc>().add(SendMessageEvent(message));
    _chatController.clear();
    _scrollToBottom();

    // Hide typing indicator after delay
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        _isAgentTyping.value = false;
      }
    });
  }

  void _deleteMessage(int? id) {
    if (id == null) return;
    context.read<MessageBloc>().add(DeleteMessageEvent(id));
  }

  Future<void> _pickAndSendImage() async {
    final String? imagePath = await _imagePickerUtil.pickImage();

    if (imagePath != null) {
      final message = Message(
        text: '',
        sender: _currentUser,
        timestamp: DateTime.now(),
        type: MessageType.image,
        imagePath: imagePath,
      );

      if (!mounted) return;
      _isAgentTyping.value = true;
      context.read<MessageBloc>().add(SendMessageEvent(message));
      _scrollToBottom();

      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          _isAgentTyping.value = false;
        }
      });
    }
  }

  Future<void> _takePhotoAndSend() async {
    final String? imagePath = await _imagePickerUtil.takePhoto();

    if (imagePath != null) {
      final message = Message(
        text: '',
        sender: _currentUser,
        timestamp: DateTime.now(),
        type: MessageType.image,
        imagePath: imagePath,
      );

      if (!mounted) return;
      _isAgentTyping.value = true;
      context.read<MessageBloc>().add(SendMessageEvent(message));
      _scrollToBottom();

      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          _isAgentTyping.value = false;
        }
      });
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: primaryColor),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickAndSendImage();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: primaryColor),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _takePhotoAndSend();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Clickable(
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.keyboard_arrow_left_rounded,
            // color: theme.colorScheme.onSurface,
            size: 30,
          ),
        ),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(radius: 20, backgroundImage: AssetImage(avatar)),
                Positioned(
                  right: 0,
                  bottom: -2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: greyLight, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: AppFonts.poppinsBold,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isAgentTyping,
                    builder: (context, isTyping, _) {
                      if (isTyping) {
                        return Text(
                          'typing...',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        );
                      }
                      return Text(
                        'Online',
                        style: TextStyle(color: Colors.green, fontSize: 12),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<MessageBloc, MessageState>(
              builder: (context, state) {
                if (state is MessageLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is MessageLoaded) {
                  return Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: GlowingOverscrollIndicator(
                          axisDirection: AxisDirection.up,
                          color: primaryColor,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: state.messages.length,
                            controller: _scrollController,
                            reverse: true,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              return MessageBubble(
                                onLongPress: () => _deleteMessage(message.id),
                                text: message.text,
                                isCurrenUser: message.sender == _currentUser,
                                timeSent: DateUtil.formatTime(
                                  message.timestamp,
                                ),
                                messageType: message.type,
                                imagePath: message.imagePath,
                              );
                            },
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomRight,
                        child: ValueListenableBuilder(
                          valueListenable: _isVisible,
                          builder: (context, isVisible, child) {
                            return isVisible
                                ? GestureDetector(
                                    onTap: () => _scrollToBottom(),
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      margin: const EdgeInsets.only(
                                        right: 10,
                                        bottom: 50,
                                      ),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: theme.primaryColor,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons
                                              .keyboard_double_arrow_down_outlined,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  );
                } else if (state is MessageError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox();
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: ValueListenableBuilder<bool>(
              valueListenable: _isAgentTyping,
              builder: (context, isTyping, _) {
                if (isTyping) {
                  return Positioned(
                    bottom: 16,
                    left: 16,
                    child: TypingIndicator(),
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Clickable(
                          onPressed: _showImageOptions,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: greyLight.withValues(alpha: .5),
                                width: 0.5,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.image,
                                color: primaryColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Expanded(
                          child: TextField(
                            textInputAction: TextInputAction.newline,
                            maxLines: 10,
                            minLines: 1,
                            controller: _chatController,
                            focusNode: _chatFocus,
                            keyboardType: TextInputType.multiline,
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor: theme.colorScheme.secondary,
                            onTapOutside: (value) {
                              _chatFocus.unfocus();
                            },
                            style: theme.textTheme.displayLarge?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontSize: 13,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Send a message...',
                              border: theme.inputDecorationTheme.border,
                              filled: false,
                              hintStyle: theme.textTheme.labelMedium?.copyWith(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface,
                              ),
                              suffixIconConstraints: BoxConstraints(
                                minHeight: 20,
                                minWidth: 20,
                              ),
                              isDense: true,
                              focusColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: theme.brightness == Brightness.dark
                                      ? theme.dividerColor
                                      : Color(0xFFD9DBDE),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  width: 1,
                                  color: theme.brightness == Brightness.dark
                                      ? theme.dividerColor
                                      : Color(0xFFD9DBDE),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Gap(8),
                        Clickable(
                          onPressed: _sendMessage,
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: primaryColor,
                            ),
                            child: Center(
                              child: SvgImage(
                                asset: send,
                                height: 24,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Gap(10),
        ],
      ),
    );
  }
}
