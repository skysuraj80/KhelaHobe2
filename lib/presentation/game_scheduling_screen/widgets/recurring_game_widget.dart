import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';
import '../../../localization/app_localizations.dart';

class RecurringGameWidget extends StatefulWidget {
  final bool isRecurring;
  final String frequency;
  final int occurrences;
  final ValueChanged<bool> onRecurringChanged;
  final ValueChanged<String> onFrequencyChanged;
  final ValueChanged<int> onOccurrencesChanged;

  const RecurringGameWidget({
    Key? key,
    required this.isRecurring,
    required this.frequency,
    required this.occurrences,
    required this.onRecurringChanged,
    required this.onFrequencyChanged,
    required this.onOccurrencesChanged,
  }) : super(key: key);

  @override
  State<RecurringGameWidget> createState() => _RecurringGameWidgetState();
}

class _RecurringGameWidgetState extends State<RecurringGameWidget> {
  final List<String> frequencies = ["Weekly", "Bi-weekly", "Monthly"];
  final List<int> occurrenceOptions = [2, 4, 6, 8, 12];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.recurringGame,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Switch(
                value: widget.isRecurring,
                onChanged: widget.onRecurringChanged,
                activeColor: Theme.of(context).colorScheme.primary,
              ),
            ],
          ),
          if (widget.isRecurring) ...[
            SizedBox(height: 2.h),
            _buildFrequencySelector(),
            SizedBox(height: 2.h),
            _buildOccurrencesSelector(),
            SizedBox(height: 2.h),
            _buildRecurringSummary(),
          ],
        ],
      ),
    );
  }

  Widget _buildFrequencySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.frequency,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: frequencies.map((frequency) {
            final isSelected = widget.frequency == frequency;
            return GestureDetector(
              onTap: () => widget.onFrequencyChanged(frequency),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: _getFrequencyIcon(frequency),
                      color: isSelected
                          ? Theme.of(context).colorScheme.onPrimary
                          : Theme.of(context).colorScheme.onSurface,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      frequency,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildOccurrencesSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.numberOfGames,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: occurrenceOptions.map((count) {
            final isSelected = widget.occurrences == count;
            return GestureDetector(
              onTap: () => widget.onOccurrencesChanged(count),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.outline
                            .withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  "$count ${AppLocalizations.games}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onSecondary
                        : Theme.of(context).colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecurringSummary() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'event_repeat',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                AppLocalizations.recurringGameSeries,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            "${AppLocalizations.thisWillCreate} ${widget.occurrences} ${AppLocalizations.gamesScheduled} ${widget.frequency.toLowerCase()}. ${AppLocalizations.eachParticipantWillReceive}",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  AppLocalizations.youCanModifyOrCancel,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getFrequencyIcon(String frequency) {
    switch (frequency) {
      case "Weekly":
        return "date_range";
      case "Bi-weekly":
        return "event_repeat";
      case "Monthly":
        return "calendar_month";
      default:
        return "event";
    }
  }
}
