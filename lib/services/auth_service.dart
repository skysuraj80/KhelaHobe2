import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/user_profile.dart';

class AuthService {
  static final SupabaseClient _client = SupabaseService.instance.client;

  // Get current user
  static User? get currentUser => _client.auth.currentUser;

  // Check if user is authenticated
  static bool get isAuthenticated => currentUser != null;

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );
      return response;
    } catch (error) {
      throw Exception('Sign-up failed: $error');
    }
  }

  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (error) {
      throw Exception('Sign-in failed: $error');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Sign-out failed: $error');
    }
  }

  // Get current user profile
  static Future<UserProfile?> getCurrentUserProfile() async {
    try {
      if (!isAuthenticated) return null;

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', currentUser!.id)
          .single();

      return UserProfile.fromJson(response);
    } catch (error) {
      throw Exception('Failed to get user profile: $error');
    }
  }

  // Update user profile
  static Future<UserProfile> updateProfile({
    String? fullName,
    String? bio,
    String? locationName,
    double? locationLat,
    double? locationLng,
    int? age,
    String? profileImageUrl,
  }) async {
    try {
      if (!isAuthenticated) throw Exception('User not authenticated');

      final updates = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (fullName != null) updates['full_name'] = fullName;
      if (bio != null) updates['bio'] = bio;
      if (locationName != null) updates['location_name'] = locationName;
      if (locationLat != null) updates['location_lat'] = locationLat;
      if (locationLng != null) updates['location_lng'] = locationLng;
      if (age != null) updates['age'] = age;
      if (profileImageUrl != null)
        updates['profile_image_url'] = profileImageUrl;

      final response = await _client
          .from('user_profiles')
          .update(updates)
          .eq('id', currentUser!.id)
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (error) {
      throw Exception('Failed to update profile: $error');
    }
  }

  // Listen to auth state changes
  static Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (error) {
      throw Exception('Password reset failed: $error');
    }
  }

  // Delete user account
  static Future<void> deleteUser() async {
    try {
      if (!isAuthenticated) throw Exception('User not authenticated');

      await _client.from('user_profiles').delete().eq('id', currentUser!.id);
      await _client.auth.signOut();
    } catch (error) {
      throw Exception('Failed to delete user: $error');
    }
  }
}
