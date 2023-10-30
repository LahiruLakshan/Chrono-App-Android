import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'chronic_on_physical.dart';


class PhysicalPage extends StatefulWidget {
  static const String routeName = '/physical';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => PhysicalPage(),
    );
  }

  @override
  _PhysicalPageState createState() =>
      _PhysicalPageState();
}

class _PhysicalPageState extends State<PhysicalPage> {
  String selectedHeartRate = 'High';
  String selectedActivity = 'Walking';
  String selectedGender = 'Male';
  String selectedMedicalH = 'None';
  TextEditingController feature3Controller = TextEditingController();

  String predictionResult = '';

  Future<void> makeHeartRatePrediction() async {
    final apiUrl =
    Uri.parse('http://16.171.0.52:5000/predict_heart_rate');
    final headers = {'Content-Type': 'application/json'};

    int selectedHeartRate1;
    if (selectedHeartRate == 'High') {
      selectedHeartRate1 = 0;
    } else if (selectedHeartRate == 'Medium') {
      selectedHeartRate1 = 2;
    } else {
      selectedHeartRate1 = 1;
    }

    int selectedMedicalH1;
    if (selectedMedicalH == 'Allergies') {
      selectedMedicalH1 = 0;
    } else if (selectedMedicalH == 'Asthma') {
      selectedMedicalH1 = 1;
    } else if (selectedMedicalH == 'Cancer') {
      selectedMedicalH1 = 2;
    } else if (selectedMedicalH == 'Diabetes') {
      selectedMedicalH1 = 3;
    } else if (selectedMedicalH == 'Heart disease') {
      selectedMedicalH1 = 4;
    } else if (selectedMedicalH == 'Hypertension') {
      selectedMedicalH1 = 5;
    } else {
      selectedMedicalH1 = 6;
    }

    int selectedActivity1;
    if (selectedActivity == 'Cycling') {
      selectedActivity1 = 0;
    } else if (selectedActivity == 'Walking') {
      selectedActivity1 = 2;
    } else {
      selectedActivity1 = 1;
    }

    final body = jsonEncode({
      'Feature1': selectedHeartRate1,
      'Feature2': selectedActivity1,
      'Feature3': int.tryParse(feature3Controller.text) ?? 0,
      'Feature4': selectedGender == 'Male' ? 1 : 0,
      'Feature5': selectedMedicalH1,
    });

    final response = await http.post(apiUrl, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final predictions = jsonResponse['predictions'];

      setState(() {
        predictionResult = 'Heart Rate Prediction: ${predictions.join(", ")}';
      });
    } else {
      setState(() {
        predictionResult = 'Error: ${response.statusCode}';
      });
    }
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
    final labelTextStyle = TextStyle(fontSize: 18, color: Colors.blue[900]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Anomaly Prediction'),
        backgroundColor: Colors.blue[900],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://i.pinimg.com/originals/06/38/c0/0638c03a05c4c636193a2eeb40f916c7.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView( // Wrap your Column with SingleChildScrollView
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: _buildStyledDropdown(
                      selectedHeartRate,
                      ['High', 'Low', 'Medium'],
                          (String? newValue) {
                        setState(() {
                          selectedHeartRate = newValue!;
                        });
                      },
                      labelText: 'Select Heart Rate',
                      labelTextStyle: labelTextStyle,
                      iconData: Icons.favorite,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _buildStyledDropdown(
                      selectedActivity,
                      ['Cycling', 'Walking', 'Running'],
                          (String? newValue) {
                        setState(() {
                          selectedActivity = newValue!;
                        });
                      },
                      labelText: 'Select Activity',
                      labelTextStyle: labelTextStyle,
                      iconData: Icons.directions_run,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _buildStyledTextField(
                      feature3Controller,
                      'Age',
                      labelTextStyle,
                      Icons.person,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _buildStyledDropdown(
                      selectedGender,
                      ['Male', 'Female'],
                          (String? newValue) {
                        setState(() {
                          selectedGender = newValue!;
                        });
                      },
                      labelText: 'Select Gender',
                      labelTextStyle: labelTextStyle,
                      iconData: Icons.accessibility,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _buildStyledDropdown(
                      selectedMedicalH,
                      [
                        'None',
                        'Allergies',
                        'Asthma',
                        'Cancer',
                        'Diabetes',
                        'Heart disease',
                        'Hypertension'
                      ],
                          (String? newValue) {
                        setState(() {
                          selectedMedicalH = newValue!;
                        });
                      },
                      labelText: 'Select Your Medical History',
                      labelTextStyle: labelTextStyle,
                      iconData: Icons.healing,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: _buildButton('Predict Anomaly', makeHeartRatePrediction),
                  ),
                  SizedBox(height: 20),
                  _buildResultText(),
                  SizedBox(height: 20),
                  _buildButton(
                    'Physical Activity Risk Prediction',
                        () {
                      Navigator.push(context, _customPageRouteBuilder(ChronicPhysical()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildStyledTextField(
      TextEditingController controller,
      String labelText,
      TextStyle labelTextStyle,
      IconData iconData, // Add this parameter
      ) {
    return Container(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row( // Use a Row to display the icon and label
            children: [
              Icon(
                iconData,
                color: Colors.blue[900],
                size: 18,
              ),
              SizedBox(width: 8),
              Text(
                labelText,
                style: labelTextStyle,
              ),
            ],
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter Value',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyledDropdown(
      String selectedValue,
      List<String> items,
      void Function(String?) onChanged, {
        required TextStyle labelTextStyle,
        String? labelText, // Add this parameter
        IconData? iconData, // Add this parameter
      }) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black38,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (iconData != null)
                Icon(
                  iconData,
                  color: Colors.blue[900],
                  size: 18,
                ),
              if (iconData != null)
                SizedBox(width: 8),
              Text(
                labelText ?? '',
                style: labelTextStyle,
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black38,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Align(
              alignment: Alignment.center,
              child: DropdownButton<String>(
                value: selectedValue,
                onChanged: onChanged,
                items: items.map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Center(
                      child: Text(
                        value,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ).toList(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildButton(
      String label,
      Function() onPressed,
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(fontSize: 18),
      ),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue[900],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0), // Adjust the radius as needed
        ),
      ),
    );
  }

  Widget _buildResultText() {
    if (predictionResult.isEmpty) {
      // If predictionResult is empty, return an empty container with zero opacity
      return AnimatedOpacity(
        duration: Duration(milliseconds: 500), // Set the duration of the opacity transition
        opacity: 0.0, // Make the container invisible
        child: Container(),
      );
    }

    Color textColor;
    FontWeight fontWeight = FontWeight.bold; // Set the font weight to bold

    if (predictionResult.contains('Normal')) {
      textColor = Colors.green.shade900;
    } else if (predictionResult.contains('Abnormal')) {
      textColor = Colors.red.shade900;
    } else {
      textColor = Colors.black;
      fontWeight = FontWeight.normal;
    }

    return AnimatedOpacity(
      duration: Duration(milliseconds: 500), // Set the duration of the opacity transition
      opacity: 1.0, // Make the container fully visible
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Text(
          predictionResult,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, color: textColor, fontWeight: fontWeight),
        ),
      ),
    );
  }

}


void main() {
  runApp(MaterialApp(
    home: PhysicalPage(),
  ));
}
