# HotelTask

HotelTask is a responsive Flutter Web application for hotel managers and staff to coordinate housekeeping and hotel operations tasks. It was built as a Flutter and Firebase portfolio project.

## Live demo

[Open HotelTask](https://hoteltask-portfolio.web.app)

The app requires a Firebase Authentication account with a Firestore user profile. The manager and staff role in `users/{uid}` controls which workspace opens.

## Features

- Firebase Authentication sign-in and sign-out.
- Manager and staff roles, with role checks in both the app and Firestore rules.
- Manager dashboard with live task totals, including overdue tasks.
- Task creation, assignment, editing, deletion, search, filtering, and sorting.
- Staff directory with departments and Firebase account linking.
- Room directory with room type, floor, and housekeeping readiness; managers can add, edit, search, filter, and delete room records.
- Staff workspace showing only that staff member's assigned tasks; staff can update task status.
- Reports grouped by status and staff member.
- Responsive desktop and mobile layouts, with light and dark themes.
- English and Khmer language switching; the selected language is remembered after reloading the browser.
- Battambang font for Khmer text.

## Technology

- Flutter Web and Dart
- Material 3
- Firebase Authentication
- Cloud Firestore
- `google_fonts` for Khmer typography
- `shared_preferences` for the saved language preference

## Run locally

Install [Flutter](https://docs.flutter.dev/get-started/install), Google Chrome, and the [Firebase CLI](https://firebase.google.com/docs/cli). In PowerShell, open the project folder and run:

```powershell
flutter pub get
flutter run -d chrome
```

The app uses Firebase. To connect your own Firebase project, sign in with the Firebase CLI, enable Email/Password sign-in and create a Firestore database in the Firebase Console, then configure the Flutter app:

```powershell
firebase login
dart pub global activate flutterfire_cli
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID --platforms=web
```

Replace `YOUR_FIREBASE_PROJECT_ID` with the ID of your Firebase project. The FlutterFire command generates `lib/firebase_options.dart` for that project. Install the project packages and start the app with `flutter pub get` and `flutter run -d chrome`.

## Firebase data model

### `users/{uid}`

The document ID is the Firebase Authentication user UID.

| Field | Type | Description |
| --- | --- | --- |
| `displayName` | string | Name shown in the staff workspace. |
| `email` | string | User's sign-in email. |
| `role` | string | `manager` or `staff`. |

### `staff/{staffId}`

| Field | Type | Description |
| --- | --- | --- |
| `name` | string | Staff member's name. |
| `department` | string | Such as Housekeeping, Reception, Maintenance, or Food Service. |
| `authUid` | string or null | Authentication UID linked to this staff record. |
| `createdAt` | timestamp | When the staff record was created. |

### `rooms/{roomId}`

| Field | Type | Description |
| --- | --- | --- |
| `roomNumber` | string | Room number or identifier, such as `101`. |
| `floor` | string | Optional floor label. |
| `roomType` | string | Such as Standard, Single, Double, Twin, or Suite. |
| `status` | string | Housekeeping state: `ready`, `needsCleaning`, `cleaning`, or `maintenance`. |
| `createdAt` | timestamp | When the room record was created. |

### `tasks/{taskId}`

| Field | Type | Description |
| --- | --- | --- |
| `title` | string | Short task title. |
| `description` | string | Optional task instructions. |
| `location` | string | Room number or shared hotel area. |
| `assigneeId` | string | ID of the assigned staff document. |
| `assigneeUid` | string or null | Firebase Authentication UID for staff task access. |
| `assigneeName` | string | Staff name displayed with the task. |
| `priority` | string | `low`, `medium`, `high`, or `urgent`. |
| `status` | string | `pending`, `inProgress`, or `completed`. |
| `createdAt` | timestamp | Task creation time. |
| `dueAt` | timestamp | Task deadline. |

## Create manager and staff accounts

1. In Firebase Authentication, create a user with Email/Password sign-in enabled.
2. In Firestore, create `users/{uid}` using that user's Authentication UID as the document ID. Add `displayName`, `email`, and `role` fields. Set the first trusted account's role to `manager`.
3. For a staff account, add a staff record in HotelTask, then edit it and set its **Firebase Auth UID** to the staff user's Authentication UID.
4. Assign tasks to the linked staff record so task documents include that user's `assigneeUid`.

Create and change role profiles through the Firebase Console or a trusted administrative process. The app's Firestore rules intentionally prevent users from changing their own role. Never store passwords in Firestore.

## Firestore security

The checked-in [`firestore.rules`](firestore.rules) allows managers to manage staff, rooms, and tasks. A staff account can read its linked staff record and assigned tasks, and can update only the `status` field of its own tasks. User profiles are read-only from the client. Deploy the rules to your project with:

```powershell
firebase deploy --only firestore:rules --project YOUR_FIREBASE_PROJECT_ID
```

The web Firebase configuration in `lib/firebase_options.dart` is client configuration and is included in the web app. Firebase API keys in web configuration are not server credentials; authorization is enforced by Authentication and Firestore Security Rules. Do not add Firebase service-account keys, Admin SDK credentials, or passwords to this repository.

## Build and deploy to Firebase Hosting

Build the static Flutter Web site:

```powershell
flutter build web --release
```

Firebase Hosting is configured in `firebase.json` to publish `build/web`, and `.firebaserc` selects the `hoteltask-portfolio` project. Build and deploy the current project with:

```powershell
firebase deploy --only hosting --project hoteltask-portfolio
```

Replace the project ID if deploying to a different Firebase project. This app is currently deployed at [hoteltask-portfolio.web.app](https://hoteltask-portfolio.web.app). Firebase lists Spark Hosting limits of 10 GB storage and 360 MB/day data transfer; usage limits and pricing can change, so check the [current Firebase pricing](https://firebase.google.com/pricing) before publishing. No billing upgrade is needed for the current deployment.

## Project structure

```text
lib/
  app.dart                 App themes and role-based screen selection
  main.dart                Firebase initialization and app startup
  firebase_options.dart    Firebase Web client configuration
  data/                    Sample records for development/reference
  models/                  Task, staff, and user-role data models
  screens/                 Login, manager dashboard, staff, reports, and task screens
  services/                Firebase Authentication and Firestore access
  widgets/                 Reusable navigation, forms, and dashboard widgets
firestore.rules            Server-enforced Firestore permissions
```

## Current scope

Dashboard, Tasks, Rooms, Staff, Reports, manager sign-in, staff sign-in, and staff task status updates are implemented. Settings is not implemented yet.
