import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class MessageBubbleWidget extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime timestamp;
  final bool isRead;
  final String? imageUrl;
  final Map<String, dynamic>? gameProposal;

  const MessageBubbleWidget({
    Key? key,
    required this.message,
    required this.isMe,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
    this.gameProposal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 4.w),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 2.5.w,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: CustomIconWidget(
                iconName: 'person',
                color: Theme.of(context).colorScheme.onSecondary,
                size: 20,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: 70.w),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isMe
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4.w),
                      topRight: Radius.circular(4.w),
                      bottomLeft:
                          isMe ? Radius.circular(4.w) : Radius.circular(1.w),
                      bottomRight:
                          isMe ? Radius.circular(1.w) : Radius.circular(4.w),
                    ),
                    border: !isMe
                        ? Border.all(
                            color: Theme.of(context).colorScheme.outline
                                .withAlpha((255 * 0.3).round()),
                            width: 1,
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (imageUrl != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2.w),
                          child: CustomImageWidget(
                            imageUrl: imageUrl!,
                            width: 60.w,
                            height: 4.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (message.isNotEmpty) SizedBox(height: 1.h),
                      ],
                      if (gameProposal != null) ...[
                        _buildGameProposalCard(context),
                        if (message.isNotEmpty) SizedBox(height: 1.h),
                      ],
                      if (message.isNotEmpty)
                        Text(
                          message,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            color: isMe
                                ? Theme.of(context).colorScheme.onPrimary
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 0.5.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 10.sp,
                      ),
                    ),
                    if (isMe) ...[
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: isRead ? 'done_all' : 'done',
                        color: isRead
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          if (isMe) ...[
            SizedBox(width: 2.w),
            CircleAvatar(
              radius: 2.5.w,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: CustomIconWidget(
                iconName: 'person',
                color: Theme.of(context).colorScheme.onPrimary,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGameProposalCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary.withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color:
              Theme.of(context).colorScheme.tertiary.withAlpha((255 * 0.3).round()),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'sports_tennis',
                color: Theme.of(context).colorScheme.tertiary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                AppLocalizations.gameProposal,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '${gameProposal!['sport']} • ${gameProposal!['date']}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            '${gameProposal!['time']} • ${gameProposal!['venue']}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.error,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    AppLocalizations.decline,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: Text(
                    AppLocalizations.accept,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return AppLocalizations.now;
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else {
      return '${dateTime.month}/${dateTime.day}';
    }
  }
}
