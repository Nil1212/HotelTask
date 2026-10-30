import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/hotel_task.dart';
import '../models/staff_member.dart';
import '../widgets/dashboard_widgets.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key, required this.tasks, required this.staff});

  final List<HotelTask> tasks;
  final List<StaffMember> staff;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context)!;
    final statusCounts = <TaskStatus, int>{
      for (final status in TaskStatus.values)
        status: tasks.where((task) => task.status == status).length,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 36),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.reportsTitle,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                strings.reportsDescription,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              SummaryGrid(tasks: tasks),
              const SizedBox(height: 24),
              LayoutBuilder(
                builder: (context, constraints) {
                  final stack = constraints.maxWidth < 760;
                  final statusCard = _StatusReport(
                    counts: statusCounts,
                    total: tasks.length,
                    strings: AppLocalizations.of(context)!,
                  );
                  final staffCard = _StaffReport(
                    tasks: tasks,
                    staff: staff,
                    strings: AppLocalizations.of(context)!,
                  );

                  if (stack) {
                    return Column(
                      children: [
                        statusCard,
                        const SizedBox(height: 16),
                        staffCard,
                      ],
                    );
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: statusCard),
                      const SizedBox(width: 16),
                      Expanded(child: staffCard),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusReport extends StatelessWidget {
  const _StatusReport({
    required this.counts,
    required this.total,
    required this.strings,
  });

  final Map<TaskStatus, int> counts;
  final int total;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return _ReportCard(
      title: strings.tasksByStatus,
      child: Column(
        children: TaskStatus.values.map((status) {
          final count = counts[status] ?? 0;
          final fraction = total == 0 ? 0.0 : count / total;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: Text(_statusLabel(status, strings))),
                    Text('$count'),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: fraction,
                  color: _statusColor(status),
                  backgroundColor: _statusColor(status).withValues(alpha: 0.14),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StaffReport extends StatelessWidget {
  const _StaffReport({
    required this.tasks,
    required this.staff,
    required this.strings,
  });

  final List<HotelTask> tasks;
  final List<StaffMember> staff;
  final AppLocalizations strings;

  @override
  Widget build(BuildContext context) {
    return _ReportCard(
      title: strings.tasksByStaff,
      child: staff.isEmpty
          ? Text(strings.noStaffAdded)
          : Column(
              children: staff.map((member) {
                final assigned = tasks
                    .where((task) => task.assigneeId == member.id)
                    .toList();
                final completed = assigned
                    .where((task) => task.status == TaskStatus.completed)
                    .length;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(member.name),
                  subtitle: Text(
                    '${_departmentLabel(member.department, strings)} • ${strings.completedOfTotal(completed, assigned.length)}',
                  ),
                  trailing: CircleAvatar(child: Text('${assigned.length}')),
                );
              }).toList(),
            ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 14),
            child,
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

String _departmentLabel(String department, AppLocalizations strings) {
  return switch (department) {
    'Housekeeping' => strings.housekeeping,
    'Reception' => strings.reception,
    'Maintenance' => strings.maintenanceDepartment,
    'Food Service' => strings.foodService,
    _ => department,
  };
}

Color _statusColor(TaskStatus status) {
  return switch (status) {
    TaskStatus.pending => const Color(0xFFEF9D16),
    TaskStatus.inProgress => const Color(0xFF079EBD),
    TaskStatus.completed => const Color(0xFF13A879),
  };
}
