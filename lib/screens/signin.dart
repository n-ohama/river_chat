import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:river_chat/constants.dart';
import 'package:river_chat/model/auth.dart';
import 'package:river_chat/model/database.dart';
import 'package:river_chat/model/shared_methods.dart';
import 'package:river_chat/screens/chatroom_screen.dart';
import 'package:river_chat/widgets/widget.dart';

TextEditingController _emailController = TextEditingController();
TextEditingController _passController = TextEditingController();
AuthMethods _authMethods = AuthMethods();
DatabaseMethods _databaseMethods = DatabaseMethods();
final _formKey = GlobalKey<FormState>();

class SignIn extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final loadingState = watch(loadingStateProvider).state;
    void signinAndPushMyPage() {
      if (_formKey.currentState!.validate()) {
        context.read(loadingStateProvider).state = true;

        _databaseMethods.getUserByEmail(_emailController.text).then((value) {
          final myInfoMap = value.docs[0].data() as Map;
          context.read(myNameStateProvider).state = myInfoMap["name"];
          SharedMethods.saveUsername(myInfoMap["name"]);
        });

        _authMethods.signInWithEmailAndPassword(_emailController.text, _passController.text).then((value) {
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
                    SizedBox(height: 16),
                    Container(
                      alignment: Alignment.centerRight,
                      child: Text("Forget password?", style: simpleStyle()),
                    ),
                    SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        signinAndPushMyPage();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(vertical: 20),
                        decoration: blueLinearGradient(),
                        child: Text("Sign In", style: simpleStyle()),
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(vertical: 20),
                      decoration: whiteGoogleButton(),
                      child: Text("Sign In with Google", style: simpleBlackStyle()),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have account? ", style: simpleStyle()),
                        GestureDetector(
                          onTap: () {
                            // toggle_auth_page の stateProviderを使用
                            context.read(showPageStateProvider).state = !context.read(showPageStateProvider).state;
                          },
                          child: Container(
                            child: Text("Register now", style: underLineStyle()),
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
