import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:turbo_vets_assessment/core/presentation/res/colors.dart';
import 'package:turbo_vets_assessment/core/presentation/res/images.dart';
import 'package:turbo_vets_assessment/core/presentation/widgets/clickable.dart';
import 'package:turbo_vets_assessment/core/presentation/widgets/svg_image.dart';
import 'package:turbo_vets_assessment/features/messaging/presentation/screens/messages_screen.dart';

class ConversationItem extends StatelessWidget {
  const ConversationItem({
    super.key,
    required this.lastMessage,
    required this.time,
    required this.name,
  });
  final String lastMessage;
  final String time;
  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Clickable(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) {
              return MessagesScreen(name: name);
            },
          ),
        );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(radius: 25, child: Image.asset(avatar, fit: BoxFit.cover,)),
              // Online indicator
              Positioned(
                right: 0,
                bottom: 0,
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
          const Gap(16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 15),
                ),
                const Gap(8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgImage(
                      asset: 'assets/vectors/double_checks.svg',
                      color: greyLight,
                    ),
                    Expanded(
                      child: Text(
                        lastMessage,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 13,
                          color: greyLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: greyLight.withValues(alpha: .5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
