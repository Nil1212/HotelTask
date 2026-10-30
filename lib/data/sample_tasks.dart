import '../models/hotel_task.dart';

List<HotelTask> sampleTasks() {
  return [
    HotelTask(
      id: '1048',
      title: 'Prepare guest room',
      description:
          'Make the bed, replace used linens, and check that the room is ready for the next guest.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      location: 'Room 204',
      assigneeId: 'staff_maya_chen',
      assigneeName: 'Maya Chen',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueAt: DateTime.now().add(const Duration(hours: 1)),
    ),
    HotelTask(
      id: '1047',
      title: 'Restock toiletries',
      description:
          'Refill shampoo, soap, and other guest toiletries in the bathroom.',
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      location: 'Room 108',
      assigneeId: 'staff_daniel_kim',
      assigneeName: 'Daniel Kim',
      priority: TaskPriority.medium,
      status: TaskStatus.pending,
      dueAt: DateTime.now().add(const Duration(hours: 3)),
    ),
    HotelTask(
      id: '1046',
      title: 'Inspect air conditioning',
      description:
          'Check the air conditioner and report any unusual noise or cooling problems.',
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      location: 'Room 312',
      assigneeId: 'staff_alex_morgan',
      assigneeName: 'Alex Morgan',
      priority: TaskPriority.urgent,
      status: TaskStatus.pending,
      dueAt: DateTime.now().subtract(const Duration(minutes: 20)),
    ),
    HotelTask(
      id: '1045',
      title: 'Clean lobby entrance',
      description:
          'Sweep and mop the entrance, then make sure the area is tidy.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      location: 'Main lobby',
      assigneeId: 'staff_sofia_patel',
      assigneeName: 'Sofia Patel',
      priority: TaskPriority.low,
      status: TaskStatus.completed,
      dueAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    HotelTask(
      id: '1044',
      title: 'Replace bed linen',
      description: 'Replace sheets and pillowcases with fresh linen.',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      location: 'Room 201',
      assigneeId: 'staff_maya_chen',
      assigneeName: 'Maya Chen',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      dueAt: DateTime.now().add(const Duration(hours: 2)),
    ),
  ];
}
