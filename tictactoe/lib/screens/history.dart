import 'package:flutter/material.dart';
import 'package:tictactoe/models/history.dart';
import 'package:tictactoe/screens/list_room.dart';
import 'package:tictactoe/services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<History>> _historiesFuture;

  @override
  void initState() {
    super.initState();
    _historiesFuture = HistoryService.getUserHistories();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("History"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListRoomScreen(),
                )),
          ),
        ),
        body: FutureBuilder<List<History>>(
            future: _historiesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data available'));
              } else {
                List<History> histories = snapshot.data!;
                return ListView.builder(
                    itemCount: histories.length,
                    itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ListTile(
                                title: Text(histories[index].result), subtitle: Text(histories[index].timestamp)))));
              }
            }),
      );
}
