import 'dart:async';

import 'package:chrono_app/utils/global.colors.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {

  static const String routeName = '/splash';

  const SplashView({super.key});

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const SplashView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () => Navigator.pushNamed(context, '/'));
    return Scaffold(
      backgroundColor: GlobalColors.mainColor,
      body: const Center(
        child: Text(
          'CHRONO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,  // Increased font size for a bold look
            fontWeight: FontWeight.bold,
            letterSpacing: 5,  // Increased letter spacing for a spaced-out effect
            shadows: [
              Shadow(
                color: Colors.black,
                offset: Offset(2, 2),  // Add shadow offset for depth
                blurRadius: 5,  // Add a slight blur to the shadow
              ),
            ],
            decoration: TextDecoration.underline,  // Add an underline decoration
            decorationColor: Colors.yellow,  // Color of the underline
            decorationThickness: 2,  // Thickness of the underline
          ),
        ),
      ),
    );
  }

}