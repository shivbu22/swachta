class WorkerModel {
  final String id;
  final String name;
  final String role;
  final String phone;
  final String? avatarUrl;
  final String status;
  final double rating;
  final String district;
  final double todayEarnings;
  final int jobsCompleted;
  final double? latitude;
  final double? longitude;
  final String? currentJobType;
  final DateTime? lastSeen;
  final DateTime createdAt;

  WorkerModel({
    required this.id,
    required this.name,
    required this.role,
    this.phone = '',
    this.avatarUrl,
    this.status = 'offline',
    this.rating = 0,
    this.district = '',
    this.todayEarnings = 0,
    this.jobsCompleted = 0,
    this.latitude,
    this.longitude,
    this.currentJobType,
    this.lastSeen,
    required this.createdAt,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) {
    return WorkerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? 'collector',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatar_url'],
      status: json['status'] ?? 'offline',
      rating: (json['rating'] ?? 0).toDouble(),
      district: json['district'] ?? '',
      todayEarnings: (json['today_earnings'] ?? 0).toDouble(),
      jobsCompleted: json['jobs_completed'] ?? 0,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      currentJobType: json['current_job_type'],
      lastSeen: json['last_seen'] != null ? DateTime.parse(json['last_seen']) : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'phone': phone,
    'avatar_url': avatarUrl,
    'status': status,
    'rating': rating,
    'district': district,
    'today_earnings': todayEarnings,
    'jobs_completed': jobsCompleted,
    'latitude': latitude,
    'longitude': longitude,
    'current_job_type': currentJobType,
    'last_seen': lastSeen?.toIso8601String(),
    'created_at': createdAt.toIso8601String(),
  };

  WorkerModel copyWith({
    String? status,
    double? todayEarnings,
    int? jobsCompleted,
    double? latitude,
    double? longitude,
    String? currentJobType,
  }) {
    return WorkerModel(
      id: id,
      name: name,
      role: role,
      phone: phone,
      avatarUrl: avatarUrl,
      status: status ?? this.status,
      rating: rating,
      district: district,
      todayEarnings: todayEarnings ?? this.todayEarnings,
      jobsCompleted: jobsCompleted ?? this.jobsCompleted,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      currentJobType: currentJobType ?? this.currentJobType,
      lastSeen: lastSeen,
      createdAt: createdAt,
    );
  }
}
