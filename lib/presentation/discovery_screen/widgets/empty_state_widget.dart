import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onOptimizeProfile;

  const EmptyStateWidget({
    Key? key,
    required this.onRefresh,
    required this.onOptimizeProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
                  .withAlpha((255 * 0.1).round()),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'search',
                color: Theme.of(context).colorScheme.primary,
                size: 60,
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Title
          Text(
            AppLocalizations.noMorePlayersNearby,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Description
          Text(
            AppLocalizations.noMorePlayersNearbyDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Tips section
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary
                  .withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary
                    .withAlpha((255 * 0.3).round()),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'lightbulb',
                      color: Theme.of(context).colorScheme.tertiary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      AppLocalizations.tipsToGetMoreMatches,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                _buildTipItem(context, AppLocalizations.addMorePhotos),
                _buildTipItem(context, AppLocalizations.updateSportsInterests),
                _buildTipItem(context, AppLocalizations.expandSearchRadius),
                _buildTipItem(context, AppLocalizations.beActiveDuringPeakHours),
              ],
            ),
          ),

          SizedBox(height: 4.h),

          // Action buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onOptimizeProfile,
                  child: Text(AppLocalizations.optimizeMyProfile),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onRefresh,
                  child: Text(AppLocalizations.refresh),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 0.5.h),
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              tip,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
