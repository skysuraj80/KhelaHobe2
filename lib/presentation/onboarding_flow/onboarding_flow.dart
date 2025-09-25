import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../localization/app_localizations.dart';
import './widgets/location_permission_widget.dart';
import './widgets/navigation_controls_widget.dart';
import './widgets/onboarding_page_widget.dart';
import './widgets/page_indicator_widget.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeController;
  int _currentPage = 0;
  bool _showLocationPermission = false;

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "title": AppLocalizations.onboarding1Title,
      "description": AppLocalizations.onboarding1Description,
    },
    {
      "imageUrl":
          "https://images.pexels.com/photos/346885/pexels-photo-346885.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "title": AppLocalizations.onboarding2Title,
      "description": AppLocalizations.onboarding2Description,
    },
    {
      "imageUrl":
          "https://images.pixabay.com/photo/2016/11/29/06/15/adult-1867743_1280.jpg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
      "title": AppLocalizations.onboarding3Title,
      "description": AppLocalizations.onboarding3Description,
    },
    {
      "imageUrl":
          "https://images.unsplash.com/photo-1544717297-fa95b6ee9643?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      "title": AppLocalizations.onboarding4Title,
      "description": AppLocalizations.onboarding4Description,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showLocationRequest();
    }
  }

  void _skipOnboarding() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  void _showLocationRequest() {
    setState(() {
      _showLocationPermission = true;
    });
  }

  void _handleLocationPermission() {
    // In a real app, this would request actual location permission
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  void _skipLocationPermission() {
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  void _getStarted() {
    _showLocationRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _showLocationPermission
          ? _buildLocationPermissionScreen()
          : _buildOnboardingScreen(),
    );
  }

  Widget _buildOnboardingScreen() {
    return Column(
      children: [
        // Main content area
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              final data = _onboardingData[index];
              return OnboardingPageWidget(
                imageUrl: data["imageUrl"] as String,
                title: data["title"] as String,
                description: data["description"] as String,
                isLastPage: index == _onboardingData.length - 1,
              );
            },
          ),
        ),

        // Page indicator
        Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: PageIndicatorWidget(
            currentPage: _currentPage,
            totalPages: _onboardingData.length,
          ),
        ),

        // Navigation controls
        NavigationControlsWidget(
          isLastPage: _currentPage == _onboardingData.length - 1,
          onNext: _nextPage,
          onSkip: _skipOnboarding,
          onGetStarted: _getStarted,
          showSkip: true,
        ),

        SizedBox(height: 2.h),
      ],
    );
  }

  Widget _buildLocationPermissionScreen() {
    return Column(
      children: [
        // App bar with back button
        SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showLocationPermission = false;
                    });
                  },
                  icon: CustomIconWidget(
                    iconName: 'arrow_back',
                    color: Theme.of(context).colorScheme.onSurface,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.allowLocationAccess,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 12.w), // Balance the back button
              ],
            ),
          ),
        ),

        // Location permission content
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              child: LocationPermissionWidget(
                onAllowLocation: _handleLocationPermission,
                onSkipLocation: _skipLocationPermission,
              ),
            ),
          ),
        ),

        SizedBox(height: 4.h),
      ],
    );
  }
}
