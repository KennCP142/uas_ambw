import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uas_ambw/models/activity.dart';
import 'package:uas_ambw/services/storage_service.dart';

class DatabaseService {
  final supabase = Supabase.instance.client;
  final StorageService _storageService = StorageService();

  // Fetch activities for the current user
  Future<List<Activity>> getActivities(String userId) async {
    try {
      final response = await supabase
          .from('activities')
          .select()
          .eq('user_id', userId)
          .order('time');

      List<Activity> activities = response
          .map<Activity>((json) => Activity.fromJson(json))
          .toList();

      // Store in local storage for offline access
      await _storageService.saveActivities(activities);

      return activities;
    } catch (e) {
      // If online fetch fails, try to get from local storage
      return await _storageService.getActivities();
    }
  }

  // Add a new activity
  Future<Activity> addActivity(Activity activity) async {
    try {
      final response = await supabase
          .from('activities')
          .insert(activity.toJson())
          .select()
          .single();

      final newActivity = Activity.fromJson(response);

      // Update local storage
      await _storageService.saveActivity(newActivity);

      return newActivity;
    } catch (e) {
      // Still save to local storage even if online operation fails
      await _storageService.saveActivity(activity);
      return activity;
    }
  }

  // Update an existing activity
  Future<Activity> updateActivity(Activity activity) async {
    try {
      await supabase
          .from('activities')
          .update(activity.toJson())
          .eq('id', activity.id);

      // Update local storage
      await _storageService.saveActivity(activity);

      return activity;
    } catch (e) {
      // Still update local storage even if online operation fails
      await _storageService.saveActivity(activity);
      return activity;
    }
  }

  // Delete an activity
  Future<void> deleteActivity(String activityId) async {
    try {
      await supabase.from('activities').delete().eq('id', activityId);

      // Update local storage
      await _storageService.deleteActivity(activityId);
    } catch (e) {
      // Still delete from local storage even if online operation fails
      await _storageService.deleteActivity(activityId);
    }
  }

  // Toggle activity completion status
  Future<Activity> toggleActivityCompletion(Activity activity) async {
    final updatedActivity = activity.copyWith(
      isCompleted: !activity.isCompleted,
    );
    return await updateActivity(updatedActivity);
  }
}
