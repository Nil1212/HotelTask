enum TaskStatus { pending, inProgress, completed }

enum TaskPriority { low, medium, high, urgent }

class HotelTask {
  HotelTask({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.location,
    required this.assigneeId,
    this.assigneeUid,
    required this.assigneeName,
    required this.priority,
    required this.status,
    required this.dueAt,
  });

  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String location;
  final String assigneeId;

  /// Firebase Authentication UID of the assigned staff member, when linked.
  final String? assigneeUid;
  final String assigneeName;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime dueAt;

  HotelTask copyWith({
    String? title,
    String? description,
    String? location,
    String? assigneeId,
    String? assigneeUid,
    String? assigneeName,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? dueAt,
  }) {
    return HotelTask(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      location: location ?? this.location,
      assigneeId: assigneeId ?? this.assigneeId,
      assigneeUid: assigneeUid ?? this.assigneeUid,
      assigneeName: assigneeName ?? this.assigneeName,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      dueAt: dueAt ?? this.dueAt,
    );
  }
}
