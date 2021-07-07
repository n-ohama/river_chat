import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  registerUser(Map<String, String> userInfo) {
    FirebaseFirestore.instance.collection("users").add(userInfo);
  }

  getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: userEmail).get();
  }

  searchUser(String username) {
    return FirebaseFirestore.instance.collection("users").where("name", isEqualTo: username).get();
  }

  createChatroom(String roomId, roomInfoMap) {
    FirebaseFirestore.instance.collection("chatroom").doc(roomId).set(roomInfoMap);
  }
}
