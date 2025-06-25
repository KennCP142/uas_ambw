import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String? name;

  User({required this.id, required this.email, this.name});

  // Create User from Supabase User data
  factory User.fromSupabase(Map<String, dynamic> userData) {
    return User(
      id: userData['id'],
      email: userData['email'],
      name: userData['user_metadata']?['name'],
    );
  }
}
