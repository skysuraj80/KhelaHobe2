import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OnboardingPageWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final bool isLastPage;

  const OnboardingPageWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.description,
    this.isLastPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
        child: Column(
          children: [
            // Hero illustration - upper third
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: CustomImageWidget(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Content - middle section
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    title,
                    style:
                        Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 2.h),

                  // Description
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface
                          .withAlpha((255 * 0.7).round()),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            // Interactive demo section for specific pages
            if (title.contains('Swipe'))
              _buildSwipeDemo(context)
            else if (title.contains('Location'))
              _buildLocationDemo(context)
            else if (title.contains('Schedule'))
              _buildScheduleDemo(context),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSwipeDemo(BuildContext context) {
    return Container(
      height: 4.h,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background card
          Container(
            width: 70.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Text(
                'Sample Player Card',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),

          // Swipe indicators
          Positioned(
            left: 10.w,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.errorLight.withAlpha((255 * 0.1).round()),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.errorLight,
                size: 20,
              ),
            ),
          ),

          Positioned(
            right: 10.w,
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withAlpha((255 * 0.1).round()),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.successLight,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationDemo(BuildContext context) {
    return Container(
      height: 4.h,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Map background
          Container(
            width: 70.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer
                  .withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary
                    .withAlpha((255 * 0.3).round()),
                width: 2,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'location_on',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
          ),

          // Radius circle
          Container(
            width: 70.w,
            height: 4.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary
                    .withAlpha((255 * 0.5).round()),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleDemo(BuildContext context) {
    return Container(
      height: 4.h,
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Date picker demo
          Container(
            width: 30.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Aug 7',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),

          // Time picker demo
          Container(
            width: 30.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.shadowLight,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'access_time',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                SizedBox(height: 1.h),
                Text(
                  '6:00 PM',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
