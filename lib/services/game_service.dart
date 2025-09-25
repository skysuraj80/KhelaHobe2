import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/game.dart';
import '../models/user_profile.dart';

class GameService {
  static final SupabaseClient _client = SupabaseService.instance.client;

  // Get all games with host information and participant count
  static Future<List<Game>> getAllGames({
    String? sportType,
    String? location,
    DateTime? date,
    int limit = 50,
  }) async {
    try {
      var query = _client.from('games').select('''
            *,
            host:user_profiles!games_host_id_fkey(*),
            game_participants(count)
          ''');

      // Apply filters
      if (sportType != null && sportType != 'all') {
        query = query.eq('sport_type', sportType);
      }

      if (date != null) {
        query =
            query.eq('scheduled_date', date.toIso8601String().split('T')[0]);
      }

      // Only show open games by default
      query = query.eq('status', 'open');

      final response = await query
          .order('scheduled_date')
          .order('scheduled_time')
          .limit(limit);

      return response.map((json) {
        final participantCount = json['game_participants']?.length ?? 0;
        json['current_players'] = participantCount;
        return Game.fromJson(json);
      }).toList();
    } catch (error) {
      throw Exception('Failed to fetch games: $error');
    }
  }

  // Get games near a location
  static Future<List<Game>> getGamesNearLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
    String? sportType,
    int limit = 20,
  }) async {
    try {
      // Basic distance filtering using SQL
      var query = _client.from('games').select('''
            *,
            host:user_profiles!games_host_id_fkey(*),
            game_participants(count)
          ''').eq('status', 'open');

      if (sportType != null && sportType != 'all') {
        query = query.eq('sport_type', sportType);
      }

      final response = await query.order('scheduled_date').limit(limit);

      return response.map((json) {
        final participantCount = json['game_participants']?.length ?? 0;
        json['current_players'] = participantCount;
        return Game.fromJson(json);
      }).toList();
    } catch (error) {
      throw Exception('Failed to fetch nearby games: $error');
    }
  }

  // Create a new game
  static Future<Game> createGame({
    required String sportType,
    required String title,
    String? description,
    required String locationName,
    required double locationLat,
    required double locationLng,
    required DateTime scheduledDate,
    required String scheduledTime,
    required int maxPlayers,
    double costPerPlayer = 0.0,
    String? requiredSkillLevel,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final gameData = {
        'host_id': userId,
        'sport_type': sportType,
        'title': title,
        'description': description,
        'location_name': locationName,
        'location_lat': locationLat,
        'location_lng': locationLng,
        'scheduled_date': scheduledDate.toIso8601String().split('T')[0],
        'scheduled_time': scheduledTime,
        'max_players': maxPlayers,
        'cost_per_player': costPerPlayer,
        'required_skill_level': requiredSkillLevel,
        'status': 'open',
      };

      final response = await _client.from('games').insert(gameData).select('''
            *,
            host:user_profiles!games_host_id_fkey(*)
          ''').single();

      return Game.fromJson(response);
    } catch (error) {
      throw Exception('Failed to create game: $error');
    }
  }

  // Join a game
  static Future<void> joinGame(String gameId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _client.from('game_participants').insert({
        'game_id': gameId,
        'user_id': userId,
      });
    } catch (error) {
      throw Exception('Failed to join game: $error');
    }
  }

  // Leave a game
  static Future<void> leaveGame(String gameId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _client
          .from('game_participants')
          .delete()
          .eq('game_id', gameId)
          .eq('user_id', userId);
    } catch (error) {
      throw Exception('Failed to leave game: $error');
    }
  }

  // Get user's games (hosted and joined)
  static Future<List<Game>> getUserGames() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Get hosted games
      final hostedGames = await _client.from('games').select('''
            *,
            host:user_profiles!games_host_id_fkey(*),
            game_participants(count)
          ''').eq('host_id', userId).order('scheduled_date');

      // Get joined games
      final joinedGamesResponse =
          await _client.from('game_participants').select('''
            games:game_id(
              *,
              host:user_profiles!games_host_id_fkey(*),
              game_participants(count)
            )
          ''').eq('user_id', userId);

      final List<Game> allGames = [];

      // Process hosted games
      for (final json in hostedGames) {
        final participantCount = json['game_participants']?.length ?? 0;
        json['current_players'] = participantCount;
        allGames.add(Game.fromJson(json));
      }

      // Process joined games
      for (final item in joinedGamesResponse) {
        if (item['games'] != null) {
          final json = item['games'];
          final participantCount = json['game_participants']?.length ?? 0;
          json['current_players'] = participantCount;
          allGames.add(Game.fromJson(json));
        }
      }

      // Sort by scheduled date
      allGames.sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
      return allGames;
    } catch (error) {
      throw Exception('Failed to fetch user games: $error');
    }
  }

  // Update game status
  static Future<Game> updateGameStatus(String gameId, String status) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('games')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String()
          })
          .eq('id', gameId)
          .eq('host_id', userId) // Only host can update status
          .select('''
            *,
            host:user_profiles!games_host_id_fkey(*)
          ''')
          .single();

      return Game.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update game status: $error');
    }
  }

  // Get game participants
  static Future<List<UserProfile>> getGameParticipants(String gameId) async {
    try {
      final response = await _client.from('game_participants').select('''
            user_profiles:user_id(*)
          ''').eq('game_id', gameId).order('joined_at');

      return response
          .where((item) => item['user_profiles'] != null)
          .map((item) => UserProfile.fromJson(item['user_profiles']))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch game participants: $error');
    }
  }
}
