import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_chat/constants.dart';
import 'package:river_chat/model/database.dart';
import 'package:river_chat/screens/conversation_screen.dart';
import 'package:river_chat/widgets/widget.dart';

TextEditingController _searchController = TextEditingController();
DatabaseMethods _databaseMethods = DatabaseMethods();

class SearchScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final snapshotState = watch(searchSnapshotStateProvider).state;
    final myNameState = watch(myNameStateProvider).state;
    void startConversation(String oppositeName) {
      String roomId = getChatRoomId(oppositeName, myNameState!);
      context.read(roomIdStateProvider).state = roomId;
      List<String> users = [oppositeName, myNameState];
      Map<String, dynamic> roomInfoMap = {
        "users": users,
        "roomId": roomId,
      };
      if (oppositeName != myNameState) {
        _databaseMethods.createChatroom(roomId, roomInfoMap);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConversationScreen()),
        );
      } else {
        print("it's impossible");
      }
    }

    Widget searchList() {
      return snapshotState == null || snapshotState.docs.length == 0
          ? Container()
          : ListView.builder(
              shrinkWrap: true,
              itemCount: snapshotState.docs.length,
              itemBuilder: (context, index) {
                final searchMap = snapshotState.docs[index].data() as Map;
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(searchMap["name"], style: simpleStyle()),
                          Text(searchMap["email"], style: simpleStyle()),
                        ],
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          startConversation(searchMap["name"]);
                        },
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text("Message", style: simpleStyle()),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
    }

    return Scaffold(
      appBar: appBarMain(),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: Color(0x54ffffff),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "search username...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.read(searchSnapshotStateProvider).state = null;
                      _databaseMethods.searchUser(_searchController.text).then((value) {
                        context.read(searchSnapshotStateProvider).state = value;
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0x36ffffff),
                            Color(0x0fffffff),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Image.asset("assets/images/search_white.png"),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
