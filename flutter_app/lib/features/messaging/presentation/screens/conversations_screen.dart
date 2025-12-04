import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:turbo_vets_assessment/core/presentation/res/colors.dart';
import 'package:turbo_vets_assessment/core/presentation/res/fonts.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/widgets/conversation_item.dart';

class ConversationsScreen extends StatefulWidget {
  const ConversationsScreen({super.key});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  final conversations = [
    // Example conversation items
    ConversationItem(
      name: 'Alice Johnson',
      lastMessage: 'Hey! How are you?',
      time: '2:30 PM',
    ),
    ConversationItem(
      name: 'Bob Smith',
      lastMessage: 'Let\'s catch up tomorrow.',
      time: '1:15 PM',
    ),
    ConversationItem(
      name: 'Charlie Davis',
      lastMessage: 'Got it, thanks!',
      time: 'Yesterday',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Conversations',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: AppFonts.poppinsBold,
            
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return conversations[index];
                },
                separatorBuilder: (context, index) => Column(
                  children: [
                    Gap(8),
                    Divider(color: greyLight.withValues(alpha: .2)),
                    Gap(8),
                  ],
                ),
                itemCount: conversations.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
