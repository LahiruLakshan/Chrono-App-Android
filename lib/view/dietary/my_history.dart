import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dietary.dart';



class MyHistory extends StatefulWidget {
  static const String routeName = '/risk_level';
  final String? diabetesLevel;
  final String? cancerLevels;
  final String? obesityLevels;
  final String? cardiovascularLevels;
  final String? strokeLevels;
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => MyHistory(),
    );
  }

  const MyHistory(
      {Key? key, this.diabetesLevel, this.cancerLevels, this.obesityLevels, this.cardiovascularLevels, this.strokeLevels})
      : super(key: key);

  @override
  _MyHistoryState createState() =>
      _MyHistoryState();
}


class _MyHistoryState extends State<MyHistory> {
  late List<Map<dynamic, dynamic>> existingData = [];

  @override
  void initState() {
    super.initState();
    loadData().then((data) {
      setState(() {
        existingData = data ?? [];
      });
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("My History"),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/originals/06/38/c0/0638c03a05c4c636193a2eeb40f916c7.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Column(
                    children: existingData.map((value) {

                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${value["food"]}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[900],
                                  fontFamily: 'Raleway',
                                ),
                              ),
                              Text(
                                "${value["time"]}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.blue[900],
                                  fontFamily: 'Raleway',
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                        ],
                      );
                    }).toList(),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<List<Map<dynamic, dynamic>>?> loadData() async {
  final prefs = await SharedPreferences.getInstance();
  final jsonString = prefs.getString('history');
  if (jsonString != null) {
    final jsonData = json.decode(jsonString) as List;
    return jsonData.cast<Map<dynamic, dynamic>>();
  }
  return null;
}

void main() {
  runApp(MaterialApp(
    home: MyHistory(),
  ));
}
