import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class LocationPermissionWidget extends StatelessWidget {
  final VoidCallback? onAllowLocation;
  final VoidCallback? onSkipLocation;

  const LocationPermissionWidget({
    Key? key,
    this.onAllowLocation,
    this.onSkipLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Location icon
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary
                  .withAlpha((255 * 0.1).round()),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'location_on',
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),

          SizedBox(height: 3.h),

          // Title
          Text(
            AppLocalizations.enableLocationAccess,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Description
          Text(
            AppLocalizations.locationAccessDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface
                  .withAlpha((255 * 0.7).round()),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 4.h),

          // Privacy features
          Row(
            children: [
              Expanded(
                child: _buildPrivacyFeature(
                  context,
                  icon: 'security',
                  title: AppLocalizations.secure,
                  description: AppLocalizations.dataEncrypted,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildPrivacyFeature(
                  context,
                  icon: 'visibility_off',
                  title: AppLocalizations.private,
                  description: AppLocalizations.notShared,
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: _buildPrivacyFeature(
                  context,
                  icon: 'settings',
                  title: AppLocalizations.control,
                  description: AppLocalizations.youDecide,
                ),
              ),
            ],
          ),

          SizedBox(height: 4.h),

          // Action buttons
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onAllowLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.allowLocationAccess,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              TextButton(
                onPressed: onSkipLocation,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface
                      .withAlpha((255 * 0.6).round()),
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                ),
                child: Text(
                  AppLocalizations.maybeLater,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyFeature(
    BuildContext context, {
    required String icon,
    required String title,
    required String description,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: 
                Theme.of(context).colorScheme.primary.withAlpha((255 * 0.1).round()),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 0.5.h),
        Text(
          description,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface
                .withAlpha((255 * 0.6).round()),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
