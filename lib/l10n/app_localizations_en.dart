// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'HotelTask';

  @override
  String get workspace => 'WORKSPACE';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get tasks => 'Tasks';

  @override
  String get staff => 'Staff';

  @override
  String get rooms => 'Rooms';

  @override
  String get reports => 'Reports';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get home => 'Home';

  @override
  String get accountMenu => 'Account menu';

  @override
  String get signedIn => 'Signed in';

  @override
  String get signOut => 'Sign out';

  @override
  String get changeLanguage => 'Change language';

  @override
  String get english => 'English';

  @override
  String get khmer => 'ខ្មែរ';

  @override
  String get switchToLight => 'Switch to light mode';

  @override
  String get switchToNight => 'Switch to night mode';

  @override
  String get notifications => 'Notifications';

  @override
  String get welcome => 'Welcome to HotelTask';

  @override
  String get signInSubtitle => 'Sign in to manage hotel tasks.';

  @override
  String get emailAddress => 'Email address';

  @override
  String get password => 'Password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get showPassword => 'Show password';

  @override
  String get signIn => 'Sign in';

  @override
  String get enterEmail => 'Enter your email address.';

  @override
  String get validEmail => 'Enter a valid email address.';

  @override
  String get enterPassword => 'Enter your password.';

  @override
  String get incorrectCredentials => 'The email or password is incorrect.';

  @override
  String get tooManyAttempts => 'Too many attempts. Please wait and try again.';

  @override
  String get checkConnection => 'Check your internet connection and try again.';

  @override
  String get genericSignInError => 'Sign-in failed. Please try again.';

  @override
  String get genericError => 'Something went wrong. Please try again.';

  @override
  String get dashboardDescription =>
      'Here is what is happening at your hotel today.';

  @override
  String get tasksDescription => 'Search, assign, and track hotel tasks.';

  @override
  String get createTask => 'Create task';

  @override
  String get totalTasks => 'Total tasks';

  @override
  String get pending => 'Pending';

  @override
  String get inProgress => 'In progress';

  @override
  String get completed => 'Completed';

  @override
  String get overdue => 'Overdue';

  @override
  String get recentTasks => 'Recent tasks';

  @override
  String get allTasks => 'All tasks';

  @override
  String get manageAssignments =>
      'Manage assignments, priorities, and deadlines';

  @override
  String get trackHotelOperations => 'Track and manage your hotel operations';

  @override
  String get viewAll => 'View all';

  @override
  String get searchTasks => 'Search tasks, rooms, or staff...';

  @override
  String get status => 'Status';

  @override
  String get allStatuses => 'All tasks';

  @override
  String get priority => 'Priority';

  @override
  String get allPriorities => 'All priorities';

  @override
  String get assignedStaff => 'Assigned staff';

  @override
  String get allStaff => 'All staff';

  @override
  String get sortBy => 'Sort by';

  @override
  String get deadline => 'Deadline';

  @override
  String get prioritySort => 'Priority';

  @override
  String get noTasks => 'No tasks found';

  @override
  String get adjustSearch => 'Try changing your search or filter.';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get urgent => 'Urgent';

  @override
  String get today => 'Today';

  @override
  String get taskColumn => 'TASK';

  @override
  String get locationColumn => 'LOCATION';

  @override
  String get assignedToColumn => 'ASSIGNED TO';

  @override
  String get priorityColumn => 'PRIORITY';

  @override
  String get statusColumn => 'STATUS';

  @override
  String get dueDateColumn => 'DUE DATE';

  @override
  String get viewDetails => 'View details';

  @override
  String get changeStatus => 'Change status';

  @override
  String get editTask => 'Edit task';

  @override
  String get deleteTask => 'Delete task';

  @override
  String get deleteTaskQuestion => 'Delete task?';

  @override
  String removeTaskConfirmation(String title) {
    return 'Remove \"$title\" from the task list?';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get taskDeleted => 'Task deleted';

  @override
  String get taskCreated => 'Task created successfully';

  @override
  String get taskUpdated => 'Task updated successfully';

  @override
  String get taskCreateError => 'Could not save the task. Please try again.';

  @override
  String get taskUpdateError => 'Could not update the task. Please try again.';

  @override
  String get taskDeleteError => 'Could not delete the task. Please try again.';

  @override
  String get taskStatusError =>
      'Could not update the task status. Please try again.';

  @override
  String get addStaffBeforeTask => 'Add a staff member before creating a task.';

  @override
  String get addStaffBeforeEdit =>
      'Add a staff member before editing task assignments.';

  @override
  String get taskFormCreateTitle => 'Create a task';

  @override
  String get taskFormEditTitle => 'Edit task';

  @override
  String get taskTitleLabel => 'Task title';

  @override
  String get taskTitleHint => 'For example: Clean guest room';

  @override
  String get instructionsOptional => 'Instructions (optional)';

  @override
  String get instructionsHint => 'Add details to help staff complete this task';

  @override
  String get roomOrArea => 'Room or area';

  @override
  String get roomOrAreaHint => 'For example: Room 101 or Main lobby';

  @override
  String get taskPriority => 'Priority';

  @override
  String dueLabel(String date) {
    return 'Due $date';
  }

  @override
  String get saveChanges => 'Save changes';

  @override
  String get taskTitleRequired => 'Enter a task title';

  @override
  String get locationRequired => 'Enter a room or hotel area';

  @override
  String get taskInstructions => 'Instructions';

  @override
  String get noInstructions => 'No instructions have been added.';

  @override
  String get taskId => 'Task ID';

  @override
  String get assignedTo => 'Assigned to';

  @override
  String get created => 'Created';

  @override
  String get deadlineLabel => 'Deadline';

  @override
  String get staffMembersTitle => 'Staff members';

  @override
  String get staffDescription =>
      'View hotel staff and the tasks assigned to each person.';

  @override
  String get addStaff => 'Add staff';

  @override
  String get editStaff => 'Edit staff member';

  @override
  String get addStaffTitle => 'Add staff member';

  @override
  String get saveStaff => 'Save changes';

  @override
  String get fullName => 'Full name';

  @override
  String get firebaseUidOptional => 'Firebase Auth UID (optional)';

  @override
  String get firebaseUidHelp => 'Link this staff record to a Firebase account.';

  @override
  String get department => 'Department';

  @override
  String get allDepartments => 'All departments';

  @override
  String get noStaffInDepartment => 'No staff members in this department.';

  @override
  String get staffAdded => 'Staff member added';

  @override
  String get staffUpdated => 'Staff member updated';

  @override
  String get staffSaveError =>
      'Could not save staff. Check your connection and try again.';

  @override
  String get editStaffTooltip => 'Edit staff member';

  @override
  String totalStaff(int count) {
    return 'Total staff: $count';
  }

  @override
  String assignedTaskCount(int count, String taskWord) {
    return '$count $taskWord';
  }

  @override
  String get reportsTitle => 'Reports';

  @override
  String get reportsDescription => 'A live overview of hotel task progress.';

  @override
  String get tasksByStatus => 'Tasks by status';

  @override
  String get tasksByStaff => 'Tasks by staff member';

  @override
  String get noStaffAdded => 'No staff members have been added yet.';

  @override
  String completedOfTotal(int completed, int total) {
    return '$completed of $total completed';
  }

  @override
  String myTasksCount(int count) {
    return 'My assigned tasks ($count)';
  }

  @override
  String get noAssignedTasks => 'You have no assigned tasks right now.';

  @override
  String get taskStatus => 'Task status';

  @override
  String dueAt(String date) {
    return 'Due $date';
  }

  @override
  String get staffTaskUpdateError => 'Could not update task status.';

  @override
  String get staffProfileError =>
      'Could not load your staff profile. Please try again.';

  @override
  String get assignedTasksError => 'Could not load your assigned tasks.';

  @override
  String get staffProfileNotLinked => 'Staff profile not linked';

  @override
  String get linkStaffProfileHelp =>
      'Ask your manager to link your Firebase account to your staff record, then sign in again.';

  @override
  String get roomsDescription => 'Track room readiness for housekeeping.';

  @override
  String get addRoom => 'Add room';

  @override
  String totalRooms(int count) {
    return 'Total rooms: $count';
  }

  @override
  String roomsNeedCleaning(int count) {
    return 'Need cleaning: $count';
  }

  @override
  String get searchRooms => 'Search rooms';

  @override
  String get roomStatus => 'Room status';

  @override
  String get allRooms => 'All rooms';

  @override
  String get noRoomsYet => 'No rooms yet. Add the first room to get started.';

  @override
  String get noRoomsMatch => 'No rooms match your search or filter.';

  @override
  String get duplicateRoom => 'That room number already exists.';

  @override
  String get roomAdded => 'Room added.';

  @override
  String get roomUpdated => 'Room updated.';

  @override
  String get roomSaveError => 'Could not save the room.';

  @override
  String get roomStatusError => 'Could not update room status.';

  @override
  String deleteRoomQuestion(String roomNumber) {
    return 'Delete room $roomNumber?';
  }

  @override
  String get removeRoomConfirmation =>
      'This removes the room record from HotelTask.';

  @override
  String get roomDeleteError => 'Could not delete the room.';

  @override
  String get editRoom => 'Edit room';

  @override
  String get roomNumberLabel => 'Room number';

  @override
  String get roomNumberHint => 'For example: 101';

  @override
  String get floorOptional => 'Floor (optional)';

  @override
  String get roomType => 'Room type';

  @override
  String get roomNumberRequired => 'Enter a room number.';

  @override
  String get standard => 'Standard';

  @override
  String get single => 'Single';

  @override
  String get double => 'Double';

  @override
  String get twin => 'Twin';

  @override
  String get suite => 'Suite';

  @override
  String get other => 'Other';

  @override
  String get ready => 'Ready';

  @override
  String get needsCleaning => 'Needs cleaning';

  @override
  String get cleaningInProgress => 'Cleaning in progress';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get roomMessageError =>
      'Could not load rooms. Check your connection and Firestore rules.';

  @override
  String get staffMessageError =>
      'Could not load staff. Check that the latest Firestore rules are deployed.';

  @override
  String get tasksMessageError =>
      'Could not load tasks. Check that the latest Firestore rules are deployed.';

  @override
  String get staffLoadError => 'Could not load staff. Please try again.';

  @override
  String get housekeeping => 'Housekeeping';

  @override
  String get reception => 'Reception';

  @override
  String get maintenanceDepartment => 'Maintenance';

  @override
  String get foodService => 'Food Service';

  @override
  String get staffNameRequired => 'Enter the staff member’s name';

  @override
  String get assignedTaskSingular => 'assigned task';

  @override
  String get assignedTaskPlural => 'assigned tasks';

  @override
  String get noStaffProfile =>
      'Ask the hotel manager to add your profile in Firestore.';

  @override
  String get roleNotSetTitle => 'Account role is not set';

  @override
  String get roleNotSetMessage =>
      'Ask the hotel manager to set your account role in Firestore.';

  @override
  String get profileNotFoundTitle => 'Profile not found';

  @override
  String get profileLoadTitle => 'Could not load your profile';

  @override
  String get profileLoadMessage =>
      'Check that the Firestore security rules are deployed, then try signing in again.';

  @override
  String get authStateError => 'Could not check your sign-in status.';

  @override
  String get workspaceNotReadyTitle => 'Staff workspace is not ready yet';

  @override
  String get workspaceNotReadyMessage =>
      'Your account is signed in, but the staff workspace will be added in a later step.';

  @override
  String get allLocations => 'All rooms and areas';

  @override
  String get priorityLabel => 'Priority';

  @override
  String get dueToday => 'Today';

  @override
  String get dueOverdue => 'Overdue';

  @override
  String get instructionsLabel => 'Instructions';

  @override
  String roomFloor(String floor) {
    return 'Floor $floor';
  }

  @override
  String roomTitle(String roomNumber) {
    return 'Room $roomNumber';
  }

  @override
  String get needCleaning => 'Need cleaning';

  @override
  String get housekeepingStatus => 'Housekeeping status';

  @override
  String get deleteRoom => 'Delete room';

  @override
  String staffGreeting(String name) {
    return 'Hello, $name';
  }

  @override
  String get mobileNavigationHint =>
      'Use the Dashboard tab to return to this page.';
}
