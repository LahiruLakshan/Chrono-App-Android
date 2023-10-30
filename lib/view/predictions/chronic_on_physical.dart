import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    final apiUrl = Uri.parse('http://16.171.0.52:5000/predict_chronic_risk_on_physical');
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Physical Activity Risk Prediction', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://i.pinimg.com/originals/06/38/c0/0638c03a05c4c636193a2eeb40f916c7.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      child: _buildLabel('Enter Age:', labelTextStyle, Icons.person),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black38), // Border color
                        borderRadius: BorderRadius.circular(4), // Optional: for rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          controller: ageController,
                          decoration: InputDecoration(
                            border: InputBorder.none, // Remove the default border
                          ),
                        ),
                      ),
                    ),
                    _buildLabel('Select Gender:', labelTextStyle, Icons.accessibility),
                    _buildDropdown(['Male', 'Female'], selectedGender, (String? newValue) {
                      setState(() {
                        selectedGender = newValue!;
                      });
                    }),
                    _buildLabel('Select Physical Activity Level:', labelTextStyle, Icons.directions_run),
                    _buildDropdown(['Active', 'Inactive'], selectedCircadianRhythm, (String? newValue) {
                      setState(() {
                        selectedCircadianRhythm = newValue!;
                      });
                    }),
                    _buildLabel('Select Dietary Habit:', labelTextStyle, Icons.local_dining),
                    _buildDropdown(['Healthy', 'Poor'], selectedHabit, (String? newValue) {
                      setState(() {
                        selectedHabit = newValue!;
                      });
                    }),
                    _buildLabel('Select Stress Level:', labelTextStyle, Icons.sentiment_very_dissatisfied),
                    _buildDropdown(['High', 'Low'], selectedDietCaffeine, (String? newValue) {
                      setState(() {
                        selectedDietCaffeine = newValue!;
                      });
                    }),
                    _buildLabel('Select Stress Level:', labelTextStyle, Icons.sentiment_satisfied),
                    _buildDropdown(['High', 'Low'], selectedStressLevel, (String? newValue) {
                      setState(() {
                        selectedStressLevel = newValue!;
                      });
                    }),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: makePrediction,
                      child: Text('Predict Physical Activity Risk', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[900],
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
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
                          predictionResult.contains('Yes')
                              ? 'Predicted Physical Activity Risk: Yes'
                              : 'Predicted Physical Activity Risk: No',
                          style: TextStyle(
                            fontSize: 25,
                            color: predictionResult.contains('Yes')
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
        ],
      ),
    );
  }

  Widget _buildLabel(String label, TextStyle style, IconData iconData) {
    return AnimatedDefaultTextStyle(
      duration: Duration(milliseconds: 500),
      style: TextStyle(
        fontSize: 18,
        color: Colors.blue[900],
      ),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              size: 18,
              color: Colors.blue[900],
            ),
            SizedBox(width: 8),
            Text(
              label,
              style: style,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String selectedValue, void Function(String?) onChanged) {
    return Container(
      alignment: Alignment.center,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black38,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        onChanged: onChanged,
        items: items
            .map<DropdownMenuItem<String>>(
              (String value) => DropdownMenuItem<String>(
            value: value,
            child: Align( // Align the dropdown menu items to center
              alignment: Alignment.center,
              child: Text(
                value,
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChronicPhysical(),
  ));
}