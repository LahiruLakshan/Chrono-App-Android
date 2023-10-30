import 'dart:convert';
import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:chrono_app/view/dietary/risk_level_analysis.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadScreen extends StatefulWidget {
  static const String routeName = '/upload';
  final File? uploadImage;
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => UploadScreen(),
    );
  }

  const UploadScreen(
      {Key? key, this.uploadImage})
      : super(key: key);

  @override
  _UploadScreenState createState() =>
      _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String uri = "https://32b6-34-23-93-237.ngrok-free.app/upload";
  dynamic responseList;
  bool? isLoading = false;
  bool? isPredictionFinish = false;

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


  //
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    var padding = MediaQuery.of(context).padding;

    return Scaffold(
      appBar: AppBar(
        title: Text("Nutrition Scan with Prediction"),
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
                  Container(
                    height: 200.0,
                    width: width,
                    margin:
                    EdgeInsets.only(bottom: 30.0, left: 30.0, right: 30.0),
                    decoration: widget.uploadImage == null || widget.uploadImage == true
                        ? BoxDecoration(color:Colors.blue[900])
                        : BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(widget.uploadImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  if(isLoading! == false && isPredictionFinish! == false)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isLoading = true;
                        });
                        print("isLoading => ${isLoading}");
                        print("Upload Image => ${widget.uploadImage}");
                        uploadImage(widget.uploadImage!);
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
                        'Scan',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontFamily: 'Roboto', // Use a different font
                        ),
                      ),
                    ),
                  if(isLoading!)
                    LoadingAnimationWidget.prograssiveDots(
                      color: Colors.blue,
                      size: 100,
                    ),
                  if(isPredictionFinish!)
                    Column(
                      children: [
                        Center(
                          child: Text(
                            responseList["foodPrediction"],
                            style: TextStyle(
                              fontSize: 30,
                              color: Colors.blue[900], // Dark blue
                              fontFamily: 'Raleway ', // Use a different font
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "Probability = ${responseList["probability"]}%",
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.blue[900], // Dark blue
                              fontFamily: 'Raleway ', // Use a different font
                            ),
                          ),
                        ),
                      ],
                    ),


                  const SizedBox(height: 20),
                  if(isPredictionFinish!)
                    Column(
                      children: nutritionList.map((value) =>
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
                                  responseList["nutritionPrediction"][value["label"]].toString(),
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
                  SizedBox(height: 10),
                  if(isPredictionFinish!)
                    ElevatedButton(
                      onPressed: () async {
                        DateTime now = DateTime.now();
                        String formattedDate = DateFormat('kk:mm EEE d MMM').format(now);
                        final existingData = await loadData() ?? [];
                        existingData.add({"food":responseList["foodPrediction"], "time":formattedDate});
                        await saveData(existingData);


                        final double carbohydrate = responseList["nutritionPrediction"]["Carbohydrate"].toDouble();
                        final double cholesterol = responseList["nutritionPrediction"]["Cholesterol"].toDouble();
                        final double fiber = responseList["nutritionPrediction"]["Fiber"].toDouble();
                        final double protein = responseList["nutritionPrediction"]["Protein"].toDouble();
                        final double sugar = responseList["nutritionPrediction"]["Sugar"].toDouble();
                        final double fat = responseList["nutritionPrediction"]["Fat"].toDouble();
                        final double glyIndex = responseList["nutritionPrediction"]["Glycemic Index"].toDouble();
                        final String diabetesLevels =   diabetesLevelCalculate();
                        final String strokeLevels =   calculateStrokeRisk(carbohydrate, cholesterol, fiber, protein, sugar, fat);
                        final String cardiovascularLevels =   calculateCardiovascularRisk(carbohydrate, cholesterol, fiber, protein, sugar, fat);
                        final String obesityLevels =   calculateObesityRisk(carbohydrate, cholesterol, fiber, protein, sugar, fat);
                        final String cancerLevels =   calculateObesityRisk(carbohydrate, cholesterol, fiber, protein, sugar, fat);

                        final List nutritionList = [
                          {'label': 'Carbohydrate', 'value': carbohydrate},
                          {'label': 'Cholesterol', 'value': cholesterol},
                          {'label': 'Fiber', 'value': fiber},
                          {'label': 'Protein', 'value': protein},
                          {'label': 'Sugar', 'value': sugar},
                          {'label': 'Fat', 'value': fat},
                          {'label': 'Glycemic Index', 'value': glyIndex},

                          // Add more text items as needed
                        ];

                        final prefs = await SharedPreferences.getInstance();
                        final jsonData = nutritionList.map((item) => item).toList();
                        await prefs.setString('nutrition_data', json.encode(jsonData));


                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RiskLevelAnalysis(
                              diabetesLevel: diabetesLevels,
                              strokeLevels: strokeLevels,
                              cardiovascularLevels: cardiovascularLevels,
                              obesityLevels: obesityLevels,
                              cancerLevels: cancerLevels
                          )),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[900], // Dark blue
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // Rounded button
                        ),
                      ),
                      child: const Text(
                        'Risk Level Analysis',
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

  void saveNutritionData(List<Map<String, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonData = data.map((item) => item).toList();
    await prefs.setString('nutrition_data', json.encode(jsonData));
  }
  Future<void> saveData(List<Map<dynamic, dynamic>> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('history', json.encode(data));
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

  diabetesLevelCalculate() {
    double diabetes = responseList["nutritionPrediction"]["Carbohydrate"]*responseList["nutritionPrediction"]["Glycemic Index"]/100;
    print("diabetes level => $diabetes");
    if(diabetes <= 10.0){
      return "Low Risk";
    } else if(diabetes >10.0 && diabetes < 20){
      return "Medium Risk";
    } else{
      return "High Risk";
    }
  }

  calculateStrokeRisk(double carbohydrate, double cholesterol, double fiber, double protein, double sugar, double fat) {
    // Define weights for each nutrient (these are made up and not based on any scientific research)

    Map<String, double> weights = {
      'carbohydrate': 0.1,
      'cholesterol': 0.3,
      'fiber': -0.1,
      'protein': 0.1,
      'sugar': 0.2,
      'fat': 0.4,
    };

    // Calculate risk score
    double riskScore = (weights['carbohydrate']! * carbohydrate +
        weights['cholesterol']! * cholesterol +
        weights['fiber']! * fiber +
        weights['protein']! * protein +
        weights['sugar']! * sugar +
        weights['fat']! * fat);

    // Define risk levels
    String riskLevel;
    if (riskScore < 100) {
      riskLevel = "Low Risk";
    } else if (riskScore < 200) {
      riskLevel = "Medium Risk";
    } else {
      riskLevel = "High Risk";
    }

    return riskLevel;
  }

  calculateCardiovascularRisk(double carbohydrate, double cholesterol, double fiber, double protein, double sugar, double fat) {
    // Define weights for each nutrient (these are made up and not based on any scientific research)
    Map<String, double> weights = {
      'carbohydrate': 0.1,
      'cholesterol': 0.4,
      'fiber': -0.1,
      'protein': 0.1,
      'sugar': 0.2,
      'fat': 0.3,
    };

    // Calculate risk score
    double riskScore = (weights['carbohydrate']! * carbohydrate +
        weights['cholesterol']! * cholesterol +
        weights['fiber']! * fiber +
        weights['protein']! * protein +
        weights['sugar']! * sugar +
        weights['fat']! * fat);

    // Define risk levels
    String riskLevel;
    if (riskScore < 100) {
      riskLevel = "Low Risk";
    } else if (riskScore < 200) {
      riskLevel = "Medium Risk";
    } else {
      riskLevel = "High Risk";
    }

    return riskLevel;
  }

  calculateObesityRisk(double carbohydrate, double cholesterol, double fiber, double protein, double sugar, double fat) {
    // Define weights for each nutrient
    Map<String, double> weights = {
      'carbohydrate': 0.2,
      'cholesterol': 0.3,
      'fiber': -0.1,
      'protein': 0.1,
      'sugar': 0.3,
      'fat': 0.4,
    };

    // Calculate risk score
    double riskScore = (weights['carbohydrate']! * carbohydrate +
        weights['cholesterol']! * cholesterol +
        weights['fiber']! * fiber +
        weights['protein']! * protein +
        weights['sugar']! * sugar +
        weights['fat']! * fat);

    // Define risk levels
    String riskLevel;
    if (riskScore < 100) {
      riskLevel = "Low Risk";
    } else if (riskScore < 200) {
      riskLevel = "Medium Risk";
    } else {
      riskLevel = "High Risk";
    }

    return riskLevel;
  }


  calculateCancerRisk(double carbohydrate, double cholesterol, double fiber, double protein, double sugar, double fat) {
    // Define weights for each nutrient (these are made up and not based on any scientific research)
    Map<String, double> weights = {
      'carbohydrate': 0.1,
      'cholesterol': 0.3,
      'fiber': -0.1,
      'protein': 0.1,
      'sugar': 0.2,
      'fat': 0.3,
    };

    // Calculate risk score
    double riskScore = (weights['carbohydrate']! * carbohydrate +
        weights['cholesterol']! * cholesterol +
        weights['fiber']! * fiber +
        weights['protein']! * protein +
        weights['sugar']! * sugar +
        weights['fat']! * fat);

    // Define risk levels
    String riskLevel;
    if (riskScore < 100) {
      riskLevel = "Low Risk";
    } else if (riskScore < 200) {
      riskLevel = "Medium Risk";
    } else {
      riskLevel = "High Risk";
    }

    return riskLevel;
  }

}

void main() {
  runApp(MaterialApp(
    home: UploadScreen(),
  ));
}
