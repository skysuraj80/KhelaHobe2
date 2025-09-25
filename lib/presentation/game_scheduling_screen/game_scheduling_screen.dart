import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../localization/app_localizations.dart';
import './widgets/cost_splitting_widget.dart';
import './widgets/date_time_picker_widget.dart';
import './widgets/game_details_widget.dart';
import './widgets/participant_confirmation_widget.dart';
import './widgets/recurring_game_widget.dart';
import './widgets/sport_selection_widget.dart';
import './widgets/venue_selection_widget.dart';
import './widgets/weather_widget.dart';

class GameSchedulingScreen extends StatefulWidget {
  const GameSchedulingScreen({Key? key}) : super(key: key);

  @override
  State<GameSchedulingScreen> createState() => _GameSchedulingScreenState();
}

class _GameSchedulingScreenState extends State<GameSchedulingScreen> {
  // Form state variables
  String? selectedSport;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Map<String, dynamic>? selectedVenue;
  double gameDuration = 1.0;
  String skillLevel = "Intermediate";
  String gameNotes = "";
  bool isRecurring = false;
  String recurringFrequency = "Weekly";
  int recurringOccurrences = 4;
  double venueCost = 0.0;
  String costSplitMethod = "Equal Split";
  bool isDraftSaved = false;

  // Mock data
  final Map<String, dynamic> currentUser = {
    "id": 1,
    "name": "Alex Johnson",
    "avatar":
        "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
    "skillLevel": "Intermediate",
  };

  final Map<String, dynamic> matchedUser = {
    "id": 2,
    "name": "Sarah Chen",
    "avatar":
        "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
    "skillLevel": "Advanced",
  };

  final List<Map<String, dynamic>> nearbyVenues = [
    {
      "id": 1,
      "name": "Central Sports Complex",
      "address": "123 Sports Ave, Downtown",
      "image":
          "https://images.pexels.com/photos/1263348/pexels-photo-1263348.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.5,
      "distance": 1.2,
      "amenities": ["Parking", "Lockers", "Cafe"],
    },
    {
      "id": 2,
      "name": "Riverside Tennis Club",
      "address": "456 River Rd, Westside",
      "image":
          "https://images.pexels.com/photos/209977/pexels-photo-209977.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.8,
      "distance": 2.1,
      "amenities": ["Pro Shop", "Showers", "Restaurant"],
    },
    {
      "id": 3,
      "name": "Community Recreation Center",
      "address": "789 Main St, Eastside",
      "image":
          "https://images.pexels.com/photos/1552252/pexels-photo-1552252.jpeg?auto=compress&cs=tinysrgb&w=400",
      "rating": 4.2,
      "distance": 0.8,
      "amenities": ["Free Parking", "Equipment Rental"],
    },
  ];

  final List<Map<String, dynamic>> availableSlots = [
    {"time": "9:00 AM", "available": true},
    {"time": "11:00 AM", "available": true},
    {"time": "2:00 PM", "available": true},
    {"time": "4:00 PM", "available": true},
    {"time": "6:00 PM", "available": true},
  ];

  final Map<String, dynamic> weatherData = {
    "condition": "sunny",
    "temperature": 24,
    "humidity": 60,
    "windSpeed": 12,
    "precipitation": 5,
  };

  @override
  void initState() {
    super.initState();
    _loadDraftIfExists();
  }

  void _loadDraftIfExists() {
    // Simulate loading saved draft
    setState(() {
      selectedSport = "Tennis";
      isDraftSaved = true;
    });
  }

  void _saveDraft() {
    setState(() {
      isDraftSaved = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.draftSavedSuccessfully),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
    );
  }

  void _sendInvitation() {
    if (_validateForm()) {
      _showConfirmationDialog();
    }
  }

