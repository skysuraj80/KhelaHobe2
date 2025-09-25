class UserProfile {
  final String id;
  final String email;
  final String fullName;
  final String? bio;
  final String? profileImageUrl;
  final double? locationLat;
  final double? locationLng;
  final String? locationName;
  final int? age;
  final String status;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    required this.fullName,
    this.bio,
    this.profileImageUrl,
    this.locationLat,
    this.locationLng,
    this.locationName,
    this.age,
    this.status = 'active',
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      email: json['email'] as String,
      fullName: json['full_name'] as String,
      bio: json['bio'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      locationLat: json['location_lat']?.toDouble(),
      locationLng: json['location_lng']?.toDouble(),
      locationName: json['location_name'] as String?,
      age: json['age'] as int?,
      status: json['status'] as String? ?? 'active',
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
      'bio': bio,
      'profile_image_url': profileImageUrl,
      'location_lat': locationLat,
      'location_lng': locationLng,
      'location_name': locationName,
      'age': age,
      'status': status,
      'is_verified': isVerified,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserProfile copyWith({
    String? id,
    String? email,
    String? fullName,
    String? bio,
    String? profileImageUrl,
    double? locationLat,
    double? locationLng,
    String? locationName,
    int? age,
    String? status,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      locationLat: locationLat ?? this.locationLat,
      locationLng: locationLng ?? this.locationLng,
      locationName: locationName ?? this.locationName,
      age: age ?? this.age,
      status: status ?? this.status,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
