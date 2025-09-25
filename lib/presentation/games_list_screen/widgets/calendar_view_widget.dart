import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';

class CalendarViewWidget extends StatefulWidget {
  final List<Map<String, dynamic>> games;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime selectedDate;

  const CalendarViewWidget({
    Key? key,
    required this.games,
    required this.onDateSelected,
    required this.selectedDate,
  }) : super(key: key);

  @override
  State<CalendarViewWidget> createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  late DateTime _currentMonth;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
                Theme.of(context).colorScheme.shadow.withAlpha((255 * 0.1).round()),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          _buildWeekDays(context),
          _buildCalendarGrid(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                Theme.of(context).colorScheme.outline.withAlpha((255 * 0.2).round()),
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month - 1);
              });
            },
            icon: CustomIconWidget(
              iconName: 'chevron_left',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              _getMonthYearString(_currentMonth),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentMonth =
                    DateTime(_currentMonth.year, _currentMonth.month + 1);
              });
            },
            icon: CustomIconWidget(
              iconName: 'chevron_right',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDays(BuildContext context) {
    final weekDays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Row(
        children: weekDays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(BuildContext context) {
    final daysInMonth = _getDaysInMonth(_currentMonth);
    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;

    final totalCells = ((daysInMonth + startingWeekday) / 7).ceil() * 7;

    return Container(
      padding: EdgeInsets.all(2.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          childAspectRatio: 1.0,
          crossAxisSpacing: 1.w,
          mainAxisSpacing: 1.h,
        ),
        itemCount: totalCells,
        itemBuilder: (context, index) {
          final dayNumber = index - startingWeekday + 1;

          if (index < startingWeekday || dayNumber > daysInMonth) {
            return SizedBox.shrink();
          }

          final date =
              DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
          final gamesOnDate = _getGamesForDate(date);
          final isSelected = _isSameDay(date, widget.selectedDate);
          final isToday = _isSameDay(date, DateTime.now());

          return _buildCalendarDay(
            context,
            date,
            dayNumber,
            gamesOnDate,
            isSelected,
            isToday,
          );
        },
      ),
    );
  }

  Widget _buildCalendarDay(
    BuildContext context,
    DateTime date,
    int dayNumber,
    List<Map<String, dynamic>> gamesOnDate,
    bool isSelected,
    bool isToday,
  ) {
    return InkWell(
      onTap: () => widget.onDateSelected(date),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : isToday
                  ? Theme.of(context).colorScheme.primary
                      .withAlpha((255 * 0.1).round())
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isToday && !isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              dayNumber.toString(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : isToday
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                fontWeight:
                    isSelected || isToday ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (gamesOnDate.isNotEmpty) ...[
              SizedBox(height: 0.5.h),
              _buildGameDots(context, gamesOnDate, isSelected),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGameDots(
    BuildContext context,
    List<Map<String, dynamic>> games,
    bool isSelected,
  ) {
    final maxDots = 3;
    final dotsToShow = games.length > maxDots ? maxDots : games.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...List.generate(dotsToShow, (index) {
          final game = games[index];
          final status = game["status"] as String;

          Color dotColor;
          switch (status.toLowerCase()) {
            case 'confirmed':
              dotColor = isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.primary;
              break;
            case 'pending':
              dotColor = isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                      .withAlpha((255 * 0.7).round())
                  : Theme.of(context).colorScheme.tertiary;
              break;
            case 'cancelled':
              dotColor = isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                      .withAlpha((255 * 0.5).round())
                  : Theme.of(context).colorScheme.error;
              break;
            case 'completed':
              dotColor = isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Colors.green;
              break;
            default:
              dotColor = isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                      .withAlpha((255 * 0.5).round())
                  : Theme.of(context).colorScheme.onSurfaceVariant;
          }

          return Container(
            width: 1.w,
            height: 1.w,
            margin: EdgeInsets.symmetric(horizontal: 0.25.w),
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          );
        }),
        if (games.length > maxDots)
          Container(
            width: 1.w,
            height: 1.w,
            margin: EdgeInsets.symmetric(horizontal: 0.25.w),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                      .withAlpha((255 * 0.7).round())
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }

  List<Map<String, dynamic>> _getGamesForDate(DateTime date) {
    return widget.games.where((game) {
      final gameDate = DateTime.parse(game["date"] as String);
      return _isSameDay(gameDate, date);
    }).toList();
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  int _getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  String _getMonthYearString(DateTime date) {
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}
