import '../models/hotel_room.dart';

/// Example rooms shown only in the public, read-only portfolio demo.
const List<HotelRoom> sampleRooms = [
  HotelRoom(
    id: 'demo-room-101',
    roomNumber: '101',
    floor: '1',
    roomType: 'Single',
    status: RoomStatus.ready,
  ),
  HotelRoom(
    id: 'demo-room-102',
    roomNumber: '102',
    floor: '1',
    roomType: 'Double',
    status: RoomStatus.cleaning,
  ),
  HotelRoom(
    id: 'demo-room-201',
    roomNumber: '201',
    floor: '2',
    roomType: 'Suite',
    status: RoomStatus.needsCleaning,
  ),
  HotelRoom(
    id: 'demo-room-202',
    roomNumber: '202',
    floor: '2',
    roomType: 'Double',
    status: RoomStatus.maintenance,
  ),
];
