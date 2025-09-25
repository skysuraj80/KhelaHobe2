import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/user_profile.dart';

class DiscoveryService {
  static final SupabaseClient _client = SupabaseService.instance.client;

  // Get potential matches for discovery
  static Future<List<UserProfile>> getDiscoveryProfiles({
    int limit = 10,
    List<String>? sportTypes,
    String? skillLevel,
    double? maxDistance,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Get users that haven't been swiped on yet
      var query = _client
          .from('user_profiles')
          .select()
          .neq('id', userId) // Not current user
          .eq('status', 'active'); // Only active users

      // Exclude already matched/swiped users
      final swipedUsers = await _client
          .from('user_matches')
          .select('target_user_id')
          .eq('user_id', userId);

      final swipedUserIds =
          swipedUsers.map((m) => m['target_user_id'] as String).toList();

      if (swipedUserIds.isNotEmpty) {
        query = query.not('id', 'in', swipedUserIds);
      }

      final response = await query.limit(limit);

      return response.map((json) => UserProfile.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch discovery profiles: $error');
    }
  }

  // Swipe right (like) a user
  static Future<bool> swipeRight(String targetUserId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Insert the like
      await _client.from('user_matches').insert({
        'user_id': userId,
        'target_user_id': targetUserId,
        'status': 'pending',
      });

      // Check if the other user also liked us (mutual match)
      final reverseMatch = await _client
          .from('user_matches')
          .select()
          .eq('user_id', targetUserId)
          .eq('target_user_id', userId)
          .maybeSingle();

      if (reverseMatch != null) {
        // It's a match! Update both records
        await _client
            .from('user_matches')
            .update({'status': 'matched'})
            .eq('user_id', userId)
            .eq('target_user_id', targetUserId);

        await _client
            .from('user_matches')
            .update({'status': 'matched'})
            .eq('user_id', targetUserId)
            .eq('target_user_id', userId);

        // Create chat room for matched users
        await _client.from('chat_rooms').insert({
          'user1_id': userId,
          'user2_id': targetUserId,
        });

        return true; // It's a match!
      }

      return false; // Not a match yet
    } catch (error) {
      throw Exception('Failed to swipe right: $error');
    }
  }

  // Swipe left (pass) a user
  static Future<void> swipeLeft(String targetUserId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _client.from('user_matches').insert({
        'user_id': userId,
        'target_user_id': targetUserId,
        'status': 'rejected',
      });
    } catch (error) {
      throw Exception('Failed to swipe left: $error');
    }
  }

  // Get user's matches
  static Future<List<UserProfile>> getMatches() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('user_matches')
          .select('''
            target_user:user_profiles!user_matches_target_user_id_fkey(*)
          ''')
          .eq('user_id', userId)
          .eq('status', 'matched')
          .order('updated_at', ascending: false);

      return response
          .where((item) => item['target_user'] != null)
          .map((item) => UserProfile.fromJson(item['target_user']))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch matches: $error');
    }
  }

  // Get users with similar sport preferences
  static Future<List<UserProfile>> getSimilarSportUsers(
      String sportType) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client.from('user_sports').select('''
            user_profiles:user_id(*)
          ''').eq('sport_type', sportType).neq('user_id', userId);

      return response
          .where((item) => item['user_profiles'] != null)
          .map((item) => UserProfile.fromJson(item['user_profiles']))
          .toList();
    } catch (error) {
      throw Exception('Failed to fetch similar sport users: $error');
    }
  }

  // Check if two users are matched
  static Future<bool> areUsersMatched(String otherUserId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return false;

      final match = await _client
          .from('user_matches')
          .select()
          .eq('user_id', userId)
          .eq('target_user_id', otherUserId)
          .eq('status', 'matched')
          .maybeSingle();

      return match != null;
    } catch (error) {
      return false;
    }
  }
}
