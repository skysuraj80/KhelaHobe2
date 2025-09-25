import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class MatchCelebrationModal extends StatefulWidget {
  final Map<String, dynamic> matchedUser;
  final VoidCallback onSendMessage;
  final VoidCallback onKeepSwiping;

  const MatchCelebrationModal({
    Key? key,
    required this.matchedUser,
    required this.onSendMessage,
    required this.onKeepSwiping,
  }) : super(key: key);

  @override
  State<MatchCelebrationModal> createState() => _MatchCelebrationModalState();
}

class _MatchCelebrationModalState extends State<MatchCelebrationModal>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _confettiAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    _confettiAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confettiController,
      curve: Curves.easeOut,
    ));

    _scaleController.forward();
    _confettiController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withAlpha((255 * 0.8).round()),
      child: Stack(
        children: [
          // Confetti effect
          AnimatedBuilder(
            animation: _confettiAnimation,
            builder: (context, child) {
              return CustomPaint(
                painter: ConfettiPainter(_confettiAnimation.value),
                size: Size(100.w, 14.h),
              );
            },
          ),

          // Main content
          Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: 85.w,
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha((255 * 0.3).round()),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 4.h),

                        // "It's a Match!" text
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.w, vertical: 1.h),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.tertiary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            AppLocalizations.itsAMatch,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // User profile images
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildProfileImage(
                                'https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png'), // Current user placeholder
                            SizedBox(width: 4.w),
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: AppTheme.successLight,
                                shape: BoxShape.circle,
                              ),
                              child: CustomIconWidget(
                                iconName: 'favorite',
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            _buildProfileImage(
                                widget.matchedUser['profileImage'] as String? ??
                                    ''),
                          ],
                        ),

                        SizedBox(height: 3.h),

                        // Matched user info
                        Text(
                          '${AppLocalizations.youAnd} ${widget.matchedUser['name'] ?? AppLocalizations.unknown} ${AppLocalizations.likedEachOther}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(height: 1.h),

                        // Sports in common
                        widget.matchedUser['sportsInterests'] != null
                            ? Container(
                                padding: EdgeInsets.symmetric(horizontal: 4.w),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 2.w,
                                  children:
                                      ((widget.matchedUser['sportsInterests']
                                                  as List)
                                              .take(3))
                                          .map((sport) {
                                    final sportMap =
                                        sport as Map<String, dynamic>;
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.w, vertical: 0.5.h),
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary
                                            .withAlpha((255 * 0.1).round()),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary
                                              .withAlpha((255 * 0.3).round()),
                                        ),
                                      ),
                                      child: Text(
                                        sportMap['name'] ?? '',
                                        style: AppTheme
                                            .lightTheme.textTheme.bodySmall
                                            ?.copyWith(
                                          color: AppTheme
                                              .lightTheme.colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              )
                            : SizedBox.shrink(),

                        SizedBox(height: 4.h),

                        // Action buttons
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: widget.onKeepSwiping,
                                  child: Text(AppLocalizations.keepSwiping),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: widget.onSendMessage,
                                  child: Text(AppLocalizations.sendMessage),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(String imageUrl) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.primary.withAlpha((255 * 0.3).round()),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: CustomImageWidget(
          imageUrl: imageUrl,
          width: 20.w,
          height: 20.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double animationValue;

  ConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final colors = [
      AppTheme.successLight,
      AppTheme.errorLight,
      Colors.purple,
      Colors.orange,
      Colors.blue,
      Colors.green,
    ];

    for (int i = 0; i < 50; i++) {
      paint.color = colors[i % colors.length];

      final x =
          (size.width * (i % 10) / 10) + (animationValue * 100 * (i % 3 - 1));
      final y = size.height * animationValue * (1 + i % 3 * 0.5);

      if (y < size.height) {
        canvas.drawCircle(
          Offset(x, y),
          3 + (i % 3),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
