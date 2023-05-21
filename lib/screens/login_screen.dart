import 'package:flash_chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_app/components/rounded_button.dart';
import 'package:flash_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart'; //step1
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  String email = '';
  String password = '';
  bool spiner = false;

  void toastMsgs(String msg) {
    Fluttertoast.showToast(
        msg: msg.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow.shade800,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: spiner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'flash',
                child: Container(
                  height: 200.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your Email',
                  )),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(
                    hintText: 'Enter your Password',
                  )),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                boxColor: Colors.lightBlueAccent,
                text: 'Log In',
                onpressed: () async {
                  setState(() {
                    //spinning will start when the user presses the button
                    spiner = true;
                  });
                  try {
                    final newUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                        print("----------------------------------$newUser.uid");

                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      toastMsgs('successfully logged In ! ');
                    }

                    setState(() {
                      //spiner will stop when we enter teh chat screen
                      spiner = false;
                    });
                  } catch (e) {
                    toastMsgs(e.toString());
                    setState(() {
                      //spiner will stop when we enter teh chat screen
                      spiner = false;
                    });
                  }
                  //Implement login functionality.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
