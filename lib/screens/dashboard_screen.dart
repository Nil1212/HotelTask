import 'dart:async';

import 'package:flutter/material.dart';

import '../data/sample_staff.dart';
import '../data/sample_tasks.dart';
import '../models/hotel_task.dart';
import '../models/staff_member.dart';
import '../l10n/app_localizations.dart';
import '../services/staff_service.dart';
import '../services/task_service.dart';
import 'staff_screen.dart';
import 'reports_screen.dart';
import 'rooms_screen.dart';
import '../widgets/app_sidebar.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/dashboard_widgets.dart';
import '../widgets/task_form_dialog.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({
    super.key,
    required this.userEmail,
    required this.onSignOut,
    required this.isDarkMode,
    required this.onToggleTheme,
    required this.locale,
    required this.onLocaleChanged,
    this.isReadOnlyDemo = false,
  });

  final String userEmail;
  final VoidCallback onSignOut;
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  final Locale locale;
  final ValueChanged<Locale> onLocaleChanged;
  final bool isReadOnlyDemo;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final Stream<List<StaffMember>> _staffStream;
  late final Stream<List<HotelTask>> _taskStream;

  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  String _selectedPriorityFilter = 'all';
  String _selectedStaffFilter = 'all';
  String _selectedSort = 'deadline';
  int _selectedPage = 0;

  @override
  void initState() {
    super.initState();
    _staffStream = widget.isReadOnlyDemo
        ? Stream.value(sampleStaff)
        : StaffService.instance.watchStaff();
    _taskStream = widget.isReadOnlyDemo
        ? Stream.value(sampleTasks())
        : TaskService.instance.watchTasks();
  }

  List<HotelTask> _visibleTasks(List<HotelTask> tasks) {
    final query = _searchController.text.trim().toLowerCase();

    final visibleTasks = tasks.where((task) {
      final matchesSearch =
          task.title.toLowerCase().contains(query) ||
          task.location.toLowerCase().contains(query) ||
          task.assigneeName.toLowerCase().contains(query);
      final matchesFilter = switch (_selectedFilter) {
        'pending' => task.status == TaskStatus.pending,
        'inProgress' => task.status == TaskStatus.inProgress,
        'completed' => task.status == TaskStatus.completed,
        _ => true,
      };
      final matchesPriority =
          _selectedPriorityFilter == 'all' ||
          task.priority.name == _selectedPriorityFilter;
      final matchesStaff =
          _selectedStaffFilter == 'all' ||
          task.assigneeName == _selectedStaffFilter;
      return matchesSearch && matchesFilter && matchesPriority && matchesStaff;
    }).toList();

    if (_selectedSort == 'deadline') {
      visibleTasks.sort((a, b) => a.dueAt.compareTo(b.dueAt));
    } else {
      visibleTasks.sort((a, b) {
        final priorityOrder = _priorityRank(
          b.priority,
        ).compareTo(_priorityRank(a.priority));
        return priorityOrder != 0 ? priorityOrder : a.dueAt.compareTo(b.dueAt);
      });
    }

    return visibleTasks;
  }

  String _priorityLabel(TaskPriority priority, AppLocalizations strings) {
    return switch (priority) {
      TaskPriority.low => strings.low,
      TaskPriority.medium => strings.medium,
      TaskPriority.high => strings.high,
      TaskPriority.urgent => strings.urgent,
    };
  }

  int _priorityRank(TaskPriority priority) {
    return switch (priority) {
      TaskPriority.low => 1,
      TaskPriority.medium => 2,
      TaskPriority.high => 3,
      TaskPriority.urgent => 4,
    };
  }

  List<String> _staffNames(List<StaffMember> staff) {
    final names = staff.map((member) => member.name).toList()..sort();
    return names;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 900;
          return Row(
            children: [
              if (!compact)
                AppSidebar(
                  selectedPage: _selectedPage,
                  onPageSelected: (page) =>
                      setState(() => _selectedPage = page),
                  onLogout: widget.onSignOut,
                  isReadOnlyDemo: widget.isReadOnlyDemo,
                ),
              Expanded(
                child: Column(
                  children: [
                    AppTopBar(
                      compact: compact,
                      userEmail: widget.userEmail,
                      onSignOut: widget.onSignOut,
                      isDarkMode: widget.isDarkMode,
                      onThemeToggle: widget.onToggleTheme,
                      locale: widget.locale,
                      onLocaleChanged: widget.onLocaleChanged,
                      isReadOnlyDemo: widget.isReadOnlyDemo,
                      onMenuPressed: compact
                          ? () => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(strings.mobileNavigationHint),
                              ),
                            )
                          : null,
                    ),
                    if (widget.isReadOnlyDemo)
                      Container(
                        width: double.infinity,
                        color: Theme.of(context).colorScheme.primaryContainer,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              size: 18,
                              color: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                strings.readOnlyDemoNotice,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: widget.onSignOut,
                              child: Text(strings.exitDemo),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: StreamBuilder<List<StaffMember>>(
                        stream: _staffStream,
                        builder: (context, staffSnapshot) {
                          if (staffSnapshot.hasError) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  strings.staffMessageError,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          }
                          if (staffSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final staff =
                              staffSnapshot.data ?? const <StaffMember>[];
                          return StreamBuilder<List<HotelTask>>(
                            stream: _taskStream,
                            builder: (context, taskSnapshot) {
                              if (taskSnapshot.hasError) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Text(
                                      strings.tasksMessageError,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              if (taskSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              final tasks =
                                  taskSnapshot.data ?? const <HotelTask>[];
                              return switch (_selectedPage) {
                                0 => _buildContent(
                                  context,
                                  compact,
                                  staff,
                                  tasks,
                                ),
                                1 => _buildContent(
                                  context,
                                  compact,
                                  staff,
                                  tasks,
                                ),
                                2 => StaffScreen(
                                  staff: staff,
                                  tasks: tasks,
                                  onAddStaff: StaffService.instance.addStaff,
                                  onUpdateStaff:
                                      StaffService.instance.updateStaff,
                                  isReadOnlyDemo: widget.isReadOnlyDemo,
                                ),
                                3 => RoomsScreen(
                                  isReadOnlyDemo: widget.isReadOnlyDemo,
                                ),
                                _ => ReportsScreen(tasks: tasks, staff: staff),
                              };
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: MediaQuery.sizeOf(context).width < 900
          ? NavigationBar(
              selectedIndex: _selectedPage,
              onDestinationSelected: (page) =>
                  setState(() => _selectedPage = page),
              destinations: [
                NavigationDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  label: strings.home,
                ),
                NavigationDestination(
                  icon: Icon(Icons.task_alt_outlined),
                  label: strings.tasks,
                ),
                NavigationDestination(
                  icon: Icon(Icons.groups_outlined),
                  label: strings.staff,
                ),
                NavigationDestination(
                  icon: Icon(Icons.meeting_room_outlined),
                  label: strings.rooms,
                ),
                NavigationDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  label: strings.reports,
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildContent(
    BuildContext context,
    bool compact,
    List<StaffMember> staff,
    List<HotelTask> tasks,
  ) {
    final strings = AppLocalizations.of(context)!;
    final horizontalPadding = compact ? 20.0 : 36.0;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        30,
        horizontalPadding,
        36,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1440),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PageHeading(
                title: _selectedPage == 1 ? strings.tasks : strings.dashboard,
                description: _selectedPage == 1
                    ? strings.tasksDescription
                    : strings.dashboardDescription,
                onCreateTask: widget.isReadOnlyDemo
                    ? null
                    : () => _showTaskForm(context, staff),
                compact: compact,
              ),
              if (_selectedPage == 0) ...[
                const SizedBox(height: 28),
                SummaryGrid(tasks: tasks),
                const SizedBox(height: 30),
              ] else
                const SizedBox(height: 22),
              _taskListSection(context, compact, staff, tasks),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskListSection(
    BuildContext context,
    bool compact,
    List<StaffMember> staff,
    List<HotelTask> tasks,
  ) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080B1630),
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 20, 22, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedPage == 1
                                ? strings.allTasks
                                : strings.recentTasks,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            _selectedPage == 1
                                ? strings.manageAssignments
                                : strings.trackHotelOperations,
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_selectedPage == 0)
                      TextButton(
                        onPressed: () => setState(() => _selectedPage = 1),
                        child: Text(strings.viewAll),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: compact ? double.infinity : 310,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          hintText: strings.searchTasks,
                          prefixIcon: const Icon(Icons.search),
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: compact ? double.infinity : 170,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedFilter,
                        decoration: InputDecoration(
                          labelText: strings.status,
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text(strings.allStatuses),
                          ),
                          DropdownMenuItem(
                            value: 'pending',
                            child: Text(strings.pending),
                          ),
                          DropdownMenuItem(
                            value: 'inProgress',
                            child: Text(strings.inProgress),
                          ),
                          DropdownMenuItem(
                            value: 'completed',
                            child: Text(strings.completed),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedFilter = value);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: compact ? double.infinity : 160,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedPriorityFilter,
                        decoration: InputDecoration(
                          labelText: strings.priority,
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text(strings.allPriorities),
                          ),
                          ...TaskPriority.values.map(
                            (priority) => DropdownMenuItem(
                              value: priority.name,
                              child: Text(_priorityLabel(priority, strings)),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedPriorityFilter = value);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: compact ? double.infinity : 190,
                      child: DropdownButtonFormField<String>(
                        initialValue:
                            _selectedStaffFilter == 'all' ||
                                _staffNames(
                                  staff,
                                ).contains(_selectedStaffFilter)
                            ? _selectedStaffFilter
                            : 'all',
                        decoration: InputDecoration(
                          labelText: strings.assignedStaff,
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text(strings.allStaff),
                          ),
                          ..._staffNames(staff).map(
                            (name) => DropdownMenuItem(
                              value: name,
                              child: Text(name),
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedStaffFilter = value);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: compact ? double.infinity : 190,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedSort,
                        decoration: InputDecoration(
                          labelText: strings.sortBy,
                          filled: true,
                          fillColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(11),
                            borderSide: BorderSide(
                              color: Theme.of(
                                context,
                              ).colorScheme.outlineVariant,
                            ),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: 'deadline',
                            child: Text(strings.deadline),
                          ),
                          DropdownMenuItem(
                            value: 'priority',
                            child: Text(strings.prioritySort),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedSort = value);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          if (compact)
            _mobileTaskList(_visibleTasks(tasks), staff)
          else
            _desktopTaskTable(_visibleTasks(tasks), staff),
        ],
      ),
    );
  }

  Widget _desktopTaskTable(List<HotelTask> tasks, List<StaffMember> staff) {
    final strings = AppLocalizations.of(context)!;
    if (tasks.isEmpty) {
      return const EmptyTasks();
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 24,
        horizontalMargin: 22,
        headingRowHeight: 48,
        dataRowMinHeight: 66,
        dataRowMaxHeight: 66,
        columns: [
          DataColumn(label: Text(strings.taskColumn)),
          DataColumn(label: Text(strings.locationColumn)),
          DataColumn(label: Text(strings.assignedToColumn)),
          DataColumn(label: Text(strings.priorityColumn)),
          DataColumn(label: Text(strings.statusColumn)),
          DataColumn(label: Text(strings.dueDateColumn)),
          DataColumn(label: Text('')),
        ],
        rows: tasks.map((task) {
          return DataRow(
            cells: [
              DataCell(
                SizedBox(
                  width: 170,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.checklist_rounded,
                        color: Color(0xFF7865F5),
                        size: 19,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          task.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              DataCell(Text(task.location)),
              DataCell(
                SizedBox(width: 150, child: Assignee(name: task.assigneeName)),
              ),
              DataCell(PriorityBadge(priority: task.priority)),
              DataCell(
                StatusBadge(
                  status: task.status,
                  onTap: widget.isReadOnlyDemo
                      ? null
                      : () => _cycleStatus(task),
                ),
              ),
              DataCell(Text(_formatDue(task.dueAt))),
              DataCell(
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onSelected: (value) {
                    if (value == 'details') _showTaskDetails(task);
                    if (!widget.isReadOnlyDemo && value == 'status') {
                      _cycleStatus(task);
                    }
                    if (!widget.isReadOnlyDemo && value == 'edit') {
                      _editTask(task, staff);
                    }
                    if (!widget.isReadOnlyDemo && value == 'delete') {
                      _confirmDelete(task);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'details',
                      child: Text(strings.viewDetails),
                    ),
                    if (!widget.isReadOnlyDemo) ...[
                      PopupMenuItem(
                        value: 'status',
                        child: Text(strings.changeStatus),
                      ),
                      PopupMenuItem(
                        value: 'edit',
                        child: Text(strings.editTask),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text(strings.deleteTask),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _mobileTaskList(List<HotelTask> tasks, List<StaffMember> staff) {
    final strings = AppLocalizations.of(context)!;
    if (tasks.isEmpty) return const EmptyTasks();

    return Column(
      children: tasks.map((task) {
        return Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${task.location} • ${task.assigneeName}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      strings.dueAt(_formatDue(task.dueAt)),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 14,
                      runSpacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        PriorityBadge(priority: task.priority),
                        StatusBadge(
                          status: task.status,
                          onTap: widget.isReadOnlyDemo
                              ? null
                              : () => _cycleStatus(task),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'details') _showTaskDetails(task);
                  if (!widget.isReadOnlyDemo && value == 'status') {
                    _cycleStatus(task);
                  }
                  if (!widget.isReadOnlyDemo && value == 'edit') {
                    _editTask(task, staff);
                  }
                  if (!widget.isReadOnlyDemo && value == 'delete') {
                    _confirmDelete(task);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'details',
                    child: Text(strings.viewDetails),
                  ),
                  if (!widget.isReadOnlyDemo) ...[
                    PopupMenuItem(
                      value: 'status',
                      child: Text(strings.changeStatus),
                    ),
                    PopupMenuItem(value: 'edit', child: Text(strings.editTask)),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(strings.deleteTask),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Future<void> _cycleStatus(HotelTask task) async {
    if (widget.isReadOnlyDemo) return;
    final statusError = AppLocalizations.of(context)!.taskStatusError;
    final nextStatus = switch (task.status) {
      TaskStatus.pending => TaskStatus.inProgress,
      TaskStatus.inProgress => TaskStatus.completed,
      TaskStatus.completed => TaskStatus.pending,
    };
    try {
      await TaskService.instance.updateTaskStatus(task.id, nextStatus);
    } catch (_) {
      _showTaskError(statusError);
    }
  }

  Future<void> _confirmDelete(HotelTask task) async {
    if (widget.isReadOnlyDemo) return;
    final strings = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(strings.deleteTaskQuestion),
        content: Text(strings.removeTaskConfirmation(task.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(strings.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(strings.delete),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      try {
        await TaskService.instance.deleteTask(task.id);
        if (!mounted) return;
        messenger.showSnackBar(SnackBar(content: Text(strings.taskDeleted)));
      } catch (_) {
        _showTaskError(strings.taskDeleteError);
      }
    }
  }

  Future<void> _showTaskForm(
    BuildContext context,
    List<StaffMember> staff,
  ) async {
    if (widget.isReadOnlyDemo) return;
    final strings = AppLocalizations.of(context)!;
    if (staff.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.addStaffBeforeTask)));
      return;
    }
    final result = await showDialog<HotelTask>(
      context: context,
      builder: (context) => TaskFormDialog(staff: staff),
    );

    if (result != null && mounted) {
      try {
        await TaskService.instance.addTask(result);
        if (!context.mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.taskCreated)));
      } catch (_) {
        _showTaskError(strings.taskCreateError);
      }
    }
  }

  Future<void> _showTaskDetails(HotelTask task) async {
    final strings = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task.title),
          content: SizedBox(
            width: 420,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.taskInstructions,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    task.description.trim().isEmpty
                        ? strings.noInstructions
                        : task.description,
                  ),
                  const Divider(height: 28),
                  _detailRow(strings.taskId, '#${task.id}'),
                  _detailRow(strings.locationColumn, task.location),
                  _detailRow(strings.assignedTo, task.assigneeName),
                  _detailRow(
                    strings.priority,
                    _priorityLabel(task.priority, strings),
                  ),
                  _detailRow(
                    strings.status,
                    _statusLabel(task.status, strings),
                  ),
                  _detailRow(strings.created, _formatCreatedAt(task.createdAt)),
                  _detailRow(strings.deadlineLabel, _formatDue(task.dueAt)),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(strings.close),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: TextStyle(
                color: colors.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _statusLabel(TaskStatus status, AppLocalizations strings) {
    return switch (status) {
      TaskStatus.pending => strings.pending,
      TaskStatus.inProgress => strings.inProgress,
      TaskStatus.completed => strings.completed,
    };
  }

  Future<void> _editTask(HotelTask task, List<StaffMember> staff) async {
    if (widget.isReadOnlyDemo) return;
    final strings = AppLocalizations.of(context)!;
    if (staff.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.addStaffBeforeEdit)));
      return;
    }
    final result = await showDialog<HotelTask>(
      context: context,
      builder: (context) => TaskFormDialog(staff: staff, task: task),
    );

    if (result != null && mounted) {
      try {
        await TaskService.instance.updateTask(result);
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(strings.taskUpdated)));
      } catch (_) {
        _showTaskError(strings.taskUpdateError);
      }
    }
  }

  void _showTaskError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatCreatedAt(DateTime date) {
    final localDate = date.toLocal();
    final time =
        '${localDate.hour.toString().padLeft(2, '0')}:${localDate.minute.toString().padLeft(2, '0')}';
    return '${localDate.month}/${localDate.day}/${localDate.year} • $time';
  }

  String _formatDue(DateTime date) {
    final strings = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final difference = date.difference(now);
    final time =
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    if (difference.inMinutes < 0) return '${strings.dueOverdue} • $time';
    if (difference.inHours < 24) return '${strings.dueToday} • $time';
    return '${date.month}/${date.day} • $time';
  }
}
