import 'dart:convert';

import 'package:chrono_app/view/dietary/personalized_recommendations.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class RiskLevelAnalysis extends StatefulWidget {
  static const String routeName = '/risk_level';
  final String? diabetesLevel;
  final String? cancerLevels;
  final String? obesityLevels;
  final String? cardiovascularLevels;
  final String? strokeLevels;
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => RiskLevelAnalysis(),
    );
  }

  const RiskLevelAnalysis(
      {Key? key, this.diabetesLevel, this.cancerLevels, this.obesityLevels, this.cardiovascularLevels, this.strokeLevels})
      : super(key: key);

  @override
  _RiskLevelAnalysisState createState() =>
      _RiskLevelAnalysisState();
}

class _RiskLevelAnalysisState extends State<RiskLevelAnalysis> {
  String uri = "https://88da-35-196-228-198.ngrok-free.app/upload";
  dynamic responseList;
  bool? isLoading = false;
  bool? isPredictionFinish = false;




  //
  @override
  Widget build(BuildContext context) {
    final List nutritionList = [
      {'label': 'Diabetes', 'value': widget.diabetesLevel},
      {'label': 'Cardiovascular ', 'value': widget.cardiovascularLevels},
      {'label': 'Cancer', 'value': widget.cancerLevels},
      {'label': 'Stroke', 'value': widget.strokeLevels},
      {'label': 'Obesity', 'value': widget.obesityLevels},

      // Add more text items as needed
    ];

    double width = MediaQuery.of(context).size.width;
    var padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        title: Text("Risk Level Analysis"),
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
                    children: nutritionList.map((value) =>
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                value["value"],
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
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PersonalizedRecommendations(
                            diabetesLevel: widget.diabetesLevel,
                            strokeLevels: widget.strokeLevels,
                            cardiovascularLevels: widget.cardiovascularLevels,
                            obesityLevels: widget.obesityLevels,
                            cancerLevels: widget.cancerLevels
                        )),
                      );
                      // Navigator.pushNamed(context, UploadScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue[900], // Dark blue
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25), // Rounded button
                      ),
                    ),
                    child: const Text(
                      'Personalized Recommendations',
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
          ),
        ),
      ),
    );
  }

  void uploadImage(File uploadImage) async {
    final request = http.MultipartRequest("POST", Uri.parse(uri));
    final headers = {"Content-type": "multipart/form-data"};

    request.files.add(http.MultipartFile(
        'image',
        uploadImage.readAsBytes().asStream(),
        uploadImage.lengthSync(),
        filename: uploadImage.path.split("/").last
    ));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    print("Response => $resJson");
    setState(() {
      responseList = resJson;
      isLoading = false;
      isPredictionFinish = true;
    });
    print("foodPrediction => ${responseList["foodPrediction"]}");
    print("nutritionPrediction => ${responseList["nutritionPrediction"]}");
    print("nutritionPrediction => ${responseList["nutritionPrediction"]["Carbohydrate"]}");

  }
}

void main() {
  runApp(MaterialApp(
    home: RiskLevelAnalysis(),
  ));
}
