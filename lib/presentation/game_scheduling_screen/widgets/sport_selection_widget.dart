import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';
import '../../../localization/app_localizations.dart';

class SportSelectionWidget extends StatefulWidget {
  final String? selectedSport;
  final ValueChanged<String> onSportSelected;

  const SportSelectionWidget({
    Key? key,
    this.selectedSport,
    required this.onSportSelected,
  }) : super(key: key);

  @override
  State<SportSelectionWidget> createState() => _SportSelectionWidgetState();
}

class _SportSelectionWidgetState extends State<SportSelectionWidget> {
  final List<Map<String, dynamic>> sports = [
    {"name": "Tennis", "icon": "sports_tennis"},
    {"name": "Basketball", "icon": "sports_basketball"},
    {"name": "Football", "icon": "sports_football"},
    {"name": "Soccer", "icon": "sports_soccer"},
    {"name": "Baseball", "icon": "sports_baseball"},
    {"name": "Volleyball", "icon": "sports_volleyball"},
    {"name": "Badminton", "icon": "sports_tennis"},
    {"name": "Table Tennis", "icon": "sports_tennis"},
  ];

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
          Text(
            AppLocalizations.selectSport,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 2.w,
              mainAxisSpacing: 2.w,
              childAspectRatio: 1,
            ),
            itemCount: sports.length,
            itemBuilder: (context, index) {
              final sport = sports[index];
              final isSelected = widget.selectedSport == sport["name"];

              return GestureDetector(
                onTap: () => widget.onSportSelected(sport["name"]),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                            .withValues(alpha: 0.1)
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: sport["icon"],
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface
                                .withValues(alpha: 0.7),
                        size: 20,
                      ),
                      SizedBox(height: 1.w),
                      Text(
                        sport["name"],
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
