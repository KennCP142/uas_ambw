import 'package:flutter/foundation.dart';
import 'package:uas_ambw/models/activity.dart';
import 'package:uas_ambw/services/database_service.dart';
import 'package:uuid/uuid.dart';

class ActivityProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Activity> _activities = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Activity> get activities => _activities;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Filter activities by completion status
  List<Activity> get completedActivities =>
      _activities.where((activity) => activity.isCompleted).toList();
  List<Activity> get pendingActivities =>
      _activities.where((activity) => !activity.isCompleted).toList();

  // Filter activities by date
  List<Activity> getActivitiesByDate(DateTime date) {
    return _activities
        .where(
          (activity) =>
              activity.time.year == date.year &&
              activity.time.month == date.month &&
              activity.time.day == date.day,
        )
        .toList();
  }

  // Load activities for a user
  Future<void> loadActivities(String userId) async {
    _setLoading(true);
    try {
      _activities = await _databaseService.getActivities(userId);
      _error = null;
    } catch (e) {
      _error = 'Failed to load activities: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Add a new activity
  Future<void> addActivity({
    required String title,
    required String description,
    required DateTime time,
    required String category,
    required String userId,
  }) async {
    _setLoading(true);
    try {
      final activity = Activity(
        id: const Uuid().v4(),
        title: title,
        description: description,
        time: time,
        category: category,
        isCompleted: false,
        userId: userId,
      );

      final newActivity = await _databaseService.addActivity(activity);
      _activities.add(newActivity);
      _activities.sort((a, b) => a.time.compareTo(b.time));
      _error = null;
    } catch (e) {
      _error = 'Failed to add activity: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Update an existing activity
  Future<void> updateActivity(Activity activity) async {
    _setLoading(true);
    try {
      final updatedActivity = await _databaseService.updateActivity(activity);
      final index = _activities.indexWhere((a) => a.id == activity.id);
      if (index != -1) {
        _activities[index] = updatedActivity;
        _activities.sort((a, b) => a.time.compareTo(b.time));
      }
      _error = null;
    } catch (e) {
      _error = 'Failed to update activity: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Delete an activity
  Future<void> deleteActivity(String id) async {
    _setLoading(true);
    try {
      await _databaseService.deleteActivity(id);
      _activities.removeWhere((activity) => activity.id == id);
      _error = null;
    } catch (e) {
      _error = 'Failed to delete activity: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Toggle activity completion status
  Future<void> toggleActivityCompletion(Activity activity) async {
    _setLoading(true);
    try {
      final updatedActivity = await _databaseService.toggleActivityCompletion(
        activity,
      );
      final index = _activities.indexWhere((a) => a.id == activity.id);
      if (index != -1) {
        _activities[index] = updatedActivity;
      }
      _error = null;
    } catch (e) {
      _error = 'Failed to update activity status: ${e.toString()}';
    } finally {
      _setLoading(false);
    }
  }

  // Helper method to set loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Clear errors
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
