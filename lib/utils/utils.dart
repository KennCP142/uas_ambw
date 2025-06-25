import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    return null;
  }

  // Required field validation
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }

    return null;
  }

  // Format date
  static String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  // Format time
  static String formatTime(DateTime time) {
    return DateFormat('hh:mm a').format(time);
  }

  // Format date and time
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy - hh:mm a').format(dateTime);
  }

  // Show snackbar
  static void showSnackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Show date picker
  static Future<DateTime?> showCustomDatePicker(
    BuildContext context, {
    DateTime? initialDate,
  }) async {
    final DateTime now = DateTime.now();
    initialDate ??= now;

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Theme.of(context).cardColor,
              headerBackgroundColor: Theme.of(context).colorScheme.primary,
              headerForegroundColor: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
  }

  // Show time picker
  static Future<TimeOfDay?> showCustomTimePicker(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) async {
    initialTime ??= TimeOfDay.now();

    return await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).cardColor,
              hourMinuteColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
              hourMinuteTextColor: Theme.of(context).colorScheme.primary,
              dayPeriodColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
              dayPeriodTextColor: Theme.of(context).colorScheme.primary,
              dialHandColor: Theme.of(context).colorScheme.primary,
              dialBackgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
