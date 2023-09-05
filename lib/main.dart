import 'package:chrono_app/view/home/home_screen.dart';
import 'package:chrono_app/view/signIn/sign_in_screen.dart';
import 'package:chrono_app/view/splash.view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'config/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check if the user is already authenticated
  final user = FirebaseAuth.instance.currentUser;

  runApp(MyApp(user: user));
}

class MyApp extends StatelessWidget {
  final User? user;

  const MyApp({Key? key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      // User is already authenticated, start from HomeScreen
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chrono',
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: HomeScreen.routeName,
      );
    } else {
      // User is not authenticated, start from SignInScreen
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chrono',
        onGenerateRoute: AppRouter.onGenerateRoute,
        initialRoute: SplashView.routeName,
        home: SignInScreen(),
      );
    }
  }
}







