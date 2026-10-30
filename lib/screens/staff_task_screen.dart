import 'package:flutter/material.dart';

import '../models/hotel_task.dart';
import '../models/staff_member.dart';
import '../l10n/app_localizations.dart';
import '../services/staff_service.dart';
import '../services/task_service.dart';
import 'profile_status_screen.dart';
import '../widgets/language_menu.dart';

class StaffTaskScreen extends StatelessWidget {
  const StaffTaskScreen({
    super.key,
    required this.uid,
    required this.displayName,
    required this.onSignOut,
    required this.locale,
    required this.onLocaleChanged,
  });

  final String uid;
  final String displayName;
  final VoidCallback onSignOut;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.appTitle),
        actions: [
          LanguageMenu(locale: locale, onLocaleChanged: onLocaleChanged),
          IconButton(
            tooltip: strings.signOut,
            onPressed: onSignOut,
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<StaffMember>>(
        stream: StaffService.instance.watchStaffForUid(uid),
        builder: (context, staffSnapshot) {
          if (staffSnapshot.hasError) {
            return _MessageView(
              icon: Icons.cloud_off_outlined,
              message: strings.staffProfileError,
            );
          }
          if (!staffSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final staff = staffSnapshot.data!;
          if (staff.isEmpty) {
            return ProfileStatusScreen(
              title: strings.staffProfileNotLinked,
              message: strings.linkStaffProfileHelp,
              onSignOut: onSignOut,
            );
          }

          final member = staff.first;
          return StreamBuilder<List<HotelTask>>(
            stream: TaskService.instance.watchAssignedTasks(uid),
            builder: (context, taskSnapshot) {
              if (taskSnapshot.hasError) {
                return _MessageView(
                  icon: Icons.cloud_off_outlined,
                  message: strings.assignedTasksError,
                );
              }
              if (!taskSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final tasks = [...taskSnapshot.data!]
                ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Text(
                        strings.staffGreeting(member.name),
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${_departmentLabel(member.department, strings)} • $displayName',
                      ),
                      const SizedBox(height: 22),
                      Text(
                        strings.myTasksCount(tasks.length),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      if (tasks.isEmpty)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(strings.noAssignedTasks),
                          ),
                        )
                      else
                        ...tasks.map(
                          (task) => _StaffTaskCard(
                            task: task,
                            onStatusChanged: (status) =>
                                _changeStatus(context, task, status),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _changeStatus(
    BuildContext context,
    HotelTask task,
    TaskStatus status,
  ) async {
    final strings = AppLocalizations.of(context)!;
    try {
      await TaskService.instance.updateTaskStatus(task.id, status);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.staffTaskUpdateError)));
    }
  }
}

class _StaffTaskCard extends StatelessWidget {
  const _StaffTaskCard({required this.task, required this.onStatusChanged});

  final HotelTask task;
  final ValueChanged<TaskStatus> onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strings = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    task.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(_priorityLabel(task.priority, strings)),
              ],
            ),
            const SizedBox(height: 8),
            Text(task.description.isEmpty ? task.location : task.description),
            const SizedBox(height: 8),
            Text(
              '${task.location} • ${strings.dueAt(_formatDate(task.dueAt))}',
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 190,
                child: DropdownButtonFormField<TaskStatus>(
                  initialValue: task.status,
                  decoration: InputDecoration(
                    labelText: strings.taskStatus,
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: TaskStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(_statusLabel(status, strings)),
                    );
                  }).toList(),
                  onChanged: (status) {
                    if (status != null && status != task.status) {
                      onStatusChanged(status);
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  const _MessageView({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

String _statusLabel(TaskStatus status, AppLocalizations strings) {
  return switch (status) {
    TaskStatus.pending => strings.pending,
    TaskStatus.inProgress => strings.inProgress,
    TaskStatus.completed => strings.completed,
  };
}

String _priorityLabel(TaskPriority priority, AppLocalizations strings) {
  return switch (priority) {
    TaskPriority.low => strings.low,
    TaskPriority.medium => strings.medium,
    TaskPriority.high => strings.high,
    TaskPriority.urgent => strings.urgent,
  };
}

String _departmentLabel(String department, AppLocalizations strings) {
  return switch (department) {
    'Housekeeping' => strings.housekeeping,
    'Reception' => strings.reception,
    'Maintenance' => strings.maintenanceDepartment,
    'Food Service' => strings.foodService,
    _ => department,
  };
}

String _formatDate(DateTime date) {
  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '${date.month}/${date.day}/${date.year} • $hour:$minute';
}
