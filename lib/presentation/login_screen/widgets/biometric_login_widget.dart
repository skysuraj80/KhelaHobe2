import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricLoginWidget extends StatelessWidget {
  final VoidCallback onBiometricLogin;
  final bool isAvailable;
  final bool isLoading;

  const BiometricLoginWidget({
    Key? key,
    required this.onBiometricLogin,
    required this.isAvailable,
    required this.isLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isAvailable) return SizedBox.shrink();

    return Column(
      children: [
        SizedBox(height: 2.h),

        // Biometric Login Button
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline
                  .withAlpha((255 * 0.3).round()),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                'Quick Login',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(height: 1.h),
              GestureDetector(
                onTap: isLoading ? null : onBiometricLogin,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary
                        .withAlpha((255 * 0.1).round()),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: defaultTargetPlatform == TargetPlatform.iOS
                        ? 'face'
                        : 'fingerprint',
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                defaultTargetPlatform == TargetPlatform.iOS
                    ? 'Use Face ID or Touch ID'
                    : 'Use Fingerprint or Face Unlock',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
