import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class NavigationControlsWidget extends StatelessWidget {
  final VoidCallback? onNext;
  final VoidCallback? onSkip;
  final VoidCallback? onGetStarted;
  final bool isLastPage;
  final bool showSkip;

  const NavigationControlsWidget({
    Key? key,
    this.onNext,
    this.onSkip,
    this.onGetStarted,
    required this.isLastPage,
    this.showSkip = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Skip button
          showSkip && !isLastPage
              ? TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onSurface
                        .withAlpha((255 * 0.6).round()),
                    padding: 
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                  ),
                  child: Text(
                    AppLocalizations.skip,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : SizedBox(width: 20.w),

          // Main action button
          isLastPage
              ? ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.getStarted,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      CustomIconWidget(
                        iconName: 'arrow_forward',
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      ),
                    ],
                  ),
                )
              : ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.all(3.w),
                    shape: CircleBorder(),
                    elevation: 2,
                  ),
                  child: CustomIconWidget(
                    iconName: 'arrow_forward',
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
        ],
      ),
    );
  }
}
