import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';
import '../../../theme/app_theme.dart';
import '../../../localization/app_localizations.dart';

class VenueSelectionWidget extends StatefulWidget {
  final Map<String, dynamic>? selectedVenue;
  final ValueChanged<Map<String, dynamic>> onVenueSelected;
  final List<Map<String, dynamic>> nearbyVenues;

  const VenueSelectionWidget({
    Key? key,
    this.selectedVenue,
    required this.onVenueSelected,
    required this.nearbyVenues,
  }) : super(key: key);

  @override
  State<VenueSelectionWidget> createState() => _VenueSelectionWidgetState();
}

class _VenueSelectionWidgetState extends State<VenueSelectionWidget> {
  bool _showCustomLocation = false;
  final TextEditingController _customLocationController =
      TextEditingController();

  @override
  void dispose() {
    _customLocationController.dispose();
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
                AppLocalizations.venue,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showCustomLocation = !_showCustomLocation;
                  });
                },
                icon: CustomIconWidget(
                  iconName:
                      _showCustomLocation ? 'location_on' : 'add_location',
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
                label: Text(
                  _showCustomLocation ? AppLocalizations.nearby : AppLocalizations.custom,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _showCustomLocation
              ? _buildCustomLocationInput()
              : _buildNearbyVenues(),
        ],
      ),
    );
  }

  Widget _buildNearbyVenues() {
    return Column(
      children: [
        Container(
          height: 4.h,
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: Theme.of(context).colorScheme.outline
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'map',
                      color: Theme.of(context).colorScheme.onSurface
                          .withValues(alpha: 0.5),
                      size: 20,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      AppLocalizations.mapView,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 2.w,
                right: 2.w,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(1.w),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CustomIconWidget(
                    iconName: 'my_location',
                    color: Theme.of(context).colorScheme.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.nearbyVenues.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final venue = widget.nearbyVenues[index];
            final isSelected = widget.selectedVenue?["id"] == venue["id"];

            return GestureDetector(
              onTap: () => widget.onVenueSelected(venue),
              child: Container(
                padding: EdgeInsets.all(3.w),
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
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.w),
                      child: CustomImageWidget(
                        imageUrl: venue["image"] ?? "",
                        width: 15.w,
                        height: 15.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            venue["name"] ?? "",
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 0.5.h),
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'star',
                                color: Colors.amber,
                                size: 20,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                "${venue["rating"] ?? 0.0}",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SizedBox(width: 2.w),
                              CustomIconWidget(
                                iconName: 'location_on',
                                color: Theme.of(context).colorScheme.onSurface
                                    .withValues(alpha: 0.5),
                                size: 20,
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                "${venue["distance"] ?? 0.0} ${AppLocalizations.km}",
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            venue["address"] ?? "",
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (venue["amenities"] != null) ...[
                      SizedBox(width: 2.w),
                      Column(
                        children: (venue["amenities"] as List)
                            .take(3)
                            .map<Widget>((amenity) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 0.5.h),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 1.5.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.secondary
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(1.w),
                              ),
                              child: Text(
                                amenity,
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                  fontSize: 8.sp,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCustomLocationInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.enterCustomLocation,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _customLocationController,
          decoration: InputDecoration(
            hintText: AppLocalizations.enterAddressOrVenueName,
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'location_on',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
            suffixIcon: _customLocationController.text.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      final customVenue = {
                        "id": "custom",
                        "name": _customLocationController.text,
                        "address": _customLocationController.text,
                        "type": "custom",
                      };
                      widget.onVenueSelected(customVenue);
                    },
                    icon: CustomIconWidget(
                      iconName: 'check',
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {});
          },
        ),
        SizedBox(height: 2.h),
        Container(
          padding: EdgeInsets.all(3.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(2.w),
            border: Border.all(
              color: Theme.of(context).colorScheme.secondary
                  .withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: Theme.of(context).colorScheme.secondary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  AppLocalizations.customLocationsPrivate,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
