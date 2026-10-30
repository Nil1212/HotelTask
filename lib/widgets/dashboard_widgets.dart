import 'package:flutter/material.dart';

import '../models/hotel_task.dart';
import '../l10n/app_localizations.dart';

class PageHeading extends StatelessWidget {
  const PageHeading({
    super.key,
    required this.title,
    required this.description,
    required this.onCreateTask,
    required this.compact,
  });

  final String title;
  final String description;
  final VoidCallback? onCreateTask;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context)!;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      runSpacing: 16,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 27,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 13),
            ),
          ],
        ),
        if (onCreateTask != null)
          FilledButton.icon(
            onPressed: onCreateTask,
            icon: const Icon(Icons.add, size: 19),
            label: Text(strings.createTask),
            style: FilledButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: compact ? 16 : 20,
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
      ],
    );
  }
}

class SummaryGrid extends StatelessWidget {
  const SummaryGrid({super.key, required this.tasks});

  final List<HotelTask> tasks;

  @override
  Widget build(BuildContext context) {
    final counts = [
      tasks.length,
      tasks.where((task) => task.status == TaskStatus.pending).length,
      tasks.where((task) => task.status == TaskStatus.inProgress).length,
      tasks.where((task) => task.status == TaskStatus.completed).length,
      tasks
          .where(
            (task) =>
                task.status != TaskStatus.completed &&
                task.dueAt.isBefore(DateTime.now()),
          )
          .length,
    ];

    final strings = AppLocalizations.of(context)!;
    final summaries = [
      (strings.totalTasks, Icons.assignment_outlined, const Color(0xFF7058F5)),
      (strings.pending, Icons.schedule_rounded, const Color(0xFFEF9D16)),
      (strings.inProgress, Icons.autorenew_rounded, const Color(0xFF079EBD)),
      (strings.completed, Icons.task_alt_rounded, const Color(0xFF13A879)),
      (strings.overdue, Icons.warning_amber_rounded, const Color(0xFFEA5874)),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth < 600
            ? 1
            : constraints.maxWidth < 1050
            ? 2
            : 5;
        final gap = 14.0;
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: List.generate(summaries.length, (index) {
            final summary = summaries[index];
            return SizedBox(
              width: width,
              child: _SummaryCard(
                title: summary.$1,
                count: counts[index],
                icon: summary.$2,
                color: summary.$3,
              ),
            );
          }),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tint = color.withValues(alpha: isDark ? 0.13 : 0.075);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Color.alphaBlend(tint, colors.surface),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.28)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060B1630),
            blurRadius: 16,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.24 : 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 13),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: colors.onSurfaceVariant),
              ),
              const SizedBox(height: 4),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Assignee extends StatelessWidget {
  const Assignee({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final initials = name.split(' ').map((part) => part[0]).take(2).join();

    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: colors.surfaceContainerHighest,
          child: Text(
            initials,
            style: TextStyle(
              fontSize: 9,
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}

class PriorityBadge extends StatelessWidget {
  const PriorityBadge({super.key, required this.priority});

  final TaskPriority priority;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppLocalizations.of(context)!;
    final (label, color) = switch (priority) {
      TaskPriority.low => (
        strings.low,
        isDark ? const Color(0xFFAAB6CB) : const Color(0xFF68758C),
      ),
      TaskPriority.medium => (
        strings.medium,
        isDark ? const Color(0xFF82B8FF) : const Color(0xFF347EC5),
      ),
      TaskPriority.high => (
        strings.high,
        isDark ? const Color(0xFFFFD166) : const Color(0xFFC77B08),
      ),
      TaskPriority.urgent => (
        strings.urgent,
        isDark ? const Color(0xFFFF9AAC) : const Color(0xFFD84663),
      ),
    };

    return Text(
      label,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
    );
  }
}

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status, this.onTap});

  final TaskStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = AppLocalizations.of(context)!;
    final (label, foreground, background) = switch (status) {
      TaskStatus.pending => (
        strings.pending,
        isDark ? const Color(0xFFFFD166) : const Color(0xFF9B6500),
        isDark ? const Color(0xFF493814) : const Color(0xFFFFF1D2),
      ),
      TaskStatus.inProgress => (
        strings.inProgress,
        isDark ? const Color(0xFF78D2F0) : const Color(0xFF137A97),
        isDark ? const Color(0xFF17384A) : const Color(0xFFE0F6FA),
      ),
      TaskStatus.completed => (
        strings.completed,
        isDark ? const Color(0xFF68D7A4) : const Color(0xFF16845B),
        isDark ? const Color(0xFF173B2D) : const Color(0xFFDDF8ED),
      ),
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: foreground,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class EmptyTasks extends StatelessWidget {
  const EmptyTasks({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(38),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 34, color: colors.outline),
            const SizedBox(height: 10),
            Text(
              strings.noTasks,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              strings.adjustSearch,
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
