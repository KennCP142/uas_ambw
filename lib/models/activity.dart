import 'package:hive/hive.dart';

part 'activity.g.dart';

@HiveType(typeId: 0)
class Activity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final DateTime time;

  @HiveField(4)
  final String category;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  final String userId;

  Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.category,
    this.isCompleted = false,
    required this.userId,
  });

  // Convert Activity to JSON for Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time.toIso8601String(),
      'category': category,
      'is_completed': isCompleted,
      'user_id': userId,
    };
  }

  // Create Activity from JSON (from Supabase)
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      time: DateTime.parse(json['time']),
      category: json['category'],
      isCompleted: json['is_completed'] ?? false,
      userId: json['user_id'],
    );
  }

  // Copy with method for easy updating
  Activity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? time,
    String? category,
    bool? isCompleted,
    String? userId,
  }) {
    return Activity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      userId: userId ?? this.userId,
    );
  }
}
