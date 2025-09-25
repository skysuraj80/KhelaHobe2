import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class GameCardWidget extends StatelessWidget {
  final Map<String, dynamic> game;
  final VoidCallback? onTap;
  final VoidCallback? onMessage;
  final VoidCallback? onCancel;
  final VoidCallback? onReschedule;
  final VoidCallback? onComplete;
  final VoidCallback? onRate;
  final bool isUpcoming;

  const GameCardWidget({
    Key? key,
    required this.game,
    this.onTap,
    this.onMessage,
    this.onCancel,
    this.onReschedule,
    this.onComplete,
    this.onRate,
    this.isUpcoming = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime gameDate = DateTime.parse(game["date"] as String);
    final String status = game["status"] as String;
    final bool isOutdoor =
        (game["venue"] as Map<String, dynamic>)["isOutdoor"] as bool;

    return Dismissible(
      key: Key(game["id"].toString()),
      background: _buildSwipeBackground(context, isLeft: true),
      secondaryBackground: _buildSwipeBackground(context, isLeft: false),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onMessage?.call();
        } else {
          if (isUpcoming) {
            onCancel?.call();
          } else {
            onRate?.call();
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  Theme.of(context).colorScheme.shadow.withAlpha(26),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, gameDate, status),
                  SizedBox(height: 2.h),
                  _buildGameInfo(context),
                  if (isUpcoming && isOutdoor) ...[
                    SizedBox(height: 2.h),
                    _buildWeatherInfo(context),
                  ],
                  if (isUpcoming) ...[
                    SizedBox(height: 2.h),
                    _buildCountdownTimer(context, gameDate),
                  ],
                  if (!isUpcoming && status == "completed") ...[
                    SizedBox(height: 2.h),
                    _buildGameStats(context),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground(BuildContext context, {required bool isLeft}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: isLeft
            ? Theme.of(context).colorScheme.primary.withAlpha(26)
            : (isUpcoming
                ? Theme.of(context).colorScheme.error.withAlpha(26)
                : Theme.of(context).colorScheme.tertiary
                    .withAlpha(26)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomIconWidget(
                iconName: isLeft ? 'message' : (isUpcoming ? 'cancel' : 'star'),
                color: isLeft
                    ? Theme.of(context).colorScheme.primary
                    : (isUpcoming
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.tertiary),
                size: 24,
              ),
              SizedBox(height: 0.5.h),
              Text(
                isLeft ? AppLocalizations.message : (isUpcoming ? AppLocalizations.cancel : AppLocalizations.rate),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isLeft
                      ? Theme.of(context).colorScheme.primary
                      : (isUpcoming
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.tertiary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DateTime gameDate, String status) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: _getSportIcon(game["sport"] as String),
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                game["sport"] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                "${_formatDate(gameDate)} at ${_formatTime(gameDate)}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _buildStatusBadge(context, status),
      ],
    );
  }

  Widget _buildGameInfo(BuildContext context) {
    final opponent = game["opponent"] as Map<String, dynamic>;
    final venue = game["venue"] as Map<String, dynamic>;

    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CustomImageWidget(
            imageUrl: opponent["avatar"] as String,
            width: 10.w,
            height: 10.w,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "vs ${opponent["name"] as String}",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'location_on',
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Expanded(
                    child: Text(
                      venue["name"] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (opponent["rating"] != null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary
                  .withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'star',
                  color: Theme.of(context).colorScheme.tertiary,
                  size: 14,
                ),
                SizedBox(width: 1.w),
                Text(
                  opponent["rating"].toString(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildWeatherInfo(BuildContext context) {
    final weather = game["weather"] as Map<String, dynamic>?;
    if (weather == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(51),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: _getWeatherIcon(weather["condition"] as String),
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            "${weather["temperature"]}°F",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              weather["condition"] as String,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (weather["precipitation"] != null &&
              (weather["precipitation"] as int) > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomIconWidget(
                  iconName: 'water_drop',
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  "${weather["precipitation"]}%",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildCountdownTimer(BuildContext context, DateTime gameDate) {
    final now = DateTime.now();
    final difference = gameDate.difference(now);

    if (difference.isNegative) {
      return SizedBox.shrink();
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'schedule',
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Text(
            AppLocalizations.startsIn,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            days > 0
                ? "${days}d ${hours}h ${minutes}m"
                : hours > 0
                    ? "${hours}h ${minutes}m"
                    : "${minutes}m",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameStats(BuildContext context) {
    final stats = game["stats"] as Map<String, dynamic>?;
    if (stats == null) return SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(51),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(context, AppLocalizations.score,
              "${stats["userScore"]}-${stats["opponentScore"]}"),
          _buildStatItem(context, AppLocalizations.hour, "${stats["duration"]}min"),
          _buildStatItem(context, AppLocalizations.result, stats["result"] as String),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, String status) {
    Color backgroundColor;
    Color textColor;
    String displayText;

    switch (status.toLowerCase()) {
      case 'confirmed':
        backgroundColor =
            Theme.of(context).colorScheme.primary.withAlpha(26);
        textColor = Theme.of(context).colorScheme.primary;
        displayText = AppLocalizations.confirmed;
        break;
      case 'pending':
        backgroundColor =
            Theme.of(context).colorScheme.tertiary.withAlpha(26);
        textColor = Theme.of(context).colorScheme.tertiary;
        displayText = AppLocalizations.pending;
        break;
      case 'cancelled':
        backgroundColor =
            Theme.of(context).colorScheme.error.withAlpha(26);
        textColor = Theme.of(context).colorScheme.error;
        displayText = AppLocalizations.cancelled;
        break;
      case 'completed':
        backgroundColor = Colors.green.withAlpha(26);
        textColor = Colors.green;
        displayText = AppLocalizations.completed;
        break;
      default:
        backgroundColor =
            Theme.of(context).colorScheme.outline.withAlpha(26);
        textColor = Theme.of(context).colorScheme.onSurfaceVariant;
        displayText = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        displayText,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getSportIcon(String sport) {
    switch (sport.toLowerCase()) {
      case 'tennis':
        return 'sports_tennis';
      case 'basketball':
        return 'sports_basketball';
      case 'soccer':
        return 'sports_soccer';
      case 'badminton':
        return 'sports_tennis';
      case 'volleyball':
        return 'sports_volleyball';
      case 'table tennis':
        return 'sports_tennis';
      case 'cricket':
        return 'sports_cricket';
      case 'baseball':
        return 'sports_baseball';
      default:
        return 'sports';
    }
  }

  String _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return 'wb_sunny';
      case 'cloudy':
      case 'overcast':
        return 'cloud';
      case 'rainy':
      case 'rain':
        return 'water_drop';
      case 'stormy':
        return 'thunderstorm';
      case 'snowy':
        return 'ac_unit';
      default:
        return 'wb_cloudy';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(Duration(days: 1));
    final gameDay = DateTime(date.year, date.month, date.day);

    if (gameDay == today) {
      return AppLocalizations.today;
    } else if (gameDay == tomorrow) {
      return AppLocalizations.tomorrow;
    } else {
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '${displayHour}:${minute.toString().padLeft(2, '0')} $period';
  }
}
