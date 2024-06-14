import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tictactoe/models/history.dart';

class HistoryService {
  static final FirebaseFirestore _store = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<List<History>> getUserHistories() async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user is signed in");
    }

    String uid = user.uid;

    _store.settings = const Settings(
      persistenceEnabled: true,
    );

    QuerySnapshot querySnapshot = await _store.collection('histories').where('uid', isEqualTo: uid).get();

    List<History> historyList = querySnapshot.docs.map((doc) => History.fromDocument(doc)).toList();
    return historyList;
  }

  static Future<void> createHistory(History history) async {
    User? user = _auth.currentUser;

    if (user == null) {
      throw Exception("No user is signed in");
    }

    String uid = user.uid;
    history.uid = uid;

    await _store
        .collection('histories')
        .add({'uid': history.uid, 'timestamp': history.timestamp, 'result': history.result});
  }
}
