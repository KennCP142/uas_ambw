import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_ambw/models/activity.dart';
import 'package:uas_ambw/models/user.dart';

class StorageService {
  static const String _userBoxName = 'userBox';
  static const String _activitiesBoxName = 'activitiesBox';
  static const String _isFirstLaunchKey = 'isFirstLaunch';

  // Initialize Hive
  Future<void> initHive() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ActivityAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserAdapter());
    }

    await Hive.openBox<User>(_userBoxName);
    await Hive.openBox<Activity>(_activitiesBoxName);
  }

  // Save user to Hive
  Future<void> saveUser(User user) async {
    final box = Hive.box<User>(_userBoxName);
    await box.put('currentUser', user);
  }

  // Get user from Hive
  Future<User?> getUser() async {
    final box = Hive.box<User>(_userBoxName);
    return box.get('currentUser');
  }

  // Clear user from Hive
  Future<void> clearUser() async {
    final box = Hive.box<User>(_userBoxName);
    await box.delete('currentUser');
  }

  // Save activities to Hive
  Future<void> saveActivities(List<Activity> activities) async {
    final box = Hive.box<Activity>(_activitiesBoxName);
    await box.clear();

    for (var activity in activities) {
      await box.put(activity.id, activity);
    }
  }

  // Get activities from Hive
  Future<List<Activity>> getActivities() async {
    final box = Hive.box<Activity>(_activitiesBoxName);
    return box.values.toList();
  }

  // Add or update a single activity
  Future<void> saveActivity(Activity activity) async {
    final box = Hive.box<Activity>(_activitiesBoxName);
    await box.put(activity.id, activity);
  }

  // Delete activity
  Future<void> deleteActivity(String id) async {
    final box = Hive.box<Activity>(_activitiesBoxName);
    await box.delete(id);
  }

  // Check if it's the first launch of the app
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isFirstLaunchKey) ?? true;
  }

  // Set first launch to false
  Future<void> setFirstLaunchDone() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstLaunchKey, false);
  }
}
