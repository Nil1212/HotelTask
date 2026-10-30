import 'package:flutter/material.dart';

import '../models/hotel_task.dart';
import '../models/staff_member.dart';
import '../l10n/app_localizations.dart';
import '../widgets/staff_form_dialog.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({
    super.key,
    required this.staff,
    required this.tasks,
    required this.onAddStaff,
    required this.onUpdateStaff,
    this.isReadOnlyDemo = false,
  });

  final List<StaffMember> staff;
  final List<HotelTask> tasks;
  final Future<void> Function(StaffMember) onAddStaff;
  final Future<void> Function(StaffMember) onUpdateStaff;
  final bool isReadOnlyDemo;

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  String _departmentFilter = 'all';
  bool _isSaving = false;

  List<StaffMember> get _visibleStaff {
    if (_departmentFilter == 'all') return widget.staff;
    return widget.staff
        .where((member) => member.department == _departmentFilter)
        .toList();
  }

  int _taskCountFor(StaffMember member) =>
      widget.tasks.where((task) => task.assigneeId == member.id).length;

  Future<void> _showStaffForm([StaffMember? member]) async {
    if (widget.isReadOnlyDemo) return;
    final result = await showDialog<StaffMember>(
      context: context,
      builder: (context) => StaffFormDialog(staff: member),
    );
    if (result == null || !mounted) return;
    final strings = AppLocalizations.of(context)!;

    setState(() => _isSaving = true);
    try {
      if (member == null) {
        await widget.onAddStaff(result);
      } else {
        await widget.onUpdateStaff(result);
      }
      if (!mounted) return;
      setState(() => _departmentFilter = 'all');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            member == null ? strings.staffAdded : strings.staffUpdated,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.staffSaveError)));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context)!;
    final departments =
        widget.staff.map((member) => member.department).toSet().toList()
          ..sort();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 30, 24, 36),
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final heading = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.staffMembersTitle,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        strings.staffDescription,
                        style: TextStyle(color: colors.onSurfaceVariant),
                      ),
                    ],
                  );
                  final addButton = FilledButton.icon(
                    onPressed: _isSaving ? null : () => _showStaffForm(),
                    icon: const Icon(Icons.person_add_alt_1),
                    label: Text(strings.addStaff),
                  );

                  if (constraints.maxWidth < 560) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heading,
                        if (!widget.isReadOnlyDemo) ...[
                          const SizedBox(height: 14),
                          addButton,
                        ],
                      ],
                    );
                  }

                  return Row(
                    children: [
                      Expanded(child: heading),
                      if (!widget.isReadOnlyDemo) addButton,
                    ],
                  );
                },
              ),
              if (_isSaving) const LinearProgressIndicator(),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: colors.outlineVariant),
                    ),
                    child: Text(
                      strings.totalStaff(widget.staff.length),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    width: 230,
                    child: DropdownButtonFormField<String>(
                      initialValue: _departmentFilter,
                      decoration: InputDecoration(
                        labelText: strings.department,
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'all',
                          child: Text(strings.allDepartments),
                        ),
                        ...departments.map(
                          (department) => DropdownMenuItem(
                            value: department,
                            child: Text(_departmentLabel(department, strings)),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _departmentFilter = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (_visibleStaff.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(strings.noStaffInDepartment),
                  ),
                )
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 850
                        ? 3
                        : constraints.maxWidth >= 560
                        ? 2
                        : 1;
                    final cardWidth =
                        (constraints.maxWidth - (columns - 1) * 16) / columns;
                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: _visibleStaff.map((member) {
                        return SizedBox(
                          width: cardWidth,
                          child: _StaffCard(
                            member: member,
                            taskCount: _taskCountFor(member),
                            onEdit: widget.isReadOnlyDemo
                                ? null
                                : () => _showStaffForm(member),
                          ),
                        );
                      }).toList(),
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

class _StaffCard extends StatelessWidget {
  const _StaffCard({
    required this.member,
    required this.taskCount,
    required this.onEdit,
  });

  final StaffMember member;
  final int taskCount;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final strings = AppLocalizations.of(context)!;
    final initials = member.name
        .split(' ')
        .map((part) => part[0])
        .take(2)
        .join();

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
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: colors.primaryContainer,
                  foregroundColor: colors.onPrimaryContainer,
                  child: Text(initials),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    member.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (onEdit != null)
                  IconButton(
                    tooltip: strings.editStaffTooltip,
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                  ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              _departmentLabel(member.department, strings),
              style: TextStyle(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.task_alt_outlined, size: 18, color: colors.primary),
                const SizedBox(width: 8),
                Text(
                  strings.assignedTaskCount(
                    taskCount,
                    taskCount == 1
                        ? strings.assignedTaskSingular
                        : strings.assignedTaskPlural,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
