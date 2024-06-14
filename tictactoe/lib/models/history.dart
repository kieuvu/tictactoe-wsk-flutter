import 'package:cloud_firestore/cloud_firestore.dart';

class History {
  String result;
  String timestamp;
  String? uid;

  History({required this.result, required this.timestamp, this.uid});

  factory History.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return History(result: data['result'] ?? '', timestamp: data['timestamp'] ?? '', uid: data['uid']);
  }
}
