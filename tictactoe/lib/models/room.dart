class Room {
  late String roomId;

  Room(this.roomId);

  factory Room.fromJson(String room) => Room(room);
}
