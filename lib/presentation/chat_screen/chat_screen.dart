import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/app_export.dart';
import '../../models/chat_message.dart';
import '../../models/user_profile.dart';
import '../../services/auth_service.dart';
import '../../services/chat_service.dart';
import './widgets/message_bubble_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/safety_menu_widget.dart';
import './widgets/typing_indicator_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> _messages = [];
  List<Map<String, dynamic>> _chatRooms = [];
  bool _isLoading = true;
  String? _selectedChatRoomId;
  UserProfile? _selectedChatUser;
  final ScrollController _scrollController = ScrollController();
  RealtimeChannel? _messageSubscription;

  @override
  void initState() {
    super.initState();
    _loadChatRooms();
  }

  @override
  void dispose() {
    _messageSubscription?.unsubscribe();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadChatRooms() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (!AuthService.isAuthenticated) {
        // Preview Mode: Show mock chat rooms
        setState(() {
          _chatRooms = _getMockChatRooms();
          _isLoading = false;
        });
        return;
      }

      final chatRooms = await ChatService.getChatRooms();

      setState(() {
        _chatRooms = chatRooms;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Show mock data on error for preview
        _chatRooms = _getMockChatRooms();
      });
    }
  }

  List<Map<String, dynamic>> _getMockChatRooms() {
    return [
      {
        'id': 'room1',
        'other_user': UserProfile(
            id: 'user1',
            email: 'sarah@example.com',
            fullName: 'Sarah Johnson',
            profileImageUrl:
                'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()),
        'last_message': 'That sounds great! I\'m free Saturday morning.',
        'last_message_at':
            DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      },
      {
        'id': 'room2',
        'other_user': UserProfile(
            id: 'user2',
            email: 'mike@example.com',
            fullName: 'Mike Wilson',
            profileImageUrl:
                'https://images.pexels.com/photos/1516680/pexels-photo-1516680.jpeg',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now()),
        'last_message': 'Looking forward to the game!',
        'last_message_at':
            DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
      },
    ];
  }

  List<ChatMessage> _getMockMessages() {
    final now = DateTime.now();
    return [
      ChatMessage(
          id: 'msg1',
          chatRoomId: _selectedChatRoomId!,
          senderId: 'user1',
          content: 'Hey! I saw you\'re into tennis. Want to play this weekend?',
          createdAt: now.subtract(const Duration(hours: 3))),
      ChatMessage(
          id: 'msg2',
          chatRoomId: _selectedChatRoomId!,
          senderId: AuthService.currentUser?.id ?? 'current_user',
          content: 'That sounds great! I\'m free Saturday morning.',
          createdAt: now.subtract(const Duration(hours: 2))),
      ChatMessage(
          id: 'msg3',
          chatRoomId: _selectedChatRoomId!,
          senderId: 'user1',
          content: 'Perfect! I\'ll create a game and send you the details.',
          createdAt: now.subtract(const Duration(minutes: 30))),
    ];
  }

  Future<void> _loadMessages(String chatRoomId) async {
    try {
      setState(() {
        _isLoading = true;
        _selectedChatRoomId = chatRoomId;
      });

      // Unsubscribe from previous room
      _messageSubscription?.unsubscribe();

      if (!AuthService.isAuthenticated) {
        // Preview Mode: Show mock messages
        setState(() {
          _messages = _getMockMessages();
          _isLoading = false;
        });
        _scrollToBottom();
        return;
      }

      final messages = await ChatService.getChatMessages(chatRoomId);

      setState(() {
        _messages = messages;
        _isLoading = false;
      });

      // Subscribe to real-time messages
      _messageSubscription =
          ChatService.subscribeToMessages(chatRoomId, (newMessage) {
        setState(() {
          _messages.add(newMessage);
        });
        _scrollToBottom();
      });

      // Mark messages as read
      await ChatService.markMessagesAsRead(chatRoomId);

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
        // Show mock messages on error
        _messages = _getMockMessages();
      });
      _scrollToBottom();
    }
  }

  Future<void> _sendMessage(String content) async {
    if (_selectedChatRoomId == null || content.trim().isEmpty) return;

    try {
      if (!AuthService.isAuthenticated) {
        // Preview mode: Add mock message
        setState(() {
          _messages.add(ChatMessage(
              id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
              chatRoomId: _selectedChatRoomId!,
              senderId: 'current_user',
              content: content,
              createdAt: DateTime.now()));
        });
        _scrollToBottom();
        return;
      }

      await ChatService.sendMessage(
          chatRoomId: _selectedChatRoomId!, content: content);

      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to send message: ${e.toString()}'),
            backgroundColor: Colors.red));
      }
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _showSafetyMenu() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SafetyMenuWidget(onEmergencyContact: () {
              Navigator.pop(context);
              // Implement emergency contact functionality
            }, onReport: () {
              Navigator.pop(context);
              // Implement report functionality
            }, onBlock: () {
              Navigator.pop(context);
              // Implement block functionality
            }));
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedChatRoomId == null) {
      return _buildChatRoomsList();
    } else {
      return _buildChatView();
    }
  }

  Widget _buildChatRoomsList() {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: _buildChatRoomsBody());
  }

  Widget _buildChatRoomsBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_chatRooms.isEmpty) {
      return Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.chat_outlined, size: 64.sp, color: Colors.grey),
        SizedBox(height: 4.h),
        Text('No Messages Yet',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: Colors.grey, fontWeight: FontWeight.w600)),
        SizedBox(height: 8.h),
        Text('Start matching with players to begin chatting',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center),
        SizedBox(height: 4.h),
        ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.discovery);
            },
            icon: const Icon(Icons.explore),
            label: const Text('Discover Players')),
      ]));
    }

    return ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: _chatRooms.length,
        itemBuilder: (context, index) {
          final room = _chatRooms[index];
          final otherUser = room['other_user'] as UserProfile;
          final lastMessage = room['last_message'] as String;
          final lastMessageAt =
              DateTime.parse(room['last_message_at'] as String);

          return Card(
              margin: EdgeInsets.only(bottom: 4.h),
              child: ListTile(
                  contentPadding: EdgeInsets.all(16.w),
                  leading: CircleAvatar(
                      radius: 28.w,
                      backgroundImage: otherUser.profileImageUrl != null
                          ? NetworkImage(otherUser.profileImageUrl!)
                          : null,
                      child: otherUser.profileImageUrl == null
                          ? Text(otherUser.fullName[0])
                          : null),
                  title: Text(otherUser.fullName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  subtitle: Text(lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.grey)),
                  trailing: Text(_formatTime(lastMessageAt),
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.grey)),
                  onTap: () {
                    setState(() {
                      _selectedChatUser = otherUser;
                    });
                    _loadMessages(room['id'] as String);
                  }));
        });
  }

  Widget _buildChatView() {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            leading: IconButton(
                onPressed: () {
                  setState(() {
                    _selectedChatRoomId = null;
                    _selectedChatUser = null;
                    _messages.clear();
                  });
                  _messageSubscription?.unsubscribe();
                },
                icon: const Icon(Icons.arrow_back)),
            title: Row(children: [
              CircleAvatar(
                  radius: 20.w,
                  backgroundImage: _selectedChatUser?.profileImageUrl != null
                      ? NetworkImage(_selectedChatUser!.profileImageUrl!)
                      : null,
                  child: _selectedChatUser?.profileImageUrl == null
                      ? Text(_selectedChatUser?.fullName[0] ?? 'U')
                      : null),
              SizedBox(width: 12.w),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(_selectedChatUser?.fullName ?? 'User',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const Text('Online',
                        style: TextStyle(fontSize: 12, color: Colors.white70)),
                  ])),
            ]),
            actions: [
              IconButton(
                  onPressed: _showSafetyMenu,
                  icon: const Icon(Icons.more_vert)),
            ]),
        body: Column(children: [
          // Messages
          Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.all(16.w),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isMe =
                            message.senderId == AuthService.currentUser?.id ||
                                message.senderId == 'current_user';

                        return MessageBubbleWidget(
                            message: message.content,
                            timestamp: message.createdAt,
                            isMe: isMe);
                      })),

          // Typing indicator
          TypingIndicatorWidget(
              userName: _selectedChatUser?.fullName ?? 'User'),

          // Message input
          MessageInputWidget(
              onSendMessage: _sendMessage,
              onSendImage: (String path) {},
              onSendAudio: (String path) {},
              onGameProposal: () {}),
        ]));
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
}
