import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:tictactoe/constants/game_constant.dart';
import 'package:tictactoe/models/game.dart';
import 'package:tictactoe/services/room_service.dart';

class RoomDetailScreen extends StatefulWidget {
  final String room;
  final int player;

  const RoomDetailScreen({super.key, required this.room, required this.player});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  late PusherChannelsFlutter _pusher;
  late final String _apiKey;
  late final String _cluster;
  late final String _channelName;

  Game _game = Game(status: GameConstant.cont, turn: GameConstant.playerX, board: List.filled(9, null));

  @override
  void initState() {
    super.initState();

    initSocket();
    joinGame();
  }

  Future<void> initSocket() async {
    _pusher = PusherChannelsFlutter.getInstance();
    _apiKey = "aa76a6a85855f151f6b1";
    _cluster = "ap1";
    _channelName = "game.notification.${widget.room}";

    await _pusher.init(apiKey: _apiKey, cluster: _cluster, onEvent: onEvent);

    await _pusher.subscribe(channelName: _channelName);
    await _pusher.connect();
  }

  Future<void> joinGame() async {
    Game game = await RoomService.joinRoom(widget.room);
    setState(() => _game = game);
  }

  dynamic onEvent(PusherEvent event) {
    if (event.eventName != "game.notification") return;

    dynamic data = event.data["roomData"];
    int status = data["status"];

    setState(() => _game = Game(status: data["status"], turn: data["turn"], board: data["board"]));

    if (status == GameConstant.cont) return;
    if (status == GameConstant.oWin) return showResultDialog("O won !!!");
    if (status == GameConstant.xWin) return showResultDialog("X won !!!");
    if (status == GameConstant.draw) return showResultDialog("Draw !!!");
  }

  Future<void> _handleTap(int index) async {
    if (_game.turn != widget.player) return;
    if (_game.status != GameConstant.cont) return;

    Game game = await RoomService.updateRoom(widget.room, widget.player, index);
    setState(() => _game = game);
  }

  String getPlayer(int? player) {
    if (player == null) return '';
    return player == GameConstant.playerX ? "X" : "O";
  }

  String getCurrentPlayer() => widget.player == GameConstant.playerX ? "X" : "O";

  Future<String?> showResultDialog(String message) => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: const Text('Notification'),
            content: Text(message),
            actions: <Widget>[
              TextButton(onPressed: () => Navigator.pop(context, 'OK'), child: const Text('OK')),
            ],
          ));

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.room),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("You are ${getCurrentPlayer()}"),
              Text(_game.turn == widget.player ? "Your turn" : "Enemy turn"),
              Expanded(
                  child: Container(
                      padding: const EdgeInsets.all(0),
                      child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 0,
                            mainAxisSpacing: 0,
                          ),
                          itemCount: 9,
                          itemBuilder: (context, index) => GestureDetector(
                              onTap: () => _handleTap(index),
                              child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                  ),
                                  child: Center(
                                      child: Text(getPlayer(_game.board[index]),
                                          style: const TextStyle(
                                            fontSize: 50,
                                            fontWeight: FontWeight.bold,
                                          ))))))))
            ]),
      );
}
