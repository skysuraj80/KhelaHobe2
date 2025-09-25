import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/discovery_service.dart';
import './widgets/action_buttons_row.dart';
import './widgets/empty_state_widget.dart';

import './widgets/match_celebration_modal.dart';
import './widgets/user_profile_card.dart';

class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen>
    with TickerProviderStateMixin {
  List<UserProfile> _profiles = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  late AnimationController _swipeController;
  late AnimationController _cardController;
  late Animation<Offset> _swipeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadProfiles();
  }

  void _setupAnimations() {
    _swipeController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);

    _cardController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);

    _swipeAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(2.0, 0.0)).animate(
            CurvedAnimation(
                parent: _swipeController, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
        CurvedAnimation(parent: _cardController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _swipeController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _loadProfiles() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (!AuthService.isAuthenticated) {
        // Preview Mode: Show mock profiles
        setState(() {
          _profiles = _getMockProfiles();
          _currentIndex = 0;
          _isLoading = false;
        });
        return;
      }

      final profiles = await DiscoveryService.getDiscoveryProfiles(limit: 20);

      setState(() {
        _profiles = profiles;
        _currentIndex = 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Show mock data on error for preview
        _profiles = _getMockProfiles();
        _currentIndex = 0;
      });
    }
  }

  List<UserProfile> _getMockProfiles() {
    return [
      UserProfile(
          id: '1',
          email: 'sarah@example.com',
          fullName: 'Sarah Johnson',
          bio:
              'Tennis enthusiast and weekend warrior. Always up for a challenge!',
          profileImageUrl:
              'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
          locationName: 'Central Park, NY',
          age: 25,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()),
      UserProfile(
          id: '2',
          email: 'mike@example.com',
          fullName: 'Mike Wilson',
          bio: 'Basketball coach and player. Love teaching the game to others.',
          profileImageUrl:
              'https://images.pexels.com/photos/1516680/pexels-photo-1516680.jpeg',
          locationName: 'Brooklyn, NY',
          age: 32,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()),
      UserProfile(
          id: '3',
          email: 'emma@example.com',
          fullName: 'Emma Davis',
          bio: 'Swimming and cycling enthusiast. Let\'s train together!',
          profileImageUrl:
              'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
          locationName: 'Manhattan, NY',
          age: 27,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now()),
    ];
  }

  UserProfile? get _currentProfile =>
      _currentIndex < _profiles.length ? _profiles[_currentIndex] : null;

  Future<void> _handleSwipeLeft() async {
    if (_currentProfile == null) return;

    await _cardController.forward();

    try {
      if (AuthService.isAuthenticated) {
        await DiscoveryService.swipeLeft(_currentProfile!.id);
      }
    } catch (e) {
      // Handle error silently in preview mode
    }

    await _cardController.reverse();
    _nextProfile();
  }

  Future<void> _handleSwipeRight() async {
    if (_currentProfile == null) return;

    await _cardController.forward();

    try {
      if (AuthService.isAuthenticated) {
        final isMatch = await DiscoveryService.swipeRight(_currentProfile!.id);

        if (isMatch) {
          _showMatchCelebration(_currentProfile!);
        }
      } else {
        // Preview mode - simulate match
        if (_currentIndex % 3 == 0) {
          _showMatchCelebration(_currentProfile!);
        }
      }
    } catch (e) {
      // Handle error silently in preview mode
    }

    await _cardController.reverse();
    _nextProfile();
  }

  void _nextProfile() {
    setState(() {
      _currentIndex++;
    });

    // Load more profiles when running low
    if (_currentIndex >= _profiles.length - 2) {
      _loadProfiles();
    }
  }

  void _showMatchCelebration(UserProfile matchedUser) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => MatchCelebrationModal(
                matchedUser: {
                  'id': matchedUser.id,
                  'fullName': matchedUser.fullName,
                  'profileImageUrl': matchedUser.profileImageUrl,
                  'bio': matchedUser.bio,
                  'age': matchedUser.age,
                  'locationName': matchedUser.locationName,
                },
                onSendMessage: () {
                  Navigator.pop(context);
                },
                onKeepSwiping: () {
                  Navigator.pop(context);
                }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _buildBody());
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_profiles.isEmpty) {
      return EmptyStateWidget(
          onOptimizeProfile: () {}, onRefresh: _loadProfiles);
    }

    return SingleChildScrollView(
      child: Column(children: [
        // Profile Cards Stack
        Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(
                height: 54.h,
                child: Stack(children: [
                  // Next card (if available)
                  if (_currentIndex + 1 < _profiles.length)
                    AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) => Transform.scale(
                            scale: 0.95 + (0.05 * _scaleAnimation.value),
                            child: UserProfileCard(
                                userProfile:
                                    _profiles[_currentIndex + 1].toMap(),
                                onTap: () {}))),

                  // Current card
                  if (_currentProfile != null)
                    AnimatedBuilder(
                        animation: Listenable.merge(
                            [_swipeAnimation, _scaleAnimation]),
                        builder: (context, child) => Transform.translate(
                            offset: _swipeAnimation.value *
                                MediaQuery.of(context).size.width,
                            child: Transform.scale(
                                scale: _scaleAnimation.value,
                                child: UserProfileCard(
                                    userProfile: _currentProfile!.toMap(),
                                    onTap: () {
                                      // Show detailed profile view
                                    })))),
                ]))),

        // Action Buttons
        Padding(
            padding: EdgeInsets.all(24.w),
            child: ActionButtonsRow(
                onAccept: _handleSwipeRight,
                onDecline: _handleSwipeLeft,
                onSuperLike: () {
                  // Implement super like
                  _handleSwipeRight();
                })),

        SizedBox(height: 4.h),
      ]),
    );
  }
}
