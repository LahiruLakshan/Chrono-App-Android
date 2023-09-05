
import 'package:chrono_app/view/chronicDisease/chrinic_disease.dart';
import 'package:chrono_app/view/predictions/physical_activity_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:chrono_app/view/view.dart';

import '../view/home/home_screen.dart';
import '../view/infomation/info.dart';
import '../view/predictions/chronic_on_physical.dart';
import '../view/sleepPattern/sleep_pattern.dart';


class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    if (kDebugMode) {
      print('This is route: ${settings.name}');
    }

    switch (settings.name) {
      case SignInScreen.routeName:
        return SignInScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case SplashView.routeName:
        return SplashView.route();
      case PhysicalPage.routeName:
        return PhysicalPage.route();
      case SleepPatternPredictionPage.routeName:
        return SleepPatternPredictionPage.route();
      case ChronicDiseasePage.routeName:
        return ChronicDiseasePage.route();
      case InformationPage.routeName:
        return InformationPage.route();
      case ChronicPhysical.routeName:
        return ChronicPhysical.route();



      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
      ),
    );
  }
}

