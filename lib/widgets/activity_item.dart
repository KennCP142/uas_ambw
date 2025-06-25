import 'package:flutter/material.dart';
import 'package:uas_ambw/config/app_config.dart';
import 'package:uas_ambw/models/activity.dart';
import 'package:uas_ambw/utils/utils.dart';

class ActivityItem extends StatelessWidget {
  final Activity activity;
  final Function(Activity) onToggleStatus;
  final Function(Activity) onEdit;
  final Function(String) onDelete;

  const ActivityItem({
    super.key,
    required this.activity,
    required this.onToggleStatus,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppConfig.getCategoryColor(activity.category);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: activity.isCompleted
              ? Colors.grey.shade300
              : Colors.transparent,
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onEdit(activity),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with time and buttons
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getCategoryIcon(activity.category),
                          size: 16,
                          color: categoryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          activity.category,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: categoryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    Utils.formatTime(activity.time),
                    style: TextStyle(
                      color: AppConfig.secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title with completion indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      activity.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decoration: activity.isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                        color: activity.isCompleted
                            ? Colors.grey
                            : AppConfig.textColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      activity.isCompleted
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: activity.isCompleted ? Colors.green : Colors.grey,
                    ),
                    onPressed: () => onToggleStatus(activity),
                  ),
                ],
              ),

              if (activity.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  activity.description,
                  style: TextStyle(
                    color: activity.isCompleted
                        ? Colors.grey
                        : AppConfig.secondaryTextColor,
                    decoration: activity.isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit'),
                    onPressed: () => onEdit(activity),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => _confirmDelete(context),
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Activity'),
        content: Text('Are you sure you want to delete "${activity.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDelete(activity.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Work':
        return Icons.work;
      case 'Personal':
        return Icons.person;
      case 'Health':
        return Icons.favorite;
      case 'Shopping':
        return Icons.shopping_cart;
      case 'Social':
        return Icons.people;
      case 'Education':
        return Icons.school;
      default:
        return Icons.category;
    }
  }
}
