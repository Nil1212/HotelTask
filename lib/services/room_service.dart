import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/hotel_room.dart';

class RoomService {
  RoomService._();

  static final RoomService instance = RoomService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _roomCollection =>
      _firestore.collection('rooms');

  Stream<List<HotelRoom>> watchRooms() {
    return _roomCollection.orderBy('roomNumber').snapshots().map((snapshot) {
      return snapshot.docs.map((document) {
        final data = document.data();
        return HotelRoom(
          id: document.id,
          roomNumber: data['roomNumber'] as String? ?? '—',
          floor: data['floor'] as String? ?? '',
          roomType: data['roomType'] as String? ?? 'Standard',
          status: RoomStatus.values.firstWhere(
            (status) => status.name == data['status'],
            orElse: () => RoomStatus.needsCleaning,
          ),
        );
      }).toList();
    });
  }

  Future<void> addRoom(HotelRoom room) async {
    await _roomCollection.add(
      _toMap(room)..['createdAt'] = FieldValue.serverTimestamp(),
    );
  }

  Future<void> updateRoom(HotelRoom room) async {
    await _roomCollection.doc(room.id).update(_toMap(room));
  }

  Future<void> updateStatus(String roomId, RoomStatus status) async {
    await _roomCollection.doc(roomId).update({'status': status.name});
  }

  Future<void> deleteRoom(String roomId) async {
    await _roomCollection.doc(roomId).delete();
  }

  Map<String, dynamic> _toMap(HotelRoom room) {
    return {
      'roomNumber': room.roomNumber,
      'floor': room.floor,
      'roomType': room.roomType,
      'status': room.status.name,
    };
  }
}
