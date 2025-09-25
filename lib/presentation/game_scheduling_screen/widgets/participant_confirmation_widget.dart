import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class ParticipantConfirmationWidget extends StatelessWidget {
  final Map<String, dynamic> currentUser;
  final Map<String, dynamic> matchedUser;

  const ParticipantConfirmationWidget({
    Key? key,
    required this.currentUser,
    required this.matchedUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha((255 * 0.2).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.participants,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: _buildParticipantCard(context, currentUser, AppLocalizations.you),
              ),
              SizedBox(width: 3.w),
              CustomIconWidget(
                iconName: 'sports_handball',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildParticipantCard(context, matchedUser, AppLocalizations.partner),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildParticipantCard(BuildContext context, Map<String, dynamic> user, String label) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.05).round()),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha((255 * 0.2).round()),
        ),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.w),
            child: CustomImageWidget(
              imageUrl: user["avatar"] ?? "",
              width: 16.w,
              height: 16.w,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            user["name"] ?? AppLocalizations.unknown,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 0.5.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary
                  .withAlpha((255 * 0.2).round()),
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: Text(
              "${AppLocalizations.level} ${user["skillLevel"] ?? "Beginner"}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
