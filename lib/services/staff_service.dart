import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/staff_member.dart';

class StaffService {
  StaffService._();

  static final StaffService instance = StaffService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _staffCollection =>
      _firestore.collection('staff');

  Stream<List<StaffMember>> watchStaff() {
    return _staffCollection.orderBy('name').snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        final data = document.data();
        return StaffMember(
          id: document.id,
          name: data['name'] as String? ?? 'Unnamed staff member',
          department: data['department'] as String? ?? 'Other',
          authUid: data['authUid'] as String?,
        );
      }).toList();
    });
  }

  Stream<List<StaffMember>> watchStaffForUid(String uid) {
    return _staffCollection
        .where('authUid', isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((document) {
            final data = document.data();
            return StaffMember(
              id: document.id,
              name: data['name'] as String? ?? 'Unnamed staff member',
              department: data['department'] as String? ?? 'Other',
              authUid: data['authUid'] as String?,
            );
          }).toList(),
        );
  }

  Future<void> addStaff(StaffMember member) async {
    await _staffCollection.add({
      'name': member.name,
      'department': member.department,
      'authUid': member.authUid,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateStaff(StaffMember member) async {
    await _staffCollection.doc(member.id).update({
      'name': member.name,
      'department': member.department,
      'authUid': member.authUid,
    });
  }
}
