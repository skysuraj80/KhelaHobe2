import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../localization/app_localizations.dart';
import '../../models/game.dart';
import '../../services/auth_service.dart';
import '../../services/game_service.dart';
import './widgets/calendar_view_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/game_card_widget.dart';

class GamesListScreen extends StatefulWidget {
  const GamesListScreen({super.key});

  @override
  State<GamesListScreen> createState() => _GamesListScreenState();
}

class _GamesListScreenState extends State<GamesListScreen>
    with TickerProviderStateMixin {
  List<Game> _games = [];
  bool _isLoading = true;
  String _selectedSport = 'all';
  String _viewMode = 'list'; // 'list' or 'calendar'
  DateTime _selectedDate = DateTime.now();

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadGames();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadGames() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (!AuthService.isAuthenticated) {
        // Preview Mode: Show mock games
        setState(() {
          _games = _getMockGames();
          _isLoading = false;
        });
        return;
      }

      final games = await GameService.getAllGames(
          sportType: _selectedSport,
          date: _viewMode == 'calendar' ? _selectedDate : null,
          limit: 50);

      setState(() {
        _games = games;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Show mock data on error for preview
        _games = _getMockGames();
      });
    }
  }

  List<Game> _getMockGames() {
    final now = DateTime.now();
    return [
      Game(
          id: '1',
          hostId: 'user1',
          sportType: 'football',
          title: 'Sunday Morning Football',
          description:
              'Casual game in Central Park. Bring water and good vibes!',
          locationName: 'Central Park Great Lawn',
          locationLat: 40.7829,
          locationLng: -73.9654,
          scheduledDate: now.add(const Duration(days: 2)),
          scheduledTime: '10:00',
          maxPlayers: 10,
          costPerPlayer: 5.0,
          currentPlayers: 6,
          createdAt: now,
          updatedAt: now),
      Game(
          id: '2',
          hostId: 'user2',
          sportType: 'tennis',
          title: 'Evening Tennis Match',
          description: 'Looking for doubles partner. All levels welcome!',
          locationName: 'Bryant Park Tennis',
          locationLat: 40.7536,
          locationLng: -73.9832,
          scheduledDate: now.add(const Duration(days: 1)),
          scheduledTime: '18:30',
          maxPlayers: 4,
          costPerPlayer: 15.0,
          currentPlayers: 2,
          createdAt: now,
          updatedAt: now),
      Game(
          id: '3',
          hostId: 'user3',
          sportType: 'basketball',
          title: 'Pickup Basketball',
          description: 'Quick 3v3 games. Competitive but friendly.',
          locationName: 'Brooklyn Bridge Park',
          locationLat: 40.7024,
          locationLng: -73.9875,
          scheduledDate: now.add(const Duration(days: 3)),
          scheduledTime: '16:00',
          maxPlayers: 6,
          costPerPlayer: 0.0,
          currentPlayers: 4,
          createdAt: now,
          updatedAt: now),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: TabBarView(controller: _tabController, children: [
          _buildListView(),
          _buildCalendarView(),
        ]),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (AuthService.isAuthenticated) {
                Navigator.pushNamed(context, AppRoutes.gameScheduling);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text(AppLocalizations.somethingWentWrong),
                    action: SnackBarAction(
                        label: AppLocalizations.signIn,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        })));
              }
            },
            label: const Text('Create Game'),
            icon: const Icon(Icons.add),
            backgroundColor: Theme.of(context).colorScheme.primary));
  }

  Widget _buildListView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_games.isEmpty) {
      return EmptyStateWidget(isUpcoming: true);
    }

    return RefreshIndicator(
        onRefresh: _loadGames,
        child: ListView.builder(
            padding: EdgeInsets.all(16.w),
            itemCount: _games.length,
            itemBuilder: (context, index) {
              final game = _games[index];
              return Padding(
                  padding: EdgeInsets.only(bottom: 4.h),
                  child: GameCardWidget(
                      game: game.toMap(),
                      onTap: () {
                        // Navigate to game details
                        // Navigator.pushNamed(context, AppRoutes.gameDetails, arguments: game.id);
                      }));
            }));
  }

  Widget _buildCalendarView() {
    return CalendarViewWidget(
        games: _games.map((game) => game.toMap()).toList(),
        selectedDate: _selectedDate,
        onDateSelected: (date) {
          setState(() {
            _selectedDate = date;
          });
          _loadGames();
        });
  }
}