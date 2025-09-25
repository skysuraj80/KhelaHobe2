import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../models/user_profile.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileHeaderWidget({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50.w,
          backgroundImage: userProfile.profileImageUrl != null
              ? NetworkImage(userProfile.profileImageUrl!)
              : null,
          child: userProfile.profileImageUrl == null
              ? Text(userProfile.fullName[0])
              : null,
        ),
        SizedBox(height: 4.h),
        Text(
          userProfile.fullName,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        SizedBox(height: 8.h),
        Text(
          userProfile.email,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }
}
