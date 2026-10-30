enum RoomStatus { ready, needsCleaning, cleaning, maintenance }

class HotelRoom {
  const HotelRoom({
    required this.id,
    required this.roomNumber,
    required this.floor,
    required this.roomType,
    required this.status,
  });

  final String id;
  final String roomNumber;
  final String floor;
  final String roomType;
  final RoomStatus status;
}
