class StaffMember {
  const StaffMember({
    required this.id,
    required this.name,
    required this.department,
    this.authUid,
  });

  final String id;
  final String name;
  final String department;

  /// Firebase Authentication UID linked to this staff record, if available.
  final String? authUid;
}
