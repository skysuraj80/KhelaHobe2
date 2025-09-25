import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../localization/app_localizations.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final ValueChanged<Map<String, dynamic>> onFiltersChanged;

  const FilterBottomSheet({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;

  final List<String> _sportTypes = [
    AppLocalizations.allSports,
    'Football',
    'Basketball',
    'Tennis',
    'Soccer',
    'Baseball',
    'Volleyball',
    'Badminton',
    'Swimming',
    'Running',
    'Cycling',
    'Golf',
  ];

  final List<String> _skillLevels = [
    AppLocalizations.allLevels,
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 1.h),
            width: 12.w,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.filters,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: _resetFilters,
                  child: Text(
                    AppLocalizations.reset,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Distance range
                  _buildSectionTitle(AppLocalizations.distanceRange),
                  SizedBox(height: 2.h),
                  _buildDistanceSlider(),

                  SizedBox(height: 4.h),

                  // Age range
                  _buildSectionTitle(AppLocalizations.ageRange),
                  SizedBox(height: 2.h),
                  _buildAgeRangeSlider(),

                  SizedBox(height: 4.h),

                  // Sport type
                  _buildSectionTitle(AppLocalizations.sportType),
                  SizedBox(height: 2.h),
                  _buildSportTypeGrid(),

                  SizedBox(height: 4.h),

                  // Skill level
                  _buildSectionTitle(AppLocalizations.skillLevel),
                  SizedBox(height: 2.h),
                  _buildSkillLevelGrid(),

                  SizedBox(height: 4.h),

                  // Availability
                  _buildSectionTitle(AppLocalizations.availability),
                  SizedBox(height: 2.h),
                  _buildAvailabilityOptions(),

                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ),

          // Apply button
          Container(
            padding: EdgeInsets.all(4.w),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                child: Text(AppLocalizations.applyFilters),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1 km',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${(_filters['maxDistance'] as double? ?? 50.0).round()} km',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              '100 km',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Slider(
          value: _filters['maxDistance'] as double? ?? 50.0,
          min: 1.0,
          max: 100.0,
          divisions: 99,
          onChanged: (value) {
            setState(() {
              _filters['maxDistance'] = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildAgeRangeSlider() {
    RangeValues ageRange =
        _filters['ageRange'] as RangeValues? ?? RangeValues(18, 45);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '18',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              '${ageRange.start.round()} - ${ageRange.end.round()} years',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              '65',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        RangeSlider(
          values: ageRange,
          min: 18,
          max: 65,
          divisions: 47,
          onChanged: (values) {
            setState(() {
              _filters['ageRange'] = values;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSportTypeGrid() {
    List<String> selectedSports =
        (_filters['sportTypes'] as List?)?.cast<String>() ?? [AppLocalizations.allSports];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _sportTypes.map((sport) {
        bool isSelected = selectedSports.contains(sport);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (sport == AppLocalizations.allSports) {
                _filters['sportTypes'] = [AppLocalizations.allSports];
              } else {
                List<String> currentSports = List<String>.from(selectedSports);
                currentSports.remove(AppLocalizations.allSports);

                if (isSelected) {
                  currentSports.remove(sport);
                  if (currentSports.isEmpty) {
                    currentSports.add(AppLocalizations.allSports);
                  }
                } else {
                  currentSports.add(sport);
                }
                _filters['sportTypes'] = currentSports;
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
            child: Text(
              sport,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSkillLevelGrid() {
    List<String> selectedLevels =
        (_filters['skillLevels'] as List?)?.cast<String>() ?? [AppLocalizations.allLevels];

    return Wrap(
      spacing: 2.w,
      runSpacing: 1.h,
      children: _skillLevels.map((level) {
        bool isSelected = selectedLevels.contains(level);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (level == AppLocalizations.allLevels) {
                _filters['skillLevels'] = [AppLocalizations.allLevels];
              } else {
                List<String> currentLevels = List<String>.from(selectedLevels);
                currentLevels.remove(AppLocalizations.allLevels);

                if (isSelected) {
                  currentLevels.remove(level);
                  if (currentLevels.isEmpty) {
                    currentLevels.add(AppLocalizations.allLevels);
                  }
                } else {
                  currentLevels.add(level);
                }
                _filters['skillLevels'] = currentLevels;
              }
            });
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
            child: Text(
              level,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAvailabilityOptions() {
    bool showOnlyAvailable = _filters['showOnlyAvailable'] as bool? ?? false;

    return Column(
      children: [
        CheckboxListTile(
          title: Text(
            AppLocalizations.showOnlyAvailablePlayers,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          subtitle: Text(
            AppLocalizations.playersCurrentlyAvailable,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          value: showOnlyAvailable,
          onChanged: (value) {
            setState(() {
              _filters['showOnlyAvailable'] = value ?? false;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  void _resetFilters() {
    setState(() {
      _filters = {
        'maxDistance': 50.0,
        'ageRange': RangeValues(18, 45),
        'sportTypes': [AppLocalizations.allSports],
        'skillLevels': [AppLocalizations.allLevels],
        'showOnlyAvailable': false,
      };
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }
}