  bool _validateForm() {
    if (selectedSport == null) {
      _showErrorMessage(AppLocalizations.pleaseSelectASport);
      return false;
    }
    if (selectedDate == null) {
      _showErrorMessage(AppLocalizations.pleaseSelectADate);
      return false;
    }
    if (selectedTime == null) {
      _showErrorMessage(AppLocalizations.pleaseSelectATime);
      return false;
    }
    if (selectedVenue == null) {
      _showErrorMessage(AppLocalizations.pleaseSelectAVenue);
      return false;
    }
    return true;
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.confirmGameInvitation,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildConfirmationRow(AppLocalizations.sport, selectedSport ?? ""),
              _buildConfirmationRow(
                  AppLocalizations.date,
                  selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : ""),
              _buildConfirmationRow(
                  AppLocalizations.time, selectedTime?.format(context) ?? ""),
              _buildConfirmationRow(AppLocalizations.hour,
                  "${gameDuration.toInt()} ${gameDuration == 1 ? AppLocalizations.hour : AppLocalizations.hours}"),
              _buildConfirmationRow(AppLocalizations.venue, selectedVenue?["name"] ?? ""),
              if (venueCost > 0)
                _buildConfirmationRow(AppLocalizations.cost,
                    "\${venueCost.toStringAsFixed(2)} ($costSplitMethod)"),
              if (isRecurring)
                _buildConfirmationRow(AppLocalizations.recurring,
                    "$recurringFrequency ${AppLocalizations.forText} $recurringOccurrences ${AppLocalizations.games}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.cancelText),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processInvitation();
              },
              child: Text(AppLocalizations.sendInvitation),
            ),
          ],
        );
      },
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              "$label:",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  void _processInvitation() {
    // Simulate sending invitation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(height: 2.h),
              Text(
                AppLocalizations.sendingInvitation,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );

    // Simulate processing delay
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      _showSuccessDialog();
    });
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary
                      .withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'check',
                  color: Theme.of(context).colorScheme.secondary,
                  size: 20,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                AppLocalizations.invitationSent,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                "${matchedUser["name"]} ${AppLocalizations.willReceiveNotification}",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/games-list-screen');
              },
              child: Text(AppLocalizations.viewGames),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.scheduleGame),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).colorScheme.onSurface,
            size: 20,
          ),
        ),
        actions: [
          if (!isDraftSaved)
            TextButton(
              onPressed: _saveDraft,
              child: Text(
                AppLocalizations.saveDraft,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDraftSaved)
              Container(
                padding: EdgeInsets.all(3.w),
                margin: EdgeInsets.only(bottom: 2.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary
                      .withAlpha(26),
                  borderRadius: BorderRadius.circular(2.w),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary
                        .withAlpha(77),
                  ),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'save',
                      color: Theme.of(context).colorScheme.secondary,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      AppLocalizations.draftSavedContinue,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            SportSelectionWidget(
              selectedSport: selectedSport,
              onSportSelected: (sport) {
                setState(() {
                  selectedSport = sport;
                });
              },
            ),
            SizedBox(height: 2.h),
            ParticipantConfirmationWidget(
              currentUser: currentUser,
              matchedUser: matchedUser,
            ),
            SizedBox(height: 2.h),
            DateTimePickerWidget(
              selectedDate: selectedDate,
              selectedTime: selectedTime,
              availableSlots: availableSlots,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
              },
              onTimeSelected: (time) {
                setState(() {
                  selectedTime = time;
                });
              },
            ),
            SizedBox(height: 2.h),
            VenueSelectionWidget(
              selectedVenue: selectedVenue,
              nearbyVenues: nearbyVenues,
              onVenueSelected: (venue) {
                setState(() {
                  selectedVenue = venue;
                });
              },
            ),
            SizedBox(height: 2.h),
            GameDetailsWidget(
              duration: gameDuration,
              skillLevel: skillLevel,
              notes: gameNotes,
              onDurationChanged: (duration) {
                setState(() {
                  gameDuration = duration;
                });
              },
              onSkillLevelChanged: (level) {
                setState(() {
                  skillLevel = level;
                });
              },
              onNotesChanged: (notes) {
                setState(() {
                  gameNotes = notes;
                });
              },
            ),
            SizedBox(height: 2.h),
            WeatherWidget(
              weatherData: weatherData,
              selectedSport: selectedSport ?? "",
              selectedDate: selectedDate,
            ),
            SizedBox(height: 2.h),
            RecurringGameWidget(
              isRecurring: isRecurring,
              frequency: recurringFrequency,
              occurrences: recurringOccurrences,
              onRecurringChanged: (recurring) {
                setState(() {
                  isRecurring = recurring;
                });
              },
              onFrequencyChanged: (frequency) {
                setState(() {
                  recurringFrequency = frequency;
                });
              },
              onOccurrencesChanged: (occurrences) {
                setState(() {
                  recurringOccurrences = occurrences;
                });
              },
            ),
            SizedBox(height: 2.h),
            CostSplittingWidget(
              venueCost: venueCost,
              splitMethod: costSplitMethod,
              onCostChanged: (cost) {
                setState(() {
                  venueCost = cost;
                });
              },
              onSplitMethodChanged: (method) {
                setState(() {
                  costSplitMethod = method;
                });
              },
            ),
            SizedBox(height: 4.h),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(26),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: ElevatedButton(
            onPressed: _sendInvitation,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 4.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'send',
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(
                  AppLocalizations.sendInvitation,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}