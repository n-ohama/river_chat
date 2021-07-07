import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_chat/constants.dart';
import 'package:river_chat/model/shared_methods.dart';
import 'package:river_chat/model/toggle_auth_page.dart';
import 'package:river_chat/screens/chatroom_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  void getLoggedInState() {
    SharedMethods.bringLoggedIn().then((value) {
      if (value == true) {
        setState(() => isLoggedIn = true);
      }
    });
    SharedMethods.bringUsername().then((value) {
      if (value != null) {
        context.read(myNameStateProvider).state = value;
      }
    });
  }

  @override
  void initState() {
    getLoggedInState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1f1f1f),
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? ChatroomScreen() : ToggleAuthPage(),
    );
  }
}
