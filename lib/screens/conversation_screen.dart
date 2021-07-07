import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_chat/constants.dart';
import 'package:river_chat/widgets/widget.dart';

TextEditingController _messageController = TextEditingController();
ListView msgSnapshots(AsyncSnapshot snapshot) {
  return ListView.builder(
    itemCount: snapshot.data.docs.length,
    itemBuilder: (context, index) {
      final snapshotMap = snapshot.data.docs[index].data() as Map;
      final bool isSender = snapshotMap["sender"] == context.read(myNameStateProvider).state;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isSender
                  ? [
                      Color(0xff007ef4),
                      Color(0xff2a75bc),
                    ]
                  : [
                      Color(0x1affffff),
                      Color(0x1affffff),
                    ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23),
            ),
          ),
          child: Text(snapshotMap["content"], style: simpleStyle()),
        ),
      );
    },
  );
}

class ConversationScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    void sendMessage() {
      if (_messageController.text.isNotEmpty) {
        final roomId = context.read(roomIdStateProvider).state;
        Map<String, dynamic> chatMap = {
          "content": _messageController.text,
          "sender": context.read(myNameStateProvider).state,
          "time": DateTime.now(),
        };
        FirebaseFirestore.instance.collection("chatroom").doc(roomId).collection("chats").add(chatMap);
        _messageController.text = "";
      }
    }

    return Scaffold(
      appBar: appBarMain(),
      body: Container(
        padding: EdgeInsets.only(top: 16),
        child: Stack(
          children: [
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("chatroom")
                  .doc(context.read(roomIdStateProvider).state)
                  .collection("chats")
                  .orderBy("time", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasData ? msgSnapshots(snapshot) : Center(child: CircularProgressIndicator());
              },
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                color: Color(0x54ffffff),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Message...",
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
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
                        child: Image.asset("assets/images/send.png"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
