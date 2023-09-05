import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    Uri.parse('http://10.0.2.2:5000/predict_heart_rate'); // Replace with your API endpoint
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

  @override
  Widget build(BuildContext context) {
    final labelTextStyle = TextStyle(fontSize: 18, color: Colors.blue[900]);

    return Scaffold(
      appBar: AppBar(title: Text('Anomaly Prediction'), backgroundColor: Colors.blue[900]),
      body: Container( // Use a Container for the background image
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/originals/06/38/c0/0638c03a05c4c636193a2eeb40f916c7.jpg'), // Replace with your image URL
            fit: BoxFit.cover, // You can adjust the fit as needed
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: _buildLabel('Select Heart Rate:', labelTextStyle)),
                Center(child: _buildStyledDropdown(
                  selectedHeartRate,
                  ['High', 'Low', 'Medium'],
                      (String? newValue) {
                    setState(() {
                      selectedHeartRate = newValue!;
                    });
                  },
                  labelTextStyle: labelTextStyle,
                )),
                Center(child: _buildLabel('Select Activity:', labelTextStyle)),
                Center(child: _buildStyledDropdown(
                  selectedActivity,
                  ['Cycling', 'Walking', 'Running'],
                      (String? newValue) {
                    setState(() {
                      selectedActivity = newValue!;
                    });
                  },
                  labelTextStyle: labelTextStyle,
                )),
                Center(child: _buildStyledTextField(feature3Controller, 'Age', labelTextStyle)),
                Center(child: Text('Select Gender:', style: labelTextStyle)),
                Center(child: _buildStyledDropdown(
                  selectedGender,
                  ['Male', 'Female'],
                      (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                  labelTextStyle: labelTextStyle,
                )),
                Center(child: Text('Select Your Medical History:', style: labelTextStyle)),
                Center(child: _buildStyledDropdown(
                  selectedMedicalH,
                  ['None', 'Allergies', 'Asthma', 'Cancer', 'Diabetes', 'Heart disease', 'Hypertension'],
                      (String? newValue) {
                    setState(() {
                      selectedMedicalH = newValue!;
                    });
                  },
                  labelTextStyle: labelTextStyle,
                )),
                Center(child: _buildButton('Predict Anomality', makeHeartRatePrediction)),
                SizedBox(height: 20),
                _buildResultText(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, TextStyle style) {
    return Text(
      text,
      style: style,
    );
  }

  Widget _buildStyledTextField(
      TextEditingController controller,
      String labelText,
      TextStyle labelTextStyle,
      ) {
    return Container(
      width: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            labelText,
            style: labelTextStyle,
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
      }) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black38,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.blue[900],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center align content
          children: [
            DropdownButton<String>(
              isExpanded: true,
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
          ],
        ),
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
      ),
    );
  }

  Widget _buildResultText() {
    return Text(
      predictionResult,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 18),
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: PhysicalPage(),
  ));
}
