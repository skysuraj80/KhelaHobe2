import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class SafetyMenuWidget extends StatelessWidget {
  final VoidCallback onReport;
  final VoidCallback onBlock;
  final VoidCallback onEmergencyContact;

  const SafetyMenuWidget({
    Key? key,
    required this.onReport,
    required this.onBlock,
    required this.onEmergencyContact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            AppLocalizations.safetyAndSupport,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error
                    .withAlpha((255 * 0.1).round()),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'report',
                color: Theme.of(context).colorScheme.error,
                size: 20,
              ),
            ),
            title: Text(
              AppLocalizations.reportUser,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              AppLocalizations.reportUserDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              Navigator.pop(context);
              onReport();
            },
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error
                    .withAlpha((255 * 0.1).round()),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'block',
                color: Theme.of(context).colorScheme.error,
                size: 20,
              ),
            ),
            title: Text(
              AppLocalizations.blockUser,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              AppLocalizations.blockUserDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              Navigator.pop(context);
              onBlock();
            },
          ),
          ListTile(
            leading: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary
                    .withAlpha((255 * 0.1).round()),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'emergency',
                color: Theme.of(context).colorScheme.tertiary,
                size: 20,
              ),
            ),
            title: Text(
              AppLocalizations.shareEmergencyContact,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            subtitle: Text(
              AppLocalizations.shareEmergencyContactDescription,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {
              Navigator.pop(context);
              onEmergencyContact();
            },
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}

