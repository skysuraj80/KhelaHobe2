import './user_profile.dart';

class Game {
  final String id;
  final String hostId;
  final String sportType;
  final String title;
  final String? description;
  final String locationName;
  final double locationLat;
  final double locationLng;
  final DateTime scheduledDate;
  final String scheduledTime;
  final int maxPlayers;
  final double costPerPlayer;
  final String status;
  final String? requiredSkillLevel;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserProfile? host; // Populated via join
  final int currentPlayers; // Count from participants

  Game({
    required this.id,
    required this.hostId,
    required this.sportType,
    required this.title,
    this.description,
    required this.locationName,
    required this.locationLat,
    required this.locationLng,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.maxPlayers,
    this.costPerPlayer = 0.0,
    this.status = 'open',
    this.requiredSkillLevel,
    required this.createdAt,
    required this.updatedAt,
    this.host,
    this.currentPlayers = 0,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      sportType: json['sport_type'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      locationName: json['location_name'] as String,
      locationLat: (json['location_lat'] as num).toDouble(),
      locationLng: (json['location_lng'] as num).toDouble(),
      scheduledDate: DateTime.parse(json['scheduled_date'] as String),
      scheduledTime: json['scheduled_time'] as String,
      maxPlayers: json['max_players'] as int,
      costPerPlayer: (json['cost_per_player'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'open',
      requiredSkillLevel: json['required_skill_level'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      host: json['host'] != null ? UserProfile.fromJson(json['host']) : null,
      currentPlayers: json['current_players'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'host_id': hostId,
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
      'status': status,
      'required_skill_level': requiredSkillLevel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  bool get isFull => currentPlayers >= maxPlayers;
  bool get isOpen => status == 'open';

  Game copyWith({
    String? id,
    String? hostId,
    String? sportType,
    String? title,
    String? description,
    String? locationName,
    double? locationLat,
    double? locationLng,
    DateTime? scheduledDate,
    String? scheduledTime,
    int? maxPlayers,
    double? costPerPlayer,
    String? status,
    String? requiredSkillLevel,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserProfile? host,
    int? currentPlayers,
  }) {
    return Game(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      sportType: sportType ?? this.sportType,
      title: title ?? this.title,
      description: description ?? this.description,
      locationName: locationName ?? this.locationName,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      costPerPlayer: costPerPlayer ?? this.costPerPlayer,
      status: status ?? this.status,
      requiredSkillLevel: requiredSkillLevel ?? this.requiredSkillLevel,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      host: host ?? this.host,
      currentPlayers: currentPlayers ?? this.currentPlayers,
    );
  }
}
