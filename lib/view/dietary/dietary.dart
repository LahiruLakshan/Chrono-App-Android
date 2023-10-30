
import 'dart:convert';

import 'package:chrono_app/view/dietary/my_history.dart';
import 'package:chrono_app/view/dietary/upload_screen.dart';
import 'package:chrono_app/view/infomation/info.dart';
import 'package:chrono_app/view/predictions/physical_activity_screen.dart';
import 'package:chrono_app/view/sleepPattern/sleep_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:async';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';


class DietaryPage extends StatefulWidget {

  static const String routeName = '/dietary';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => DietaryPage(),
    );
  }

  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<DietaryPage> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;

  String _steps = '0';
  String _pedestrianStatus = 'stopped';

  bool _permissionGranted = false;

  String _unit = 'Steps';
  File? uploadImage;
  late List<Map<dynamic, dynamic>> existingNutritionData = [
    {'label': 'Carbohydrate', 'value': '2.3'},
    {'label': 'Cholesterol', 'value': '4.5'},
    {'label': 'Fiber', 'value': '6.7'},
    {'label': 'Protein', 'value': '2.3'},
    {'label': 'Sugar', 'value': '4.5'},
    {'label': 'Fat', 'value': '6.7'},
    {'label': 'Glycemic Index', 'value': '6.7'},

    // Add more text items as needed
  ];
  @override
  void initState() {
    super.initState();
    initPlatformState();
    loadData().then((data) {
      setState(() {
        existingNutritionData = data ?? [];
      });
    });
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
      return false;
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

  final List nutritionList = [
    {'label': 'Carbohydrate', 'value': '2.3'},
    {'label': 'Cholesterol', 'value': '4.5'},
    {'label': 'Fiber', 'value': '6.7'},
    {'label': 'Protein', 'value': '2.3'},
    {'label': 'Sugar', 'value': '4.5'},
    {'label': 'Fat', 'value': '6.7'},
    {'label': 'Glycemic Index', 'value': '6.7'},

    // Add more text items as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dietary Monitoring'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://i.pinimg.com/originals/06/38/c0/0638c03a05c4c636193a2eeb40f916c7.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: _permissionGranted
              ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        // Navigator.of(context).pop(ImageSource.camera);
                        // final source = await showImageSource(context);
                        // if (source == null) return;
                        // print(source);
                        await pickImage(ImageSource.camera);

                        if(uploadImage!.path.isNotEmpty){
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UploadScreen(uploadImage: uploadImage)),
                          );
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[900], // Dark blue
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // Rounded button
                        ),
                      ),
                      child: const Text(
                        'Camera',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Roboto', // Use a different font
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await pickImage(ImageSource.gallery);

                        if(uploadImage!.path.isNotEmpty){
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UploadScreen(uploadImage: uploadImage)),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[900], // Dark blue
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // Rounded button
                        ),
                      ),
                      child: const Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Roboto', // Use a different font
                        ),
                      ),
                    ),
                  ],
                ),
              ),



              Center(
                child: Text(
                  "Status of last food",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.blue[900], // Dark blue
                    fontFamily: 'Raleway ', // Use a different font
                  ),
                ),
              ),
              Column(
                children: existingNutritionData.map((value) =>
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            value["label"],
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue[900], // Dark blue
                              fontFamily: 'Raleway ', // Use a different font
                            ),
                          ),
                          Text(
                            value["value"].toString(),
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blue[900], // Dark blue
                              fontFamily: 'Raleway ', // Use a different font
                            ),
                          ),
                        ],
                      ),
                    ),
                ).toList(),
              ),
              const SizedBox(height: 32),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) {
                          return MyHistory();
                        },
                          settings: RouteSettings(name: 'MyHistory',),
                        ));

                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900], // Dark blue
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25), // Rounded button
                    ),
                  ),
                  child: const Text(
                    'My History >>',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: 'Roboto', // Use a different font
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

  Future<List<Map<String, dynamic>>?> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('nutrition_data');
    if (jsonString != null) {
      final jsonData = json.decode(jsonString) as List;
      return jsonData.cast<Map<String, dynamic>>();
    }
    return null;
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      print("imageTemporary => $imageTemporary");
      setState(() {
        uploadImage = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed ro pick image => $e");
    }
  }


  Future<ImageSource?> showImageSource(BuildContext context) async {
    if (Platform.isIOS) {
      return showCupertinoModalPopup<ImageSource>(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () =>
                      Navigator.of(context).pop(ImageSource.camera),
                  child: Text("Camera")),
              CupertinoActionSheetAction(
                  onPressed: () =>
                      Navigator.of(context).pop(ImageSource.gallery),
                  child: Text("Gallery"))
            ],
          ));
    } else {
      return showModalBottomSheet(
          backgroundColor: Colors.blue[900],
          context: context,
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Camera"),
                onTap: () {
                  print("Camera");
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Gallery"),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              )
            ],
          ));
    }
  }

}


void main() {
  runApp(MaterialApp(
    home: DietaryPage(),
  ));
}
