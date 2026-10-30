import 'package:flutter/material.dart';

import '../models/hotel_task.dart';
import '../models/staff_member.dart';
import '../l10n/app_localizations.dart';

class TaskFormDialog extends StatefulWidget {
  const TaskFormDialog({super.key, required this.staff, this.task});

  final List<StaffMember> staff;
  final HotelTask? task;

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _locationController;
  String? _selectedStaffId;

  TaskPriority _priority = TaskPriority.medium;
  late DateTime _dueAt;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    _locationController = TextEditingController(text: task?.location ?? '');
    _selectedStaffId = widget.staff.any((staff) => staff.id == task?.assigneeId)
        ? task?.assigneeId
        : widget.staff.first.id;
    _priority = task?.priority ?? TaskPriority.medium;
    _dueAt = task?.dueAt ?? DateTime.now().add(const Duration(hours: 2));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        widget.task == null
            ? strings.taskFormCreateTitle
            : strings.taskFormEditTitle,
      ),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: strings.taskTitleLabel,
                    hintText: strings.taskTitleHint,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? strings.taskTitleRequired
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: strings.instructionsOptional,
                    hintText: strings.instructionsHint,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: strings.roomOrArea,
                    hintText: strings.roomOrAreaHint,
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? strings.locationRequired
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _selectedStaffId,
                  decoration: InputDecoration(labelText: strings.assignedStaff),
                  items: widget.staff.map((staff) {
                    return DropdownMenuItem(
                      value: staff.id,
                      child: Text(
                        '${staff.name} • ${_departmentLabel(staff.department, strings)}',
                      ),
                    );
                  }).toList(),
                  onChanged: (staffId) {
                    if (staffId != null) {
                      setState(() => _selectedStaffId = staffId);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<TaskPriority>(
                  initialValue: _priority,
                  decoration: InputDecoration(labelText: strings.taskPriority),
                  items: TaskPriority.values.map((priority) {
                    return DropdownMenuItem(
                      value: priority,
                      child: Text(_priorityLabel(priority, strings)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => _priority = value);
                  },
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: OutlinedButton.icon(
                    onPressed: _chooseDeadline,
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(
                      strings.dueLabel(
                        '${_dueAt.month}/${_dueAt.day} '
                        '${_dueAt.hour.toString().padLeft(2, '0')}:'
                        '${_dueAt.minute.toString().padLeft(2, '0')}',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(strings.cancel),
        ),
        FilledButton(
          onPressed: _save,
          child: Text(
            widget.task == null ? strings.createTask : strings.saveChanges,
          ),
        ),
      ],
    );
  }

  Future<void> _chooseDeadline() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _dueAt,
      firstDate: DateTime(2000),
      lastDate: _dueAt.isAfter(DateTime.now().add(const Duration(days: 365)))
          ? _dueAt
          : DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_dueAt),
    );
    if (time == null || !mounted) return;

    setState(() {
      _dueAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final selectedStaff = widget.staff.firstWhere(
      (staff) => staff.id == _selectedStaffId,
    );

    Navigator.pop(
      context,
      HotelTask(
        id: widget.task?.id ?? '',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        createdAt: widget.task?.createdAt ?? DateTime.now(),
        location: _locationController.text.trim(),
        assigneeId: selectedStaff.id,
        assigneeUid: selectedStaff.authUid,
        assigneeName: selectedStaff.name,
        priority: _priority,
        status: widget.task?.status ?? TaskStatus.pending,
        dueAt: _dueAt,
      ),
    );
  }
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
