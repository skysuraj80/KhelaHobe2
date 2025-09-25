import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';
import '../models/chat_message.dart';
import '../models/user_profile.dart';

class ChatService {
  static final SupabaseClient _client = SupabaseService.instance.client;

  // Get chat rooms for current user
  static Future<List<Map<String, dynamic>>> getChatRooms() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('chat_rooms')
          .select('''
            *,
            user1:user_profiles!chat_rooms_user1_id_fkey(*),
            user2:user_profiles!chat_rooms_user2_id_fkey(*),
            last_message:chat_messages(content, created_at) 
          ''')
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .order('last_message_at', ascending: false);

      return response.map((room) {
        final otherUser =
            room['user1']['id'] == userId ? room['user2'] : room['user1'];

        return {
          'id': room['id'],
          'other_user': UserProfile.fromJson(otherUser),
          'last_message_at': room['last_message_at'],
          'last_message': room['last_message']?.isNotEmpty == true
              ? room['last_message'][0]['content']
              : 'Start chatting!',
        };
      }).toList();
    } catch (error) {
      throw Exception('Failed to fetch chat rooms: $error');
    }
  }

  // Get messages for a chat room
  static Future<List<ChatMessage>> getChatMessages(String chatRoomId) async {
    try {
      final response = await _client
          .from('chat_messages')
          .select('''
            *,
            sender:user_profiles!chat_messages_sender_id_fkey(*)
          ''')
          .eq('chat_room_id', chatRoomId)
          .order('created_at', ascending: true);

      return response.map((json) => ChatMessage.fromJson(json)).toList();
    } catch (error) {
      throw Exception('Failed to fetch chat messages: $error');
    }
  }

  // Send a message
  static Future<ChatMessage> sendMessage({
    required String chatRoomId,
    required String content,
    String messageType = 'text',
    String? imageUrl,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      final messageData = {
        'chat_room_id': chatRoomId,
        'sender_id': userId,
        'content': content,
        'message_type': messageType,
        'image_url': imageUrl,
      };

      final response =
          await _client.from('chat_messages').insert(messageData).select('''
            *,
            sender:user_profiles!chat_messages_sender_id_fkey(*)
          ''').single();

      // Update last message time in chat room
      await _client
          .from('chat_rooms')
          .update({'last_message_at': DateTime.now().toIso8601String()}).eq(
              'id', chatRoomId);

      return ChatMessage.fromJson(response);
    } catch (error) {
      throw Exception('Failed to send message: $error');
    }
  }

  // Mark messages as read
  static Future<void> markMessagesAsRead(String chatRoomId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      await _client
          .from('chat_messages')
          .update({'is_read': true})
          .eq('chat_room_id', chatRoomId)
          .neq('sender_id', userId) // Only mark others' messages as read
          .eq('is_read', false);
    } catch (error) {
      throw Exception('Failed to mark messages as read: $error');
    }
  }

  // Get or create chat room between two users
  static Future<String> getOrCreateChatRoom(String otherUserId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Try to find existing chat room
      var existingRoom = await _client
          .from('chat_rooms')
          .select('id')
          .or('and(user1_id.eq.$userId,user2_id.eq.$otherUserId),and(user1_id.eq.$otherUserId,user2_id.eq.$userId)')
          .maybeSingle();

      if (existingRoom != null) {
        return existingRoom['id'] as String;
      }

      // Create new chat room
      final response = await _client
          .from('chat_rooms')
          .insert({
            'user1_id': userId,
            'user2_id': otherUserId,
          })
          .select('id')
          .single();

      return response['id'] as String;
    } catch (error) {
      throw Exception('Failed to get or create chat room: $error');
    }
  }

  // Subscribe to real-time messages
  static RealtimeChannel subscribeToMessages(
    String chatRoomId,
    ValueChanged<ChatMessage> onNewMessage,
  ) {
    return _client
        .channel('chat_messages_$chatRoomId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_room_id',
            value: chatRoomId,
          ),
          callback: (payload) async {
            try {
              // Fetch complete message with sender info
              final messageData = await _client.from('chat_messages').select('''
                    *,
                    sender:user_profiles!chat_messages_sender_id_fkey(*)
                  ''').eq('id', payload.newRecord['id']).single();

              final message = ChatMessage.fromJson(messageData);
              onNewMessage(message);
            } catch (e) {
              print('Error processing real-time message: $e');
            }
          },
        )
        .subscribe();
  }

  // Get unread message count for a chat room
  static Future<int> getUnreadMessageCount(String chatRoomId) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return 0;

      final response = await _client
          .from('chat_messages')
          .select()
          .eq('chat_room_id', chatRoomId)
          .neq('sender_id', userId)
          .eq('is_read', false)
          .count();

      return response.count;
    } catch (error) {
      return 0;
    }
  }
}
