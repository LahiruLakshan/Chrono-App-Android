import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chrono_app/view/signIn/sign_in_screen.dart';

class SignUpSuccessScreen extends StatefulWidget {
  const SignUpSuccessScreen({Key? key}) : super(key: key);

  @override
  State<SignUpSuccessScreen> createState() => _SignUpSuccessScreenState();
}

class _SignUpSuccessScreenState extends State<SignUpSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "You have Signed Up Successfully",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: const Text("Back to Login"),
              onPressed: () {
                FirebaseAuth .instance.signOut().then((value) {
                  print("Signed Out");
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()));
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
