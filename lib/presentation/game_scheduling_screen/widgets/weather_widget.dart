import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../localization/app_localizations.dart';

class WeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final String selectedSport;
  final DateTime? selectedDate;

  const WeatherWidget({
    Key? key,
    required this.weatherData,
    required this.selectedSport,
    this.selectedDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isOutdoorSport = _isOutdoorSport(selectedSport);

    if (!isOutdoorSport) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha((255 * 0.2).round()),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'wb_sunny',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                AppLocalizations.weatherForecast,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildWeatherInfo(context),
          if (_shouldShowAlternatives()) ...[
            SizedBox(height: 2.h),
            _buildIndoorAlternatives(context),
          ],
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(BuildContext context) {
    final condition = weatherData["condition"] ?? "sunny";
    final temperature = weatherData["temperature"] ?? 22;
    final humidity = weatherData["humidity"] ?? 60;
    final windSpeed = weatherData["windSpeed"] ?? 8;
    final precipitation = weatherData["precipitation"] ?? 0;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: _getWeatherColor().withAlpha((255 * 0.1).round()),
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: _getWeatherColor().withAlpha((255 * 0.3).round()),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: _getWeatherIcon(condition),
                color: _getWeatherColor(),
                size: 20,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${temperature}°C",
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _getWeatherColor(),
                      ),
                    ),
                    Text(
                      condition.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _getWeatherColor(),
                      ),
                    ),
                  ],
                ),
              ),
              _buildWeatherRating(context),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWeatherDetail(context, AppLocalizations.humidity, "${humidity}%", 'water_drop'),
              _buildWeatherDetail(context, AppLocalizations.wind, "${windSpeed} km/h", 'air'),
              _buildWeatherDetail(context, AppLocalizations.rain, "${precipitation}%", 'umbrella'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(BuildContext context, String label, String value, String icon) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: icon,
          color:
              Theme.of(context).colorScheme.onSurface.withAlpha((255 * 0.7).round()),
          size: 20,
        ),
        SizedBox(height: 0.5.h),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface
                .withAlpha((255 * 0.7).round()),
          ),
        ),
      ],
    );
  }

  Widget _buildWeatherRating(BuildContext context) {
    final rating = _getWeatherRating();
    final color = rating >= 4
        ? Colors.green
        : rating >= 3
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.2).round()),
        borderRadius: BorderRadius.circular(2.w),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: rating >= 4
                ? 'thumb_up'
                : rating >= 3
                    ? 'thumbs_up_down'
                    : 'thumb_down',
            color: color,
            size: 20,
          ),
          SizedBox(width: 1.w),
          Text(
            rating >= 4
                ? AppLocalizations.great
                : rating >= 3
                    ? AppLocalizations.good
                    : AppLocalizations.poor,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndoorAlternatives(BuildContext context) {
    final indoorVenues = [
      {"name": "Sports Complex Arena", "distance": "1.2 km"},
      {"name": "Community Center", "distance": "2.1 km"},
      {"name": "Indoor Courts Club", "distance": "3.5 km"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.orange.withAlpha((255 * 0.1).round()),
            borderRadius: BorderRadius.circular(2.w),
          ),
          child: Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: Colors.orange,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  AppLocalizations.weatherConditionsNotIdeal,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.orange.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        ...indoorVenues
            .map((venue) => Padding(
                  padding: EdgeInsets.only(bottom: 1.h),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'location_on',
                        color: Theme.of(context).colorScheme.secondary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          venue["name"]!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        venue["distance"]!,
                        style:
                            Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface
                              .withAlpha((255 * 0.7).round()),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  bool _isOutdoorSport(String sport) {
    final outdoorSports = ["Tennis", "Football", "Soccer", "Baseball"];
    return outdoorSports.contains(sport);
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
        return 'umbrella';
      case 'stormy':
        return 'thunderstorm';
      default:
        return 'wb_sunny';
    }
  }

  Color _getWeatherColor() {
    final condition = weatherData["condition"] ?? "sunny";
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Colors.orange;
      case 'cloudy':
        return Colors.grey;
      case 'rainy':
        return Colors.blue;
      case 'stormy':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  int _getWeatherRating() {
    final condition = weatherData["condition"] ?? "sunny";
    final precipitation = weatherData["precipitation"] ?? 0;
    final windSpeed = weatherData["windSpeed"] ?? 8;

    if (condition == "sunny" && precipitation < 10 && windSpeed < 15) return 5;
    if (condition == "cloudy" && precipitation < 20 && windSpeed < 20) return 4;
    if (precipitation < 30 && windSpeed < 25) return 3;
    if (precipitation < 50) return 2;
    return 1;
  }

  bool _shouldShowAlternatives() {
    return _getWeatherRating() < 3;
  }
}
