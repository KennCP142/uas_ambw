import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uas_ambw/config/app_config.dart';
import 'package:uas_ambw/models/activity.dart';
import 'package:uas_ambw/providers/activity_provider.dart';
import 'package:uas_ambw/providers/auth_provider.dart';
import 'package:uas_ambw/utils/utils.dart';
import 'package:uas_ambw/widgets/common_widgets.dart';
import 'package:uuid/uuid.dart';

class AddActivityScreen extends StatefulWidget {
  final dynamic activity;

  const AddActivityScreen({super.key, this.activity});

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late String _selectedCategory;
  late bool _isEditing;
  late Activity? _activityToEdit;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
    _selectedCategory = AppConfig.categories[0]['name'];
    _isEditing = widget.activity != null;
    _activityToEdit = _isEditing ? widget.activity as Activity : null;

    if (_isEditing && _activityToEdit != null) {
      _titleController.text = _activityToEdit!.title;
      _descriptionController.text = _activityToEdit!.description;
      _selectedDate = DateTime(
        _activityToEdit!.time.year,
        _activityToEdit!.time.month,
        _activityToEdit!.time.day,
      );
      _selectedTime = TimeOfDay(
        hour: _activityToEdit!.time.hour,
        minute: _activityToEdit!.time.minute,
      );
      _selectedCategory = _activityToEdit!.category;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final pickedDate = await Utils.showCustomDatePicker(
      context,
      initialDate: _selectedDate,
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await Utils.showCustomTimePicker(
      context,
      initialTime: _selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  Future<void> _saveActivity() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final activityProvider = Provider.of<ActivityProvider>(
        context,
        listen: false,
      );

      if (authProvider.currentUser == null) {
        Utils.showSnackBar(
          context,
          'You need to be logged in to add activities',
          isError: true,
        );
        return;
      }

      // Combine date and time
      final activityDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      try {
        if (_isEditing && _activityToEdit != null) {
          // Update existing activity
          final updatedActivity = _activityToEdit!.copyWith(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            time: activityDateTime,
            category: _selectedCategory,
          );

          await activityProvider.updateActivity(updatedActivity);

          if (mounted) {
            Utils.showSnackBar(context, 'Activity updated successfully');
            context.go('/home');
          }
        } else {
          // Add new activity
          await activityProvider.addActivity(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim(),
            time: activityDateTime,
            category: _selectedCategory,
            userId: authProvider.currentUser!.id,
          );

          if (mounted) {
            Utils.showSnackBar(context, 'Activity added successfully');
            context.go('/home');
          }
        }
      } catch (e) {
        if (mounted) {
          Utils.showSnackBar(
            context,
            'Failed to ${_isEditing ? 'update' : 'add'} activity: ${e.toString()}',
            isError: true,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Activity' : 'Add Activity'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            CustomTextField(
              label: 'Title',
              controller: _titleController,
              validator: (value) => Utils.validateRequired(value, 'Title'),
              hintText: 'Enter activity title',
            ),
            const SizedBox(height: 16),

            // Description field
            CustomTextField(
              label: 'Description',
              controller: _descriptionController,
              hintText: 'Enter activity description (optional)',
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Date picker
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _selectDate,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          color: AppConfig.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(Utils.formatDate(_selectedDate)),
                        const Spacer(),
                        Icon(
                          Icons.arrow_drop_down,
                          color: AppConfig.secondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Time picker
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Time',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _selectTime,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppConfig.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(_selectedTime.format(context)),
                        const Spacer(),
                        Icon(
                          Icons.arrow_drop_down,
                          color: AppConfig.secondaryTextColor,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Category selector
            ActivityCategorySelector(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            const SizedBox(height: 32),

            // Save button
            CustomButton(
              text: _isEditing ? 'Update Activity' : 'Add Activity',
              onPressed: _saveActivity,
              isLoading: activityProvider.isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
