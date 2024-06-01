class ApiConstant {
  static String apiEndpoint = "http://localhost:8000/api";
  static String getRoomsEndpoint = "${ApiConstant.apiEndpoint}/game/rooms";
  static String createRoomEndpoint = "${ApiConstant.apiEndpoint}/game/create";
  static String joinRoomEndpoint = "${ApiConstant.apiEndpoint}/game/{roomId}/join";
  static String updateGameEndpoint = "${ApiConstant.apiEndpoint}/game/{roomId}/update";
}
