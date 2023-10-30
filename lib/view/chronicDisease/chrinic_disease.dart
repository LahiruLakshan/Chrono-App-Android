import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChronicDiseasePage extends StatefulWidget {
  static const String routeName = '/chronic';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ChronicDiseasePage(),
    );
  }

  @override
  _ChronicDiseasePageState createState() =>
      _ChronicDiseasePageState();
}

class _ChronicDiseasePageState extends State<ChronicDiseasePage> {
  TextEditingController feature1Controller = TextEditingController();
  String selectedGender = 'Male';
  TextEditingController feature3Controller = TextEditingController();
  TextEditingController feature4Controller = TextEditingController();
  TextEditingController feature5Controller = TextEditingController();
  TextEditingController feature6Controller = TextEditingController();
  String selectedFamilyHistory = 'No';
  String selectedSmoker = 'No';
  TextEditingController feature9Controller = TextEditingController();

  String predictionResult = '';

  Future<void> makeChronicRiskPrediction() async {
    final apiUrl = Uri.parse('http://16.171.0.52:5000/predict_chronic_risk'); // Update the API URL
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'Feature1': int.tryParse(feature1Controller.text) ?? 0,
      'Feature2': selectedGender == 'Male' ? 1 : 0,
      'Feature3': int.tryParse(feature3Controller.text) ?? 0,
      'Feature4': int.tryParse(feature4Controller.text) ?? 0,
      'Feature5': int.tryParse(feature5Controller.text) ?? 0,
      'Feature6': int.tryParse(feature6Controller.text) ?? 0,
      'Feature7': selectedFamilyHistory == 'No' ? 0 : 1,
      'Feature8': selectedSmoker == 'No' ? 0 : 1,
      'Feature9': int.tryParse(feature9Controller.text) ?? 0,
    });

    final response = await http.post(apiUrl, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final predictions = jsonResponse['predictions'];

      setState(() {
        predictionResult = 'Predicted Chronic Risk: ${predictions.join(", ")}';
      });
    } else {
      setState(() {
        predictionResult = 'Error: ${response.statusCode}';
      });
    }
  }

  Widget _buildStyledTextField(
      TextEditingController controller,
      String labelText,
      TextStyle textStyle,
      IconData iconData,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              iconData,
              color: Colors.blue[900],
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              labelText,
              style: textStyle.copyWith(color: Colors.black),
            ),
          ],
        ),
        SizedBox(height: 8), // Add some spacing between label and text field
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter Value',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildStyledDropdown(
      String labelText,
      String selectedValue,
      List<String> items,
      void Function(String?) onChanged,
      IconData iconData,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              iconData,
              color: Colors.blue[900],
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              labelText,
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          width: 400,
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
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              onChanged: onChanged,
              items: items
                  .map<DropdownMenuItem<String>>(
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
              )
                  .toList(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelTextStyle = TextStyle(fontSize: 18); // Define the label text style

    return Scaffold(
      appBar: AppBar(
        title: Text('Chronic Risk Prediction'),
        backgroundColor: Colors.blue[900], // Set AppBar color to blue[900]
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://i.pinimg.com/originals/06/38/c0/0638c03a05c4c636193a2eeb40f916c7.jpg'),
            fit: BoxFit.cover, // Adjust the fit property to cover the full page
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Align everything to the center
              children: [
                SizedBox(height: 16),
                _buildStyledTextField(
                  feature1Controller,
                  'Age',
                  labelTextStyle,
                  Icons.person,
                ),
                SizedBox(height: 16),
                _buildStyledDropdown(
                  'Gender',
                  selectedGender,
                  ['Male', 'Female'],
                      (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                  Icons.accessibility,
                ),
                SizedBox(height: 16),
                _buildStyledTextField(
                  feature3Controller,
                  'BMI',
                  labelTextStyle,
                  Icons.timeline,
                ),
                SizedBox(height: 16),
                _buildStyledTextField(
                  feature4Controller,
                  'Blood Pressure (BP)',
                  labelTextStyle,
                  Icons.favorite_border,
                ),
                SizedBox(height: 16),
                _buildStyledTextField(
                  feature5Controller,
                  'High-Density Lipoprotein (HDL)',
                  labelTextStyle,
                  Icons.favorite,
                ),
                SizedBox(height: 16),
                _buildStyledTextField(
                  feature6Controller,
                  'Low-Density Lipoprotein (LDL)',
                  labelTextStyle,
                  Icons.favorite_outline,
                ),
                SizedBox(height: 16),
                _buildStyledDropdown(
                  'Do your relative have/had chronic disease',
                  selectedFamilyHistory,
                  ['Yes', 'No'],
                      (String? newValue) {
                    setState(() {
                      selectedFamilyHistory = newValue!;
                    });
                  },
                  Icons.people,
                ),
                SizedBox(height: 16),
                _buildStyledDropdown(
                  'Are you a smoker',
                  selectedSmoker,
                  ['Yes', 'No'],
                      (String? newValue) {
                    setState(() {
                      selectedSmoker = newValue!;
                    });
                  },
                  Icons.smoking_rooms,
                ),
                SizedBox(height: 16),
                _buildStyledTextField(
                  feature9Controller,
                  'Physical Activities in a Day (minutes):',
                  labelTextStyle,
                  Icons.directions_run,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: makeChronicRiskPrediction,
                  child: Text('Predict Chronic Risk', style: TextStyle(fontSize: 18)), // Apply the button text style
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900], // Set button background color to blue[900]
                    elevation: 4,
                  ),
                ),
                SizedBox(height: 20),
                Visibility(
                  visible: predictionResult.isNotEmpty, // Only make the widget visible when predictionResult is not empty
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
                      style: TextStyle(
                        fontSize: 25,
                        color: predictionResult.contains('There is a Risk of Chronic Kidney Disease')
                            ? Colors.red.shade900 // Dark red for risk
                            : Colors.green.shade900, // Dark green for no risk
                        fontWeight: FontWeight.bold, // Make the text bold
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChronicDiseasePage(),
  ));
}
