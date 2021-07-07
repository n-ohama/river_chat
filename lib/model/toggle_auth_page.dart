import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_chat/constants.dart';
import 'package:river_chat/screens/signin.dart';
import 'package:river_chat/screens/signup.dart';

class ToggleAuthPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final showPageState = watch(showPageStateProvider).state;
    return showPageState ? SignIn() : SignUp();
  }
}
