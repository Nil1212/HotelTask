import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/hotel_task.dart';

class TaskService {
  TaskService._();

  static final TaskService instance = TaskService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _taskCollection =>
      _firestore.collection('tasks');

  Stream<List<HotelTask>> watchTasks() {
    return _taskCollection.snapshots().map(_tasksFromSnapshot);
  }

  Stream<List<HotelTask>> watchAssignedTasks(String uid) {
    return _taskCollection
        .where('assigneeUid', isEqualTo: uid)
        .snapshots()
        .map(_tasksFromSnapshot);
  }

  List<HotelTask> _tasksFromSnapshot(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs.map((document) {
      final data = document.data();
      return HotelTask(
        id: document.id,
        title: data['title'] as String? ?? 'Untitled task',
        description: data['description'] as String? ?? '',
        createdAt: _readDate(data['createdAt']),
        location: data['location'] as String? ?? 'Unspecified area',
        assigneeId: data['assigneeId'] as String? ?? '',
        assigneeUid: data['assigneeUid'] as String?,
        assigneeName: data['assigneeName'] as String? ?? 'Unassigned',
        priority: _readPriority(data['priority']),
        status: _readStatus(data['status']),
        dueAt: _readDate(data['dueAt']),
      );
    }).toList();
  }

  Future<void> addTask(HotelTask task) async {
    await _taskCollection.add(_toMap(task));
  }

  Future<void> updateTask(HotelTask task) async {
    await _taskCollection.doc(task.id).set(_toMap(task));
  }

  Future<void> updateTaskStatus(String taskId, TaskStatus status) async {
    await _taskCollection.doc(taskId).update({'status': status.name});
  }

  Future<void> deleteTask(String taskId) async {
    await _taskCollection.doc(taskId).delete();
  }

  Map<String, dynamic> _toMap(HotelTask task) {
    return {
      'title': task.title,
      'description': task.description,
      'createdAt': Timestamp.fromDate(task.createdAt),
      'location': task.location,
      'assigneeId': task.assigneeId,
      'assigneeUid': task.assigneeUid,
      'assigneeName': task.assigneeName,
      'priority': task.priority.name,
      'status': task.status.name,
      'dueAt': Timestamp.fromDate(task.dueAt),
    };
  }

  DateTime _readDate(Object? value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return DateTime.now();
  }

  TaskPriority _readPriority(Object? value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.name == value,
      orElse: () => TaskPriority.medium,
    );
  }

  TaskStatus _readStatus(Object? value) {
    return TaskStatus.values.firstWhere(
      (status) => status.name == value,
      orElse: () => TaskStatus.pending,
    );
  }
}
