import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_km.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('km'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'HotelTask'**
  String get appTitle;

  /// No description provided for @workspace.
  ///
  /// In en, this message translates to:
  /// **'WORKSPACE'**
  String get workspace;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @accountMenu.
  ///
  /// In en, this message translates to:
  /// **'Account menu'**
  String get accountMenu;

  /// No description provided for @signedIn.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get signedIn;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @khmer.
  ///
  /// In en, this message translates to:
  /// **'ខ្មែរ'**
  String get khmer;

  /// No description provided for @switchToLight.
  ///
  /// In en, this message translates to:
  /// **'Switch to light mode'**
  String get switchToLight;

  /// No description provided for @switchToNight.
  ///
  /// In en, this message translates to:
  /// **'Switch to night mode'**
  String get switchToNight;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to HotelTask'**
  String get welcome;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to manage hotel tasks.'**
  String get signInSubtitle;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddress;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @exploreDemo.
  ///
  /// In en, this message translates to:
  /// **'Explore read-only demo'**
  String get exploreDemo;

  /// No description provided for @portfolioDemo.
  ///
  /// In en, this message translates to:
  /// **'Portfolio demo'**
  String get portfolioDemo;

  /// No description provided for @readOnlyDemo.
  ///
  /// In en, this message translates to:
  /// **'Read-only demo'**
  String get readOnlyDemo;

  /// No description provided for @readOnlyDemoNotice.
  ///
  /// In en, this message translates to:
  /// **'You are viewing sample data. Changes are disabled in this demo.'**
  String get readOnlyDemoNotice;

  /// No description provided for @exitDemo.
  ///
  /// In en, this message translates to:
  /// **'Exit demo'**
  String get exitDemo;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address.'**
  String get enterEmail;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get validEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password.'**
  String get enterPassword;

  /// No description provided for @incorrectCredentials.
  ///
  /// In en, this message translates to:
  /// **'The email or password is incorrect.'**
  String get incorrectCredentials;

  /// No description provided for @tooManyAttempts.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait and try again.'**
  String get tooManyAttempts;

  /// No description provided for @checkConnection.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get checkConnection;

  /// No description provided for @genericSignInError.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed. Please try again.'**
  String get genericSignInError;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericError;

  /// No description provided for @dashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Here is what is happening at your hotel today.'**
  String get dashboardDescription;

  /// No description provided for @tasksDescription.
  ///
  /// In en, this message translates to:
  /// **'Search, assign, and track hotel tasks.'**
  String get tasksDescription;

  /// No description provided for @createTask.
  ///
  /// In en, this message translates to:
  /// **'Create task'**
  String get createTask;

  /// No description provided for @totalTasks.
  ///
  /// In en, this message translates to:
  /// **'Total tasks'**
  String get totalTasks;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get inProgress;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @recentTasks.
  ///
  /// In en, this message translates to:
  /// **'Recent tasks'**
  String get recentTasks;

  /// No description provided for @allTasks.
  ///
  /// In en, this message translates to:
  /// **'All tasks'**
  String get allTasks;

  /// No description provided for @manageAssignments.
  ///
  /// In en, this message translates to:
  /// **'Manage assignments, priorities, and deadlines'**
  String get manageAssignments;

  /// No description provided for @trackHotelOperations.
  ///
  /// In en, this message translates to:
  /// **'Track and manage your hotel operations'**
  String get trackHotelOperations;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @searchTasks.
  ///
  /// In en, this message translates to:
  /// **'Search tasks, rooms, or staff...'**
  String get searchTasks;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All tasks'**
  String get allStatuses;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @allPriorities.
  ///
  /// In en, this message translates to:
  /// **'All priorities'**
  String get allPriorities;

  /// No description provided for @assignedStaff.
  ///
  /// In en, this message translates to:
  /// **'Assigned staff'**
  String get assignedStaff;

  /// No description provided for @allStaff.
  ///
  /// In en, this message translates to:
  /// **'All staff'**
  String get allStaff;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @prioritySort.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get prioritySort;

  /// No description provided for @noTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks found'**
  String get noTasks;

  /// No description provided for @adjustSearch.
  ///
  /// In en, this message translates to:
  /// **'Try changing your search or filter.'**
  String get adjustSearch;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @urgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get urgent;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @taskColumn.
  ///
  /// In en, this message translates to:
  /// **'TASK'**
  String get taskColumn;

  /// No description provided for @locationColumn.
  ///
  /// In en, this message translates to:
  /// **'LOCATION'**
  String get locationColumn;

  /// No description provided for @assignedToColumn.
  ///
  /// In en, this message translates to:
  /// **'ASSIGNED TO'**
  String get assignedToColumn;

  /// No description provided for @priorityColumn.
  ///
  /// In en, this message translates to:
  /// **'PRIORITY'**
  String get priorityColumn;

  /// No description provided for @statusColumn.
  ///
  /// In en, this message translates to:
  /// **'STATUS'**
  String get statusColumn;

  /// No description provided for @dueDateColumn.
  ///
  /// In en, this message translates to:
  /// **'DUE DATE'**
  String get dueDateColumn;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @changeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get changeStatus;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get editTask;

  /// No description provided for @deleteTask.
  ///
  /// In en, this message translates to:
  /// **'Delete task'**
  String get deleteTask;

  /// No description provided for @deleteTaskQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete task?'**
  String get deleteTaskQuestion;

  /// No description provided for @removeTaskConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{title}\" from the task list?'**
  String removeTaskConfirmation(String title);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @taskDeleted.
  ///
  /// In en, this message translates to:
  /// **'Task deleted'**
  String get taskDeleted;

  /// No description provided for @taskCreated.
  ///
  /// In en, this message translates to:
  /// **'Task created successfully'**
  String get taskCreated;

  /// No description provided for @taskUpdated.
  ///
  /// In en, this message translates to:
  /// **'Task updated successfully'**
  String get taskUpdated;

  /// No description provided for @taskCreateError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the task. Please try again.'**
  String get taskCreateError;

  /// No description provided for @taskUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update the task. Please try again.'**
  String get taskUpdateError;

  /// No description provided for @taskDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the task. Please try again.'**
  String get taskDeleteError;

  /// No description provided for @taskStatusError.
  ///
  /// In en, this message translates to:
  /// **'Could not update the task status. Please try again.'**
  String get taskStatusError;

  /// No description provided for @addStaffBeforeTask.
  ///
  /// In en, this message translates to:
  /// **'Add a staff member before creating a task.'**
  String get addStaffBeforeTask;

  /// No description provided for @addStaffBeforeEdit.
  ///
  /// In en, this message translates to:
  /// **'Add a staff member before editing task assignments.'**
  String get addStaffBeforeEdit;

  /// No description provided for @taskFormCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a task'**
  String get taskFormCreateTitle;

  /// No description provided for @taskFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get taskFormEditTitle;

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get taskTitleLabel;

  /// No description provided for @taskTitleHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Clean guest room'**
  String get taskTitleHint;

  /// No description provided for @instructionsOptional.
  ///
  /// In en, this message translates to:
  /// **'Instructions (optional)'**
  String get instructionsOptional;

  /// No description provided for @instructionsHint.
  ///
  /// In en, this message translates to:
  /// **'Add details to help staff complete this task'**
  String get instructionsHint;

  /// No description provided for @roomOrArea.
  ///
  /// In en, this message translates to:
  /// **'Room or area'**
  String get roomOrArea;

  /// No description provided for @roomOrAreaHint.
  ///
  /// In en, this message translates to:
  /// **'For example: Room 101 or Main lobby'**
  String get roomOrAreaHint;

  /// No description provided for @taskPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get taskPriority;

  /// No description provided for @dueLabel.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueLabel(String date);

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// No description provided for @taskTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a task title'**
  String get taskTitleRequired;

  /// No description provided for @locationRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a room or hotel area'**
  String get locationRequired;

  /// No description provided for @taskInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get taskInstructions;

  /// No description provided for @noInstructions.
  ///
  /// In en, this message translates to:
  /// **'No instructions have been added.'**
  String get noInstructions;

  /// No description provided for @taskId.
  ///
  /// In en, this message translates to:
  /// **'Task ID'**
  String get taskId;

  /// No description provided for @assignedTo.
  ///
  /// In en, this message translates to:
  /// **'Assigned to'**
  String get assignedTo;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @deadlineLabel.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadlineLabel;

  /// No description provided for @staffMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff members'**
  String get staffMembersTitle;

  /// No description provided for @staffDescription.
  ///
  /// In en, this message translates to:
  /// **'View hotel staff and the tasks assigned to each person.'**
  String get staffDescription;

  /// No description provided for @addStaff.
  ///
  /// In en, this message translates to:
  /// **'Add staff'**
  String get addStaff;

  /// No description provided for @editStaff.
  ///
  /// In en, this message translates to:
  /// **'Edit staff member'**
  String get editStaff;

  /// No description provided for @addStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Add staff member'**
  String get addStaffTitle;

  /// No description provided for @saveStaff.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveStaff;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @firebaseUidOptional.
  ///
  /// In en, this message translates to:
  /// **'Firebase Auth UID (optional)'**
  String get firebaseUidOptional;

  /// No description provided for @firebaseUidHelp.
  ///
  /// In en, this message translates to:
  /// **'Link this staff record to a Firebase account.'**
  String get firebaseUidHelp;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @allDepartments.
  ///
  /// In en, this message translates to:
  /// **'All departments'**
  String get allDepartments;

  /// No description provided for @noStaffInDepartment.
  ///
  /// In en, this message translates to:
  /// **'No staff members in this department.'**
  String get noStaffInDepartment;

  /// No description provided for @staffAdded.
  ///
  /// In en, this message translates to:
  /// **'Staff member added'**
  String get staffAdded;

  /// No description provided for @staffUpdated.
  ///
  /// In en, this message translates to:
  /// **'Staff member updated'**
  String get staffUpdated;

  /// No description provided for @staffSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save staff. Check your connection and try again.'**
  String get staffSaveError;

  /// No description provided for @editStaffTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit staff member'**
  String get editStaffTooltip;

  /// No description provided for @totalStaff.
  ///
  /// In en, this message translates to:
  /// **'Total staff: {count}'**
  String totalStaff(int count);

  /// No description provided for @assignedTaskCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {taskWord}'**
  String assignedTaskCount(int count, String taskWord);

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsDescription.
  ///
  /// In en, this message translates to:
  /// **'A live overview of hotel task progress.'**
  String get reportsDescription;

  /// No description provided for @tasksByStatus.
  ///
  /// In en, this message translates to:
  /// **'Tasks by status'**
  String get tasksByStatus;

  /// No description provided for @tasksByStaff.
  ///
  /// In en, this message translates to:
  /// **'Tasks by staff member'**
  String get tasksByStaff;

  /// No description provided for @noStaffAdded.
  ///
  /// In en, this message translates to:
  /// **'No staff members have been added yet.'**
  String get noStaffAdded;

  /// No description provided for @completedOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} completed'**
  String completedOfTotal(int completed, int total);

  /// No description provided for @myTasksCount.
  ///
  /// In en, this message translates to:
  /// **'My assigned tasks ({count})'**
  String myTasksCount(int count);

  /// No description provided for @noAssignedTasks.
  ///
  /// In en, this message translates to:
  /// **'You have no assigned tasks right now.'**
  String get noAssignedTasks;

  /// No description provided for @taskStatus.
  ///
  /// In en, this message translates to:
  /// **'Task status'**
  String get taskStatus;

  /// No description provided for @dueAt.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueAt(String date);

  /// No description provided for @staffTaskUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Could not update task status.'**
  String get staffTaskUpdateError;

  /// No description provided for @staffProfileError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your staff profile. Please try again.'**
  String get staffProfileError;

  /// No description provided for @assignedTasksError.
  ///
  /// In en, this message translates to:
  /// **'Could not load your assigned tasks.'**
  String get assignedTasksError;

  /// No description provided for @staffProfileNotLinked.
  ///
  /// In en, this message translates to:
  /// **'Staff profile not linked'**
  String get staffProfileNotLinked;

  /// No description provided for @linkStaffProfileHelp.
  ///
  /// In en, this message translates to:
  /// **'Ask your manager to link your Firebase account to your staff record, then sign in again.'**
  String get linkStaffProfileHelp;

  /// No description provided for @roomsDescription.
  ///
  /// In en, this message translates to:
  /// **'Track room readiness for housekeeping.'**
  String get roomsDescription;

  /// No description provided for @addRoom.
  ///
  /// In en, this message translates to:
  /// **'Add room'**
  String get addRoom;

  /// No description provided for @totalRooms.
  ///
  /// In en, this message translates to:
  /// **'Total rooms: {count}'**
  String totalRooms(int count);

  /// No description provided for @roomsNeedCleaning.
  ///
  /// In en, this message translates to:
  /// **'Need cleaning: {count}'**
  String roomsNeedCleaning(int count);

  /// No description provided for @searchRooms.
  ///
  /// In en, this message translates to:
  /// **'Search rooms'**
  String get searchRooms;

  /// No description provided for @roomStatus.
  ///
  /// In en, this message translates to:
  /// **'Room status'**
  String get roomStatus;

  /// No description provided for @allRooms.
  ///
  /// In en, this message translates to:
  /// **'All rooms'**
  String get allRooms;

  /// No description provided for @noRoomsYet.
  ///
  /// In en, this message translates to:
  /// **'No rooms yet. Add the first room to get started.'**
  String get noRoomsYet;

  /// No description provided for @noRoomsMatch.
  ///
  /// In en, this message translates to:
  /// **'No rooms match your search or filter.'**
  String get noRoomsMatch;

  /// No description provided for @duplicateRoom.
  ///
  /// In en, this message translates to:
  /// **'That room number already exists.'**
  String get duplicateRoom;

  /// No description provided for @roomAdded.
  ///
  /// In en, this message translates to:
  /// **'Room added.'**
  String get roomAdded;

  /// No description provided for @roomUpdated.
  ///
  /// In en, this message translates to:
  /// **'Room updated.'**
  String get roomUpdated;

  /// No description provided for @roomSaveError.
  ///
  /// In en, this message translates to:
  /// **'Could not save the room.'**
  String get roomSaveError;

  /// No description provided for @roomStatusError.
  ///
  /// In en, this message translates to:
  /// **'Could not update room status.'**
  String get roomStatusError;

  /// No description provided for @deleteRoomQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete room {roomNumber}?'**
  String deleteRoomQuestion(String roomNumber);

  /// No description provided for @removeRoomConfirmation.
  ///
  /// In en, this message translates to:
  /// **'This removes the room record from HotelTask.'**
  String get removeRoomConfirmation;

  /// No description provided for @roomDeleteError.
  ///
  /// In en, this message translates to:
  /// **'Could not delete the room.'**
  String get roomDeleteError;

  /// No description provided for @editRoom.
  ///
  /// In en, this message translates to:
  /// **'Edit room'**
  String get editRoom;

  /// No description provided for @roomNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Room number'**
  String get roomNumberLabel;

  /// No description provided for @roomNumberHint.
  ///
  /// In en, this message translates to:
  /// **'For example: 101'**
  String get roomNumberHint;

  /// No description provided for @floorOptional.
  ///
  /// In en, this message translates to:
  /// **'Floor (optional)'**
  String get floorOptional;

  /// No description provided for @roomType.
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get roomType;

  /// No description provided for @roomNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a room number.'**
  String get roomNumberRequired;

  /// No description provided for @standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standard;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @double.
  ///
  /// In en, this message translates to:
  /// **'Double'**
  String get double;

  /// No description provided for @twin.
  ///
  /// In en, this message translates to:
  /// **'Twin'**
  String get twin;

  /// No description provided for @suite.
  ///
  /// In en, this message translates to:
  /// **'Suite'**
  String get suite;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @needsCleaning.
  ///
  /// In en, this message translates to:
  /// **'Needs cleaning'**
  String get needsCleaning;

  /// No description provided for @cleaningInProgress.
  ///
  /// In en, this message translates to:
  /// **'Cleaning in progress'**
  String get cleaningInProgress;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @roomMessageError.
  ///
  /// In en, this message translates to:
  /// **'Could not load rooms. Check your connection and Firestore rules.'**
  String get roomMessageError;

  /// No description provided for @staffMessageError.
  ///
  /// In en, this message translates to:
  /// **'Could not load staff. Check that the latest Firestore rules are deployed.'**
  String get staffMessageError;

  /// No description provided for @tasksMessageError.
  ///
  /// In en, this message translates to:
  /// **'Could not load tasks. Check that the latest Firestore rules are deployed.'**
  String get tasksMessageError;

  /// No description provided for @staffLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load staff. Please try again.'**
  String get staffLoadError;

  /// No description provided for @housekeeping.
  ///
  /// In en, this message translates to:
  /// **'Housekeeping'**
  String get housekeeping;

  /// No description provided for @reception.
  ///
  /// In en, this message translates to:
  /// **'Reception'**
  String get reception;

  /// No description provided for @maintenanceDepartment.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceDepartment;

  /// No description provided for @foodService.
  ///
  /// In en, this message translates to:
  /// **'Food Service'**
  String get foodService;

  /// No description provided for @staffNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter the staff member’s name'**
  String get staffNameRequired;

  /// No description provided for @assignedTaskSingular.
  ///
  /// In en, this message translates to:
  /// **'assigned task'**
  String get assignedTaskSingular;

  /// No description provided for @assignedTaskPlural.
  ///
  /// In en, this message translates to:
  /// **'assigned tasks'**
  String get assignedTaskPlural;

  /// No description provided for @noStaffProfile.
  ///
  /// In en, this message translates to:
  /// **'Ask the hotel manager to add your profile in Firestore.'**
  String get noStaffProfile;

  /// No description provided for @roleNotSetTitle.
  ///
  /// In en, this message translates to:
  /// **'Account role is not set'**
  String get roleNotSetTitle;

  /// No description provided for @roleNotSetMessage.
  ///
  /// In en, this message translates to:
  /// **'Ask the hotel manager to set your account role in Firestore.'**
  String get roleNotSetMessage;

  /// No description provided for @profileNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFoundTitle;

  /// No description provided for @profileLoadTitle.
  ///
  /// In en, this message translates to:
  /// **'Could not load your profile'**
  String get profileLoadTitle;

  /// No description provided for @profileLoadMessage.
  ///
  /// In en, this message translates to:
  /// **'Check that the Firestore security rules are deployed, then try signing in again.'**
  String get profileLoadMessage;

  /// No description provided for @authStateError.
  ///
  /// In en, this message translates to:
  /// **'Could not check your sign-in status.'**
  String get authStateError;

  /// No description provided for @workspaceNotReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff workspace is not ready yet'**
  String get workspaceNotReadyTitle;

  /// No description provided for @workspaceNotReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account is signed in, but the staff workspace will be added in a later step.'**
  String get workspaceNotReadyMessage;

  /// No description provided for @allLocations.
  ///
  /// In en, this message translates to:
  /// **'All rooms and areas'**
  String get allLocations;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dueToday;

  /// No description provided for @dueOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get dueOverdue;

  /// No description provided for @instructionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructionsLabel;

  /// No description provided for @roomFloor.
  ///
  /// In en, this message translates to:
  /// **'Floor {floor}'**
  String roomFloor(String floor);

  /// No description provided for @roomTitle.
  ///
  /// In en, this message translates to:
  /// **'Room {roomNumber}'**
  String roomTitle(String roomNumber);

  /// No description provided for @needCleaning.
  ///
  /// In en, this message translates to:
  /// **'Need cleaning'**
  String get needCleaning;

  /// No description provided for @housekeepingStatus.
  ///
  /// In en, this message translates to:
  /// **'Housekeeping status'**
  String get housekeepingStatus;

  /// No description provided for @deleteRoom.
  ///
  /// In en, this message translates to:
  /// **'Delete room'**
  String get deleteRoom;

  /// No description provided for @staffGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String staffGreeting(String name);

  /// No description provided for @mobileNavigationHint.
  ///
  /// In en, this message translates to:
  /// **'Use the Dashboard tab to return to this page.'**
  String get mobileNavigationHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'km'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'km':
      return AppLocalizationsKm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
