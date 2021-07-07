import 'package:firebase_auth/firebase_auth.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    UserCredential result =
        await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    return user;
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
          await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
    }
  }

  Future signOut() async {
    return await _auth.signOut();
  }
}
