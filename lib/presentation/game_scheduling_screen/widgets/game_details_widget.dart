import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../localization/app_localizations.dart';
import '../../../theme/app_theme.dart';

class GameDetailsWidget extends StatefulWidget {
  final double duration;
  final String skillLevel;
  final String notes;
  final ValueChanged<double> onDurationChanged;
  final ValueChanged<String> onSkillLevelChanged;
  final ValueChanged<String> onNotesChanged;

  const GameDetailsWidget({
    Key? key,
    required this.duration,
    required this.skillLevel,
    required this.notes,
    required this.onDurationChanged,
    required this.onSkillLevelChanged,
    required this.onNotesChanged,
  }) : super(key: key);

  @override
  State<GameDetailsWidget> createState() => _GameDetailsWidgetState();
}

class _GameDetailsWidgetState extends State<GameDetailsWidget> {
  final TextEditingController _notesController = TextEditingController();
  final List<String> skillLevels = [
    "Beginner",
    "Intermediate",
    "Advanced",
    "Expert"
  ];

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.notes;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.gameDetails,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildDurationSlider(),
          SizedBox(height: 2.h),
          _buildSkillLevelSelector(),
          SizedBox(height: 2.h),
          _buildNotesField(),
        ],
      ),
    );
  }

  Widget _buildDurationSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.hour,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary
                    .withAlpha(26),
                borderRadius: BorderRadius.circular(1.w),
              ),
              child: Text(
                "${widget.duration.toInt()} ${widget.duration == 1 ? AppLocalizations.hour : AppLocalizations.hours}",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: Theme.of(context).colorScheme.primary,
            thumbColor: Theme.of(context).colorScheme.primary,
            overlayColor:
                Theme.of(context).colorScheme.primary.withAlpha(51),
            inactiveTrackColor:
                Theme.of(context).colorScheme.outline.withAlpha(77),
            trackHeight: 1.w,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 2.w),
          ),
          child: Slider(
            value: widget.duration,
            min: 0.5,
            max: 4.0,
            divisions: 7,
            onChanged: widget.onDurationChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "30 ${AppLocalizations.min}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface
                    .withAlpha(179),
              ),
            ),
            Text(
              "4 ${AppLocalizations.hours}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface
                    .withAlpha(179),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillLevelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.skillLevel,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: skillLevels.map((level) {
            final isSelected = widget.skillLevel == level;
            return GestureDetector(
              onTap: () => widget.onSkillLevelChanged(level),
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
                            .withAlpha(77),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  level,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
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

  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.additionalNotesOptional,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _notesController,
          maxLines: 3,
          maxLength: 200,
          decoration: InputDecoration(
            hintText: AppLocalizations.anySpecialRequirements,
            counterStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface
                  .withAlpha(128),
            ),
          ),
          onChanged: widget.onNotesChanged,
        ),
      ],
    );
  }
}
