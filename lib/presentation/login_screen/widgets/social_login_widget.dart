import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';
import '../../../localization/app_localizations.dart';

class SocialLoginWidget extends StatelessWidget {
  final ValueChanged<String> onSocialLogin;
  final bool isLoading;

  const SocialLoginWidget({
    Key? key,
    required this.onSocialLogin,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Divider with "OR" text
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.outline,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                AppLocalizations.orContinueWith,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Theme.of(context).colorScheme.outline,
                thickness: 1,
              ),
            ),
          ],
        ),

        SizedBox(height: 3.h),

        // Social Login Buttons
        Column(
          children: [
            // Apple Sign-In (iOS prominent)
            if (defaultTargetPlatform == TargetPlatform.iOS) ...[
              _buildSocialButton(
                context: context,
                provider: 'Apple',
                icon: 'apple',
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onTap: () => onSocialLogin('apple'),
              ),
              SizedBox(height: 2.h),
            ],

            // Google Sign-In
            _buildSocialButton(
              context: context,
              provider: 'Google',
              icon: 'g_translate',
              backgroundColor: Colors.white,
              textColor: Colors.black87,
              borderColor: Theme.of(context).colorScheme.outline,
              onTap: () => onSocialLogin('google'),
            ),

            SizedBox(height: 2.h),

            // Facebook Sign-In
            _buildSocialButton(
              context: context,
              provider: 'Facebook',
              icon: 'facebook',
              backgroundColor: Color(0xFF1877F2),
              textColor: Colors.white,
              onTap: () => onSocialLogin('facebook'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required BuildContext context,
    required String provider,
    required String icon,
    required Color backgroundColor,
    required Color textColor,
    Color? borderColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          side: BorderSide(
            color: borderColor ?? backgroundColor,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: icon,
              color: textColor,
              size: 24,
            ),
            SizedBox(width: 3.w),
            Text(
              'Continue with $provider',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
