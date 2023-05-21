import 'package:flash_chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat_app/components/rounded_button.dart';
import 'package:flash_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart'; //step1
import 'chat_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance; //step 2
  String email = '';
  String password = '';
  bool spiner = false;

  void toastMsgs(String msg) {
    Fluttertoast.showToast(
        //build in msg pop from the pkg
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
                    hintText: 'Enter your Email ',
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
                    hintText: 'Enter your password ',
                  )),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                boxColor: Colors.blueAccent,
                text: 'Register',
                onpressed: () async {
                  setState(() {
                    spiner =
                        true; //when the user press the buttom after entering credencials
                  });

                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email.toString().trim(),
                        password: password.toString().trim());

                    if (newUser != null) {
                      Navigator.pushNamed(context, ChatScreen.id);
                      toastMsgs('user successfully registered');
                    }
                    setState(() {
                      spiner = false;
                    });
                  } catch (e) {
                    toastMsgs(e.toString());
                    setState(() {
                      //spiner will stop when we enter the false credencials
                      spiner = false;
                    });
                  }
                  //Implement registration functionality.
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
