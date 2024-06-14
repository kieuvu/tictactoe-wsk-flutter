import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tictactoe/screens/list_room.dart';
import 'package:tictactoe/screens/login.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDtEd5KIkfm5emK8XYduGfy6BKC0lgKlPs",
          authDomain: "flutter-tictactoe-27297.firebaseapp.com",
          databaseURL: "https://flutter-tictactoe-27297-default-rtdb.asia-southeast1.firebasedatabase.app",
          projectId: "flutter-tictactoe-27297",
          storageBucket: "flutter-tictactoe-27297.appspot.com",
          messagingSenderId: "475209359619",
          appId: "1:475209359619:web:44fe29fb8065e86eff8936",
          measurementId: "G-03MNFNXD5X"),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'tictactoe',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
          useMaterial3: true,
        ),
        home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const LoginScreen();
              } else {
                return const ListRoomScreen();
              }
            }),
      );
}
