import 'package:flutter/material.dart';
import 'package:tictactoe/constants/game_constant.dart';
import 'package:tictactoe/screens/history.dart';
import 'package:tictactoe/screens/login.dart';
import 'package:tictactoe/screens/room_detail.dart';
import 'package:tictactoe/services/auth_service.dart';
import 'package:tictactoe/services/room_service.dart';

import '../models/room.dart';

class ListRoomScreen extends StatefulWidget {
  const ListRoomScreen({super.key});

  @override
  State<ListRoomScreen> createState() => _ListRoomScreenState();
}

class _ListRoomScreenState extends State<ListRoomScreen> {
  late Future<List<Room>> _roomsFuture;

  @override
  void initState() {
    super.initState();
    _roomsFuture = RoomService.fetchRooms();
  }

  Future<void> _signOut(BuildContext context) async {
    await AuthService.logout();
    if (context.mounted) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Room>>(
          future: _roomsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available'));
            } else {
              List<Room> rooms = snapshot.data!;
              return ListView.builder(
                  itemCount: rooms.length,
                  itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                              title: Text(rooms[index].roomId),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        RoomDetailScreen(room: rooms[index].roomId, player: GameConstant.playerO),
                                  ))))));
            }
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add_new_room',
            onPressed: () async {
              Room room = await RoomService.createRoom();
              if (context.mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RoomDetailScreen(room: room.roomId, player: GameConstant.playerX),
                    ));
              }
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'refresh_data',
            onPressed: () => setState(() {
              _roomsFuture = RoomService.fetchRooms();
            }),
            child: const Icon(Icons.refresh),
          )
        ],
      ));
}
