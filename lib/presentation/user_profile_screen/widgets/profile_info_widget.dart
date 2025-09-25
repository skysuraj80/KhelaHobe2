import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/user_profile.dart';

class ProfileInfoWidget extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileInfoWidget({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bio',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8.h),
        Text(
          userProfile.bio ?? 'No bio provided.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 4.h),
        Text(
          'Location',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8.h),
        Text(
          userProfile.locationName ?? 'No location provided.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 4.h),
        Text(
          'Age',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        SizedBox(height: 8.h),
        Text(
          userProfile.age?.toString() ?? 'No age provided.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
