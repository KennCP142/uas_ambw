import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uas_ambw/config/app_config.dart';
import 'package:uas_ambw/models/activity.dart';
import 'package:uas_ambw/providers/activity_provider.dart';
import 'package:uas_ambw/providers/auth_provider.dart';
import 'package:uas_ambw/widgets/activity_item.dart';
import 'package:uas_ambw/widgets/common_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _showOnlyPending = true;
  bool _showCalendar = false;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadActivities();
  }

  Future<void> _loadActivities() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final activityProvider = Provider.of<ActivityProvider>(
      context,
      listen: false,
    );

    if (authProvider.currentUser != null) {
      await activityProvider.loadActivities(authProvider.currentUser!.id);
    }
  }

  void _signOut() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();

    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final activityProvider = Provider.of<ActivityProvider>(context);

    List<Activity> filteredActivities = activityProvider.getActivitiesByDate(
      _selectedDate,
    );

    if (_showOnlyPending) {
      filteredActivities = filteredActivities
          .where((activity) => !activity.isCompleted)
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _showOnlyPending = !_showOnlyPending;
              });
            },
            tooltip: _showOnlyPending
                ? 'Show all activities'
                : 'Show only pending',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
            tooltip: 'Sign out',
          ),
        ],
      ),
      body: Column(
        children: [
          // User greeting section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConfig.primaryColor.withOpacity(0.1),
                  AppConfig.secondaryColor.withOpacity(0.1),
                ],
              ),
            ),
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final userName = authProvider.currentUser?.name ?? 'User';
                return Text(
                  'Hello, $userName!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppConfig.primaryColor,
                  ),
                );
              },
            ),
          ),

          // Date selector
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: AppConfig.primaryColor.withOpacity(0.1),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 18),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate.subtract(
                            const Duration(days: 1),
                          );
                          _focusedDay = _selectedDate;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _showCalendar = !_showCalendar;
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('EEEE').format(_selectedDate),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  _showCalendar
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  size: 18,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMMM d, y').format(_selectedDate),
                              style: TextStyle(
                                color: AppConfig.secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward_ios, size: 18),
                      onPressed: () {
                        setState(() {
                          _selectedDate = _selectedDate.add(
                            const Duration(days: 1),
                          );
                          _focusedDay = _selectedDate;
                        });
                      },
                    ),
                  ],
                ),
                if (_showCalendar)
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDate, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDate = selectedDay;
                        _focusedDay = focusedDay;
                        _showCalendar = false; // hide calendar after selection
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: AppConfig.primaryColor.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: AppConfig.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Colors.red.shade300,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerVisible: false,
                  ),
              ],
            ),
          ),

          // Activities list
          Expanded(
            child: activityProvider.isLoading
                ? const LoadingIndicator(message: 'Loading activities...')
                : activityProvider.error != null
                ? ErrorStateWidget(
                    message: activityProvider.error!,
                    onRetry: _loadActivities,
                  )
                : filteredActivities.isEmpty
                ? EmptyStateWidget(
                    message: _showOnlyPending
                        ? 'No pending activities for today. Tap + to add a new activity.'
                        : 'No activities for today. Tap + to add a new activity.',
                    icon: Icons.event_available,
                    actionLabel: 'Add Activity',
                    onActionPressed: () {
                      context.go('/add-activity');
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredActivities.length,
                    itemBuilder: (context, index) {
                      final activity = filteredActivities[index];
                      return ActivityItem(
                        activity: activity,
                        onToggleStatus: (activity) {
                          activityProvider.toggleActivityCompletion(activity);
                        },
                        onEdit: (activity) {
                          context.go('/add-activity', extra: activity);
                        },
                        onDelete: (id) {
                          activityProvider.deleteActivity(id);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/add-activity');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
