import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ChronicPhysical extends StatefulWidget {
  static const String routeName = '/chronicOn';

    static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => ChronicPhysical(),
    );
  }

  @override
  _ChronicPhysicalState createState() => _ChronicPhysicalState();
}

class _ChronicPhysicalState extends State<ChronicPhysical> {
  TextEditingController ageController = TextEditingController();
  String selectedGender = 'Male';
  String selectedCircadianRhythm = 'Active';
  String selectedHabit = 'Healthy';
  String selectedDietCaffeine = 'Low';
  String selectedStressLevel = 'Low';

  String predictionResult = '';

  Future<void> makePrediction() async {
    final apiUrl = Uri.parse('http://10.0.2.2:5000/predict_chronic_risk_on_physical');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'feature1': int.tryParse(ageController.text) ?? 0,
      'feature2': selectedGender == 'Male' ? 1 : 0,
      'feature3': selectedCircadianRhythm == 'Inactive' ? 1 : 0,
      'feature4': selectedHabit == 'Healthy' ? 0 : 1,
      'feature5': selectedDietCaffeine == 'Low' ? 1 : 0,
      'feature6': selectedStressLevel == 'Low' ? 1 : 0,
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

@override
Widget build(BuildContext context) {
  final labelTextStyle = TextStyle(fontSize: 18, color: Colors.blue[900]);
  final dropdownTextStyle = TextStyle(fontSize: 18, color: Colors.blue[900]);
  final buttonStyle = ElevatedButton.styleFrom(
    primary: Colors.blue[900],
    textStyle: TextStyle(fontSize: 18),
  );

  return Scaffold(
    appBar: AppBar(
      title: Text('Chronic Risk Prediction', style: TextStyle(color: Colors.blue[900])),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.blue[900]),
    ),
    body: Stack( // Use a Stack to layer the background image behind the content
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://i.pinimg.com/originals/06/38/c0/0638c03a05c4c636193a2eeb40f916c7.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildLabel('Enter Age:', labelTextStyle),
                TextField(controller: ageController),
                _buildLabel('Select Gender:', labelTextStyle),
                DropdownButton<String>(
                  value: selectedGender,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                  items: <String>['Male', 'Female']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Center(child: Text(value, style: dropdownTextStyle)),
                    );
                  }).toList(),
                ),
            _buildLabel('Select Physical Activity Level:', labelTextStyle),
            DropdownButton<String>(
              value: selectedCircadianRhythm,
              onChanged: (String? newValue) {
                setState(() {
                  selectedCircadianRhythm = newValue!;
                });
              },
              items: <String>['Active', 'Inactive']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(child: Text(value, style: dropdownTextStyle)),
                );
              }).toList(),
            ),
            _buildLabel('Select Dietary Habit:', labelTextStyle),
            DropdownButton<String>(
              value: selectedHabit,
              onChanged: (String? newValue) {
                setState(() {
                  selectedHabit = newValue!;
                });
              },
              items: <String>['Healthy', 'Poor']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(child: Text(value, style: dropdownTextStyle)),
                );
              }).toList(),
            ),
            _buildLabel('Select Stress Level:', labelTextStyle),
            DropdownButton<String>(
              value: selectedDietCaffeine,
              onChanged: (String? newValue) {
                setState(() {
                  selectedDietCaffeine = newValue!;
                });
              },
              items: <String>['High', 'Low']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(child: Text(value, style: dropdownTextStyle)),
                );
              }).toList(),
            ),
            _buildLabel('Select Stress Level:', labelTextStyle),
            DropdownButton<String>(
              value: selectedStressLevel,
              onChanged: (String? newValue) {
                setState(() {
                  selectedStressLevel = newValue!;
                });
              },
              items: <String>['High', 'Low']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Center(child: Text(value, style: dropdownTextStyle)),
                );
              }).toList(),
            ),
            ElevatedButton(
                  onPressed: makePrediction,
                  child: Text('Predict Chronic Risk', style: TextStyle(color: Colors.white)),
                  style: buttonStyle,
                ),
                SizedBox(height: 20),
                Text(predictionResult, style: labelTextStyle),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}

Widget _buildLabel(String label, TextStyle style) {
  return Center(child: Text(label, style: style));
}

void main() {
  runApp(MaterialApp(
    home: ChronicPhysical(),
  ));
}