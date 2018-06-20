import 'package:flutter/material.dart';
import 'utils/firebase_data.dart';
import 'utils/firebase_messaging.dart';
import 'utils/shared_preferences.dart';
import 'pages/home/home_page.dart';

void main() async {
  await fInitSharedPreferences();
  fInitFirebaseMessaging();
  fInitFirebaseData();
  runApp(new AgoraApp());
}

class AgoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("AgoraApp started");
    return new MaterialApp(
        title: 'AEGEE Agora App',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new HomePageWidget());
  }
}
