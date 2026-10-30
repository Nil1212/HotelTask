enum UserRole { manager, staff, unknown }

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.role,
  });

  final String uid;
  final String displayName;
  final String email;
  final UserRole role;

  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    final role = switch (data['role']) {
      'manager' => UserRole.manager,
      'staff' => UserRole.staff,
      _ => UserRole.unknown,
    };

    return UserProfile(
      uid: uid,
      displayName: data['displayName'] as String? ?? 'HotelTask user',
      email: data['email'] as String? ?? '',
      role: role,
    );
  }
}
