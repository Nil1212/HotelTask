import 'package:flutter/material.dart';

import '../models/staff_member.dart';
import '../l10n/app_localizations.dart';

class StaffFormDialog extends StatefulWidget {
  const StaffFormDialog({super.key, this.staff});

  final StaffMember? staff;

  @override
  State<StaffFormDialog> createState() => _StaffFormDialogState();
}

class _StaffFormDialogState extends State<StaffFormDialog> {
  static const _departments = [
    'Housekeeping',
    'Reception',
    'Maintenance',
    'Food Service',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _authUidController;
  late String _department;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.staff?.name ?? '');
    _authUidController = TextEditingController(
      text: widget.staff?.authUid ?? '',
    );
    _department = widget.staff?.department ?? _departments.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _authUidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(
        widget.staff == null ? strings.addStaffTitle : strings.editStaff,
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                autofocus: true,
                decoration: InputDecoration(labelText: strings.fullName),
                validator: (value) => value == null || value.trim().isEmpty
                    ? strings.staffNameRequired
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _authUidController,
                decoration: InputDecoration(
                  labelText: strings.firebaseUidOptional,
                  helperText: strings.firebaseUidHelp,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _department,
                decoration: InputDecoration(labelText: strings.department),
                items: _departments
                    .map(
                      (department) => DropdownMenuItem(
                        value: department,
                        child: Text(_departmentLabel(department, strings)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setState(() => _department = value);
                },
              ),
            ],
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
            widget.staff == null ? strings.addStaff : strings.saveChanges,
          ),
        ),
      ],
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final original = widget.staff;
    Navigator.pop(
      context,
      StaffMember(
        id: original?.id ?? 'staff_${DateTime.now().microsecondsSinceEpoch}',
        name: _nameController.text.trim(),
        department: _department,
        authUid: _authUidController.text.trim().isEmpty
            ? null
            : _authUidController.text.trim(),
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
