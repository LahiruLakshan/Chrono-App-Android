import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 330,
    height: 240,
  );
}

User? loggedInUser;

void checkUserLoggedIn() {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  loggedInUser = _auth.currentUser;
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.black,
    style: TextStyle(color: Colors.black.withOpacity(0.9)),
    decoration: InputDecoration(prefixIcon: Icon(icon, color: Colors.black87,),
        labelText: text,
        labelStyle: TextStyle(color: Colors.black87.withOpacity(0.9)),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Colors.white54.withOpacity(0.3),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: const BorderSide(width: 2,style: BorderStyle.none))
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container signInSignUpButton(
    BuildContext context, bool isLogin, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        isLogin ? 'LOG IN' : 'SIGN UP',
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.black26;
          }
          return Colors.blue;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    ),
  );
}