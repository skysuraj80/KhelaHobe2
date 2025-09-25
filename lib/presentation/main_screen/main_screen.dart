import 'package:flutter/material.dart';
import 'package:sportmatch/presentation/discovery_screen/discovery_screen.dart';
import 'package:sportmatch/presentation/games_list_screen/games_list_screen.dart';
import 'package:sportmatch/presentation/chat_screen/chat_screen.dart';
import 'package:sportmatch/presentation/user_profile_screen/user_profile_screen.dart';
import 'package:sportmatch/widgets/bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    DiscoveryScreen(),
    GamesListScreen(),
    ChatScreen(),
    UserProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
