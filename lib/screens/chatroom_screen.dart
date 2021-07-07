import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_chat/model/auth.dart';
import 'package:river_chat/model/shared_methods.dart';
import 'package:river_chat/model/toggle_auth_page.dart';
import 'package:river_chat/screens/search_screen.dart';

AuthMethods _authMethods = AuthMethods();

class ChatroomScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png", height: 50),
        actions: [
          GestureDetector(
            onTap: () {
              _authMethods.signOut();
              SharedMethods.saveLoggedIn(false);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ToggleAuthPage()),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
      ),
      body: Container(),
    );
  }
}
