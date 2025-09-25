import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class TypingIndicatorWidget extends StatefulWidget {
  final String userName;

  const TypingIndicatorWidget({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  State<TypingIndicatorWidget> createState() => _TypingIndicatorWidgetState();
}

class _TypingIndicatorWidgetState extends State<TypingIndicatorWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 4.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 2.5.w,
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: CustomIconWidget(
              iconName: 'person',
              color: Theme.of(context).colorScheme.onSecondary,
              size: 20,
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4.w),
                topRight: Radius.circular(4.w),
                bottomRight: Radius.circular(4.w),
                bottomLeft: Radius.circular(1.w),
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline
                    .withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.userName} ${AppLocalizations.isTyping}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(height: 1.h),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(3, (index) {
                        final delay = index * 0.2;
                        final animationValue =
                            (_animation.value - delay).clamp(0.0, 1.0);
                        final opacity = (sin(animationValue * pi) * 0.7 + 0.3)
                            .clamp(0.3, 1.0);

                        return Container(
                          margin: EdgeInsets.only(right: index < 2 ? 1.w : 0),
                          child: Opacity(
                            opacity: opacity,
                            child: Container(
                              width: 1.5.w,
                              height: 1.5.w,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
