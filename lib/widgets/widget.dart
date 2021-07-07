import 'package:flutter/material.dart';

AppBar appBarMain() {
  return AppBar(
    title: Image.asset("assets/images/logo.png", height: 50),
  );
}

InputDecoration textFieldDecoration(String hintText) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(color: Colors.white54),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

TextStyle simpleStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

TextStyle simpleBlackStyle() {
  return TextStyle(color: Colors.black87, fontSize: 16);
}

TextStyle underLineStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
    decoration: TextDecoration.underline,
  );
}

BoxDecoration blueLinearGradient() {
  return BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color(0xff007ef4),
        Color(0xff2a75bc),
      ],
    ),
    borderRadius: BorderRadius.circular(30),
  );
}

BoxDecoration whiteGoogleButton() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(30),
  );
}
