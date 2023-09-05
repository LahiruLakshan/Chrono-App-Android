import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chrono_app/view/signUp/signup_success_screen.dart';
import 'package:chrono_app/widgets/reusable_widget.dart';

import '../../utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _confirmPasswordTextController = TextEditingController();
  String _errorMessage = "";

  bool _validatePassword() {
    return _passwordTextController.text == _confirmPasswordTextController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringToColor("#e6e6e6"),
              hexStringToColor("#f2f2f2"),
              hexStringToColor("#ffffff")
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                reusableTextField(
                  "Enter Username",
                  Icons.person_outline,
                  false,
                  _userNameTextController,
                ),
                const SizedBox(
                  height: 10,
                ),
                reusableTextField(
                  "Enter Email",
                  Icons.person_outline,
                  false,
                  _emailTextController,
                ),
                const SizedBox(
                  height: 10,
                ),
                reusableTextField(
                  "Enter Password",
                  Icons.person_outline,
                  true,
                  _passwordTextController,
                ),
                const SizedBox(
                  height: 10,
                ),
                reusableTextField(
                  "Confirm Password",
                  Icons.person_outline,
                  true,
                  _confirmPasswordTextController,
                ),
                const SizedBox(
                  height: 10,
                ),
                if (_errorMessage.isNotEmpty)
                  Text(
                    _errorMessage,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                signInSignUpButton(
                  context,
                  false,
                      () {
                    if (_userNameTextController.text.isEmpty) { // added validation
                      setState(() {
                        _errorMessage = "Please enter a username";
                      });
                    } else if (_validatePassword()) {
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                          .then((value) {
                        print("Created New Account");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SignUpSuccessScreen()));
                      }).onError((error, stackTrace) {
                        setState(() {
                          _errorMessage =
                          "The email or password(should be at least 6 characters ) you entered is not valid";
                        });
                      });
                    } else {
                      setState(() {
                        _errorMessage = "Passwords do not match";
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}