import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class UserProfileCard extends StatelessWidget {
  final Map<String, dynamic> userProfile;
  final VoidCallback? onTap;

  const UserProfileCard({
    Key? key,
    required this.userProfile,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> sportsInterests =
        userProfile['sportsInterests'] as List? ?? [];
    final List<dynamic> photos = userProfile['photos'] as List? ?? [];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 85.w,
        height: 4.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow
                  .withAlpha((255 * 0.15).round()),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Main profile image
              Positioned.fill(
                child: CustomImageWidget(
                  imageUrl: photos.isNotEmpty
                      ? photos[0] as String
                      : userProfile['profileImage'] as String? ?? '',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withAlpha((255 * 0.3).round()),
                        Colors.black.withAlpha((255 * 0.8).round()),
                      ],
                      stops: [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                ),
              ),

              // User information overlay
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Name and age
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${userProfile['name'] ?? AppLocalizations.unknown}, ${userProfile['age'] ?? AppLocalizations.na}',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary
                                  .withAlpha((255 * 0.9).round()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'location_on',
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${userProfile['distance'] ?? '0'} ${AppLocalizations.km}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 1.h),

                      // Sports interests
                      sportsInterests.isNotEmpty
                          ? Wrap(
                              spacing: 2.w,
                              runSpacing: 1.h,
                              children: sportsInterests.take(3).map((sport) {
                                final sportMap = sport as Map<String, dynamic>;
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 3.w, vertical: 0.5.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withAlpha((255 * 0.2).round()),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color:
                                          Colors.white.withAlpha((255 * 0.3).round()),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        sportMap['name'] ?? '',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(width: 1.w),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.5.w, vertical: 0.2.h),
                                        decoration: BoxDecoration(
                                          color: _getSkillLevelColor(
                                              context,
                                              sportMap['skillLevel']
                                                      as String? ??
                                                  'Beginner'),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          sportMap['skillLevel'] ?? 'Beginner',
                                          style: AppTheme
                                              .lightTheme.textTheme.labelSmall
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            )
                          : SizedBox.shrink(),

                      SizedBox(height: 1.h),

                      // Availability indicator
                      userProfile['isAvailable'] == true
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.8.h),
                              decoration: BoxDecoration(
                                color: AppTheme.successLight
                                    .withAlpha((255 * 0.9).round()),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    AppLocalizations.availableNow,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodySmall
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),

              // Photo indicators
              photos.length > 1
                  ? Positioned(
                      top: 2.h,
                      left: 4.w,
                      right: 4.w,
                      child: Row(
                        children: photos.asMap().entries.map((entry) {
                          return Expanded(
                            child: Container(
                              height: 3,
                              margin: EdgeInsets.symmetric(horizontal: 1),
                              decoration: BoxDecoration(
                                color: entry.key == 0
                                    ? Colors.white
                                    : Colors.white.withAlpha((255 * 0.3).round()),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSkillLevelColor(BuildContext context, String skillLevel) {
    switch (skillLevel.toLowerCase()) {
      case 'beginner':
        return Theme.of(context).colorScheme.tertiary;
      case 'intermediate':
        return Theme.of(context).colorScheme.primary;
      case 'advanced':
        return AppTheme.errorLight;
      case 'expert':
        return Colors.purple;
      default:
        return Theme.of(context).colorScheme.tertiary;
    }
  }
}
