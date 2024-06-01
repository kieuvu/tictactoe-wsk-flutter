import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tictactoe/constants/api_constant.dart';
import 'package:tictactoe/models/game.dart';

import '../models/room.dart';

class RoomService {
  static Future<List<Room>> fetchRooms() async {
    final response = await http.get(Uri.parse(ApiConstant.getRoomsEndpoint));
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['rooms'];
      return jsonResponse.map((room) => Room.fromJson(room)).toList();
    } else {
      throw Exception('Failed to load rooms');
    }
  }

  static Future<Room> createRoom() async {
    final response = await http.post(Uri.parse(ApiConstant.createRoomEndpoint));
    if (response.statusCode == 200) {
      return Room(await json.decode(response.body)['room_id']);
    } else {
      throw Exception('Failed to create rooms');
    }
  }

  static Future<Game> joinRoom(String roomId) async {
    final response = await http.get(Uri.parse(ApiConstant.joinRoomEndpoint.replaceFirst("{roomId}", roomId)));
    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body)["data"];
      return Game(status: jsonResponse["status"], turn: jsonResponse["turn"], board: jsonResponse["board"]);
    } else {
      throw Exception('Failed to join rooms');
    }
  }

  static Future<Game> updateRoom(String roomId, int player, int boardIndex) async {
    final response = await http.post(Uri.parse(ApiConstant.updateGameEndpoint.replaceFirst("{roomId}", roomId)),
        body: {'player': player.toString(), 'boardIndex': boardIndex.toString()});
    if (response.statusCode == 200) {
      dynamic jsonResponse = json.decode(response.body)["data"];
      return Game(status: jsonResponse["status"], turn: jsonResponse["turn"], board: jsonResponse["board"]);
    } else {
      throw Exception('Failed to join rooms');
    }
  }
}
