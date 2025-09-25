import './user_profile.dart';

class ChatMessage {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String messageType;
  final String content;
  final String? imageUrl;
  final bool isRead;
  final DateTime createdAt;
  final UserProfile? sender; // Populated via join

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    this.messageType = 'text',
    required this.content,
    this.imageUrl,
    this.isRead = false,
    required this.createdAt,
    this.sender,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      chatRoomId: json['chat_room_id'] as String,
      senderId: json['sender_id'] as String,
      messageType: json['message_type'] as String? ?? 'text',
      content: json['content'] as String,
      imageUrl: json['image_url'] as String?,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      sender:
          json['sender'] != null ? UserProfile.fromJson(json['sender']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_room_id': chatRoomId,
      'sender_id': senderId,
      'message_type': messageType,
      'content': content,
      'image_url': imageUrl,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  ChatMessage copyWith({
    String? id,
    String? chatRoomId,
    String? senderId,
    String? messageType,
    String? content,
    String? imageUrl,
    bool? isRead,
    DateTime? createdAt,
    UserProfile? sender,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      senderId: senderId ?? this.senderId,
      messageType: messageType ?? this.messageType,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      sender: sender ?? this.sender,
    );
  }
}
