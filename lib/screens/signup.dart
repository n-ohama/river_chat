import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_chat/constants.dart';
import 'package:river_chat/model/auth.dart';
import 'package:river_chat/model/database.dart';
import 'package:river_chat/model/shared_methods.dart';
import 'package:river_chat/screens/chatroom_screen.dart';
import 'package:river_chat/widgets/widget.dart';

TextEditingController _nameController = TextEditingController();
TextEditingController _emailController = TextEditingController();
TextEditingController _passController = TextEditingController();
AuthMethods _authMethods = AuthMethods();
DatabaseMethods _databaseMethods = DatabaseMethods();
final _formKey = GlobalKey<FormState>();

class SignUp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final loadingState = watch(loadingStateProvider).state;
    void signMeUp() {
      if (_formKey.currentState!.validate()) {
        context.read(loadingStateProvider).state = true;
        context.read(myNameStateProvider).state = _nameController.text;
        Map<String, String> userInfo = {
          "name": _nameController.text,
          "email": _emailController.text,
        };
        SharedMethods.saveUsername(_nameController.text);
        _authMethods.signUpWithEmailAndPassword(_emailController.text, _passController.text).then((value) {
          _databaseMethods.registerUser(userInfo);
          SharedMethods.saveLoggedIn(true);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: ((context) => ChatroomScreen())),
          );
          context.read(loadingStateProvider).state = false;
        });
      }
    }

    return Scaffold(
      appBar: appBarMain(),
      body: loadingState
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - 200,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nameController,
                            validator: (value) {
                              return value!.length < 4 ? "Please provide a valid username" : null;
                            },
                            style: simpleStyle(),
                            decoration: textFieldDecoration("username"),
                          ),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!)
                                  ? null
                                  : "Please provide a valid email";
                            },
                            style: simpleStyle(),
                            decoration: textFieldDecoration("email"),
                          ),
                          TextFormField(
                            controller: _passController,
                            validator: (value) {
                              return value!.length > 6 ? null : "Please provide 6+ character password";
                            },
                            obscureText: true,
                            style: simpleStyle(),
                            decoration: textFieldDecoration("password"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        signMeUp();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: blueLinearGradient(),
                        child: Text("Sign Up", style: simpleStyle()),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: whiteGoogleButton(),
                      child: Text("Sign Up with Google", style: simpleBlackStyle()),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have account? ", style: simpleStyle()),
                        GestureDetector(
                          onTap: () {
                            // toggle_auth_page の stateProviderを使用
                            context.read(showPageStateProvider).state = !context.read(showPageStateProvider).state;
                          },
                          child: Container(
                            child: Text("Sign in now", style: underLineStyle()),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
