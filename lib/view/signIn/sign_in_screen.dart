import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chrono_app/view/home/home_screen.dart';
import 'package:chrono_app/view/signUp/sign_up_screen.dart';
import 'package:chrono_app/utils/color_utils.dart';

import '../../widgets/reusable_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => SignInScreen(),
    );
  }

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  String _errorText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(70,
              MediaQuery.of(context).size.height * 0.2, 70, 170,
            ),
            child: Column(
              children: <Widget>[
                logoWidget("assets/images/Chrono.png"),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _emailTextController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "Enter Email",
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.person_outline, color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _passwordTextController,
                  style: const TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Enter Password",
                    labelStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(Icons.lock_outline, color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                signInSignUpButton(context, true, () {
                  FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text, password: _passwordTextController.text).then((value) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  }).onError((error, stackTrace) {
                    setState(() {
                      _errorText = "Invalid email or password";
                    });
                  });
                }),
                signUpOption(),
                Text(
                  _errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? ",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(color: Colors.black, fontWeight:  FontWeight.bold),
          ),
        )
      ],
    );
  }
}
