import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';
import '../../../localization/app_localizations.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>> onFiltersChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _sports = [
    AppLocalizations.allSports,
    'Tennis',
    'Basketball',
    'Soccer',
    'Badminton',
    'Volleyball',
    'Table Tennis',
    'Cricket',
    'Baseball',
  ];

  final List<String> _statuses = [
    AppLocalizations.allStatus,
    AppLocalizations.confirmed,
    AppLocalizations.pending,
    AppLocalizations.cancelled,
    AppLocalizations.completed,
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(context),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSportFilter(context),
                  SizedBox(height: 3.h),
                  _buildStatusFilter(context),
                  SizedBox(height: 3.h),
                  _buildDateRangeFilter(context),
                  SizedBox(height: 4.h),
                  _buildActionButtons(context),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
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
          Text(
            AppLocalizations.filterGames,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: CustomIconWidget(
              iconName: 'close',
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSportFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.sportType,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _sports.map((sport) {
            final isSelected = _filters['sport'] == sport ||
                (_filters['sport'] == null && sport == AppLocalizations.allSports);
            return FilterChip(
              label: Text(sport),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filters['sport'] = sport == AppLocalizations.allSports ? null : sport;
                });
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary
                  .withAlpha((255 * 0.1).round()),
              checkmarkColor: Theme.of(context).colorScheme.primary,
              labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline
                        .withAlpha((255 * 0.3).round()),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.gameStatus,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _statuses.map((status) {
            final isSelected = _filters['status'] == status ||
                (_filters['status'] == null && status == AppLocalizations.allStatus);
            return FilterChip(
              label: Text(status),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filters['status'] = status == AppLocalizations.allStatus ? null : status;
                });
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              selectedColor: Theme.of(context).colorScheme.primary
                  .withAlpha((255 * 0.1).round()),
              checkmarkColor: Theme.of(context).colorScheme.primary,
              labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline
                        .withAlpha((255 * 0.3).round()),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.dateRange,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                context,
                AppLocalizations.from,
                _filters['startDate'] as DateTime?,
                (date) => setState(() => _filters['startDate'] = date),
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: _buildDateField(
                context,
                AppLocalizations.to,
                _filters['endDate'] as DateTime?,
                (date) => setState(() => _filters['endDate'] = date),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? selectedDate,
    ValueChanged<DateTime?> onDateSelected,
  ) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime.now().subtract(Duration(days: 365)),
          lastDate: DateTime.now().add(Duration(days: 365)),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme,
              ),
              child: child!,
            );
          },
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                Theme.of(context).colorScheme.outline.withAlpha((255 * 0.3).round()),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 0.5.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate.month}/${selectedDate.day}/${selectedDate.year}'
                        : AppLocalizations.selectDate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selectedDate != null
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _filters = {
                  'sport': null,
                  'status': null,
                  'startDate': null,
                  'endDate': null,
                };
              });
            },
            child: Text(AppLocalizations.clearAll),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              widget.onFiltersChanged(_filters);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.applyFilters),
          ),
        ),
      ],
    );
  }
}
