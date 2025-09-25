import 'package:flutter/material.dart';
import '../presentation/games_list_screen/games_list_screen.dart';
import '../presentation/chat_screen/chat_screen.dart';
import '../presentation/discovery_screen/discovery_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/onboarding_flow/onboarding_flow.dart';
import '../presentation/game_scheduling_screen/game_scheduling_screen.dart';
import '../presentation/user_profile_screen/user_profile_screen.dart';
import '../presentation/main_screen/main_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String gamesList = '/games-list-screen';
  static const String chat = '/chat-screen';
  static const String discovery = '/discovery-screen';
  static const String login = '/login-screen';
  static const String onboardingFlow = '/onboarding-flow';
  static const String gameScheduling = '/game-scheduling-screen';
  static const String userProfile = '/user-profile-screen';
  static const String mainScreen = '/main-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    gamesList: (context) => const GamesListScreen(),
    chat: (context) => const ChatScreen(),
    discovery: (context) => const DiscoveryScreen(),
    login: (context) => const LoginScreen(),
    onboardingFlow: (context) => const OnboardingFlow(),
    gameScheduling: (context) => const GameSchedulingScreen(),
    userProfile: (context) => const UserProfileScreen(),
    mainScreen: (context) => const MainScreen(),
  };
}
