import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool isUpcoming;
  final VoidCallback? onScheduleGame;

  const EmptyStateWidget({
    Key? key,
    required this.isUpcoming,
    this.onScheduleGame,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
                    .withAlpha((255 * 0.1).round()),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: isUpcoming ? 'event_available' : 'history',
                  color: Theme.of(context).colorScheme.primary,
                  size: 48,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              isUpcoming ? AppLocalizations.noUpcomingGames : AppLocalizations.noPastGames,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              isUpcoming
                  ? AppLocalizations.noUpcomingGamesDescription
                  : AppLocalizations.noPastGamesDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            if (isUpcoming) ...[
              SizedBox(height: 4.h),
              _buildQuickStartTips(context),
              SizedBox(height: 4.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onScheduleGame,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'add',
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        AppLocalizations.scheduleYourFirstGame,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStartTips(BuildContext context) {
    final tips = [
      {
        'icon': 'search',
        'title': AppLocalizations.findPlayers,
        'description': AppLocalizations.findPlayersDescription,
      },
      {
        'icon': 'schedule',
        'title': AppLocalizations.setYourTime,
        'description': AppLocalizations.setYourTimeDescription,
      },
      {
        'icon': 'location_on',
        'title': AppLocalizations.pickAVenue,
        'description': AppLocalizations.pickAVenueDescription,
      },
    ];

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha((255 * 0.2).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.quickStartTips,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 2.h),
          ...tips.map((tip) => _buildTipItem(context, tip)).toList(),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, Map<String, String> tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
                  .withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: tip['icon']!,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip['title']!,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  tip['description']!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
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
