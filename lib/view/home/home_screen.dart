
import 'package:chrono_app/view/infomation/info.dart';
import 'package:chrono_app/view/predictions/physical_activity_screen.dart';
import 'package:chrono_app/view/signIn/sign_in_screen.dart';
import 'package:chrono_app/view/sleepPattern/sleep_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/reusable_widget.dart';

class HomeScreen extends StatefulWidget {

  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => HomeScreen(),
    );
  }

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<HomeScreen> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  String _steps = '0';
  String _pedestrianStatus = 'stopped';

  bool _permissionGranted = false;

  String _unit = 'Steps';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print('Event occurred: $event.toString()');
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(err) {
    print('Error occurred');
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print('Event occurred: $event.toString()');
    setState(() {
      _pedestrianStatus = event.status.toString();
    });
  }

  void onPedestrianStatusError(err) {
    print('Error occurred: $err');
    setState(() {
      _pedestrianStatus = 'unknown';
    });
  }

  Future<bool> checkPermission() async {
    if (await Permission.activityRecognition.request().isGranted) {
      return true;
    } else {
      return true;
    }
  }

  void initPlatformState() async {
    if (await checkPermission()) {
      setState(() { _permissionGranted = true; });

      setState(() {
        _steps = '0'; // Reset the steps count to 0
        _stepCountStream = Pedometer.stepCountStream;
        _stepCountStream
            .listen(onStepCount)
            .onError(onStepCountError);

        _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
        _pedestrianStatusStream
            .listen(onPedestrianStatusChanged)
            .onError(onPedestrianStatusError);
      });
    }

    if (!mounted) return;
  }

  String convertStepsTo(String unit) {
    switch (unit) {
      case 'Kilometers':
        return (int.parse(_steps) / 1300).toStringAsFixed(1);

      case 'Meters':
        return (int.parse(_steps) / 1.3).toStringAsFixed(1);

      case 'Centimeters':
        return (int.parse(_steps) / 0.013).toStringAsFixed(1);

      case 'Inches':
        return (int.parse(_steps) / 0.03).toStringAsFixed(1);

      case 'Feet':
        return (int.parse(_steps) / 0.4).toStringAsFixed(1);

      case 'Yard':
        return (int.parse(_steps) / 1.2).toStringAsFixed(1);

      case 'Miles':
        return (int.parse(_steps) / 2100).toStringAsFixed(1);
    }

    return _steps;
  }

  void showConfigPanel(BuildContext context) {
    ListTile generateOption(String unit, StateSetter setLocalState) {
      return ListTile(
          title: Text(unit),
          leading: Radio(
              value: unit,
              groupValue: _unit,
              onChanged: (value) {
                setLocalState(() {
                  _unit = value.toString();
                });

                setState(() {
                  _unit = value.toString();
                });
              }
          )
      );
    }

    AlertDialog alert = AlertDialog(
        title: const Text('Set unit'),
        content: StatefulBuilder(
            builder: (BuildContext state, StateSetter setState) {
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    generateOption('Steps', setState),
                    generateOption('Kilometers', setState),
                    generateOption('Feet', setState),
                    generateOption('Yards', setState),
                    generateOption('Miles', setState)
                  ]
              );
            }
        ),
        actions: <Widget>[
          TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              }
          )
        ]
    );

    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return alert;
        }
    );
  }

  PageRouteBuilder _customPageRouteBuilder(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero; // Ends at the center of the screen
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900], // Dark blue
        hintColor: Colors.blue[900], // Dark blue
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue[900], // Dark blue
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'CHRONO',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto', // Use a different font
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.settings,
                size: 32,
              ),
              onPressed: () {
                showConfigPanel(context);
              },
            )
          ],
        ),
        body: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://i.pinimg.com/474x/3c/a6/e0/3ca6e0da8cd7faabb845cf32aad51c90.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: _permissionGranted
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _unit == 'Steps' ? '$_unit taken:' : '$_unit walked:',
                style: TextStyle(
                  fontSize: _unit.length > 8 ? 32 : 48,
                  color: Colors.blue[900], // Dark blue
                  fontFamily: 'Raleway ', // Use a different font
                ),
              ),
              Text(
                convertStepsTo(_unit),
                style: TextStyle(
                  fontSize: convertStepsTo(_unit).length > 5 ? 64 : 128,
                  color: Colors.blue[900], // Dark blue
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Quicksand  ', // Use a different font
                ),
              ),
              const SizedBox(height: 14),
              Icon(
                _pedestrianStatus == 'stopped'
                    ? Icons.boy_rounded // Use a different icon
                    : _pedestrianStatus == 'walking'
                    ? Icons.directions_walk
                    : Icons.error_outline, // Use a different icon
                size: 128,
                color: Colors.blue[900], // Dark blue
              ),
              const SizedBox(height: 10),
              Text(
                _pedestrianStatus != 'unknown'
                    ? 'You are $_pedestrianStatus'
                    : 'Unknown pedestrian status',
                style: TextStyle(
                  color: Colors.blue[900], // Dark blue
                  fontSize: 18,
                  fontFamily: 'Roboto', // Use a different font
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, _customPageRouteBuilder(SleepPatternPredictionPage()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[900], // Dark blue
                  padding: const EdgeInsets.all(16),
                ),
                child: Container(
                  width: double.infinity, // Make the button width fill the parent
                  child: Center(
                    child: const Text(
                      'Sleep Pattern Prediction',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Roboto', // Use a different font
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, _customPageRouteBuilder(PhysicalPage()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[900],
                  padding: const EdgeInsets.all(16),
                  ),
                child: Container(
                  width: double.infinity,
                  child: Center(
                child: const Text(
                  'Anomaly Prediction',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'Roboto', // Use a different font
                  ),
                ),
              ),
              ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, _customPageRouteBuilder(InformationPage()));
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[900],
                  padding: const EdgeInsets.all(16),
                ),
                child: Container(
                  width: double.infinity,
                  child: Center(
                child: const Text(
                  'Information',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: 'Roboto', // Use a different font
                  ),
                ),
              ),),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut().then((value) {
                    loggedInUser = null; // Clear the logged-in user
                    Navigator.pushNamed(context, SignInScreen.routeName);
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue[900], // Dark blue
                  padding: const EdgeInsets.all(16),
                ),
                child: Container(
                  width: double.infinity, // Make the button width fill the parent
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.exit_to_app, // Add your desired icon
                          color: Colors.white,
                          size: 24, // Adjust the size as needed
                        ),
                        const SizedBox(width: 8), // Add spacing between icon and text
                        const Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontFamily: 'Roboto', // Use a different font
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
              : AlertDialog(
            title: Text(
              'Permission Denied',
              style: TextStyle(
                color: Colors.blue[900], // Use the same darker shade
              ),
            ),
            content: Text(
              'You must grant activity recognition permission to use this app',
              style: TextStyle(
                color: Colors.blue[900], // Use the same darker shade
              ),
            ),
          ),
        ),
      ),
    );
  }
}


