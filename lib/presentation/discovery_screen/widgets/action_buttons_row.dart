import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsRow extends StatelessWidget {
  final VoidCallback onDecline;
  final VoidCallback onSuperLike;
  final VoidCallback onAccept;

  const ActionButtonsRow({
    Key? key,
    required this.onDecline,
    required this.onSuperLike,
    required this.onAccept,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Decline button
          Expanded(
            child: _ActionButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onDecline();
              },
              backgroundColor: Colors.white,
              borderColor: AppTheme.errorLight,
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.errorLight,
                size: 28,
              ),
              size: 24,
            ),
          ),

          // Super like button
          Expanded(
            child: _ActionButton(
              onPressed: () {
                HapticFeedback.mediumImpact();
                onSuperLike();
              },
              backgroundColor: Colors.white,
              borderColor: Theme.of(context).colorScheme.tertiary,
              child: CustomIconWidget(
                iconName: 'star',
                color: Theme.of(context).colorScheme.tertiary,
                size: 24,
              ),
              size: 24,
            ),
          ),

          // Accept button
          Expanded(
            child: _ActionButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                onAccept();
              },
              backgroundColor: Colors.white,
              borderColor: AppTheme.successLight,
              child: CustomIconWidget(
                iconName: 'favorite',
                color: AppTheme.successLight,
                size: 28,
              ),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color borderColor;
  final Widget child;
  final double size;

  const _ActionButton({
    Key? key,
    required this.onPressed,
    required this.backgroundColor,
    required this.borderColor,
    required this.child,
    required this.size,
  }) : super(key: key);

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.backgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.borderColor,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.borderColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(child: widget.child),
            ),
          );
        },
      ),
    );
  }
}
