import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:turbo_vets_assessment/core/presentation/res/colors.dart';
import 'package:turbo_vets_assessment/core/presentation/res/fonts.dart';
import 'package:turbo_vets_assessment/features/messaging/domain/entities/message.dart';

class MessageBubble extends StatefulWidget {
  final String text;
  final bool isCurrenUser;
  final String timeSent;
  final VoidCallback? onLongPress;
  final MessageType messageType;
  final String? imagePath;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isCurrenUser,
    required this.timeSent,
    this.onLongPress,
    this.messageType = MessageType.text,
    this.imagePath,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onLongPress: () => _showContextMenu(context, widget.onLongPress!),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Align(
          alignment: widget.isCurrenUser
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(
                minWidth: widget.text.length.toDouble(),
                maxWidth: MediaQuery.of(context).size.width * .75,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: !widget.isCurrenUser
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomLeft: Radius.circular(16),
                            ),
                      color: !widget.isCurrenUser ? cardColor : indigo,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: !widget.isCurrenUser
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.messageType == MessageType.image &&
                                  widget.imagePath != null) ...[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(widget.imagePath!),
                                    width:200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (widget.text.isNotEmpty) const Gap(8),
                              ],
                              if (widget.text.isNotEmpty)
                                Text(
                                  widget.text,
                                  textAlign: TextAlign.start,
                                  style: theme.textTheme.displayLarge!.copyWith(
                                    fontFamily: AppFonts.poppinsRegular,
                                    fontSize: 14,
                                    color: !widget.isCurrenUser
                                        ? theme.colorScheme.onSurface
                                        : Colors.white,
                                  ),
                                ),
                            ],
                          ),
                          const Gap(4),
                          !widget.isCurrenUser
                              ? SizedBox(
                                  width: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.timeSent,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontFamily: AppFonts.poppinsRegular,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600,
                                          color: !widget.isCurrenUser
                                              ? theme.colorScheme.onSurface
                                                    .withValues(alpha: .5)
                                              : theme.colorScheme.surface
                                                    .withValues(alpha: .5),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.timeSent,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          fontFamily: AppFonts.poppinsRegular,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w600,
                                          color: !widget.isCurrenUser
                                              ? theme.colorScheme.onSurface
                                                    .withValues(alpha: .5)
                                              : Colors.white.withValues(
                                                  alpha: .5,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context, VoidCallback onLongPress) async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SizedBox(
        height: 80,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete Message'),
              onTap: () {
                Navigator.of(context).pop();
                if (widget.onLongPress != null) {
                  widget.onLongPress!();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
