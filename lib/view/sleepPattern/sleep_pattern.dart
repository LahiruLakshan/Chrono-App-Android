import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'package:chrono_app/view/chronicDisease/chrinic_disease.dart';
import 'package:flutter/material.dart';

class SleepPatternPredictionPage extends StatefulWidget {
  static const String routeName = '/sleep';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SleepPatternPredictionPage(),
    );
  }

  @override
  _SleepPatternPredictionPageState createState() =>
      _SleepPatternPredictionPageState();
}

class _SleepPatternPredictionPageState extends State<SleepPatternPredictionPage> {
  TextEditingController ageController = TextEditingController();
  String selectedGender = 'Male'; // Default gender value ("Male" or "Female")
  String selectedCircadianRhythm = 'Regular';
  String selectedDietCaffeine = 'Low';
  TextEditingController exerciseHoursController = TextEditingController();
  String selectedStressLevel = 'Low';
  TextEditingController sleepDurationController = TextEditingController();


  String predictionResult = '';

  Future<void> makePrediction() async {
    final apiUrl = Uri.parse('http://10.0.2.2:5000/predict');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'Age': int.tryParse(ageController.text) ?? 0,
      'Gender': selectedGender == 'Male' ? 1 : 0, // Map the selected gender to 0 or 1
      'Circadian_Rhythm': selectedCircadianRhythm == 'Regular' ? 1 : 0,
      'Exercise_Hours': int.tryParse(exerciseHoursController.text) ?? 0,
      'Diet_Caffeine': selectedDietCaffeine == 'Low' ? 1 : 0,
      'Stress_Level': selectedStressLevel == 'Low' ? 1 : 0,
      'Sleep_Duration': double.tryParse(sleepDurationController.text) ?? 0.0,
    });

    final response = await http.post(apiUrl, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final predictions = jsonResponse['predictions'];

      setState(() {
        predictionResult = 'Predicted Sleep Quality: ${predictions.join(", ")}';
      });
    } else {
      setState(() {
        predictionResult = 'Error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Quality Prediction'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://i.pinimg.com/474x/eb/78/ea/eb78ea508a985f4187efa77b5feebee3.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildLabel('Enter Age:'),
                  _buildTextField(ageController),
                  _buildLabel('Select Gender:'),
                  _buildGenderDropdown(),
                  _buildLabel('Select Circadian Rhythm:'),
                  _buildCircadianRhythmDropdown(),
                  _buildLabel('Enter Exercise Hours:'),
                  _buildTextField(exerciseHoursController),
                  _buildLabel('Select Diet Caffeine:'),
                  _buildDietCaffeineDropdown(),
                  _buildLabel('Select Stress Level:'),
                  _buildStressLevelDropdown(),
                  _buildLabel('Enter Sleep Duration:'),
                  _buildTextField(sleepDurationController),
                  SizedBox(height: 20),
                  _buildButton('Predict Sleep Quality', makePrediction),
                  SizedBox(height: 20),
                  _buildResultText(),
                  SizedBox(height: 20),
                  _buildButton(
                    'Chronic Disease Risk Prediction',
                        () {
                      Navigator.pushNamed(context, ChronicDiseasePage.routeName);
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

Widget _buildLabel(String text) {
  return AnimatedDefaultTextStyle(
    duration: Duration(milliseconds: 500),
    style: TextStyle(
      fontSize: 18,
      color: Colors.blue[900],
    ),
    child: Text(text),
  );
}

Widget _buildTextField(TextEditingController controller) {
  return Container(
    width: 200, // Adjust the width as needed
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Enter value',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number, // Allow only numeric input
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only digits
      ],
    ),
  );
}

  Widget _buildStyledDropdown(
      String selectedValue,
      List<String> items,
      void Function(String?) onChanged,
      ) {
    return Container(
      width: 200,
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
    );
  }

  Widget _buildCircadianRhythmDropdown() {
    return _buildStyledDropdown(
      selectedCircadianRhythm,
      ['Irregular', 'Regular'],
          (String? newValue) {
        setState(() {
          selectedCircadianRhythm = newValue!;
        });
      },
    );
  }

  Widget _buildGenderDropdown() {
    return _buildStyledDropdown(
      selectedGender,
      ['Male', 'Female'],
          (String? newValue) {
        setState(() {
          selectedGender = newValue!;
        });
      },
    );
  }

  Widget _buildDietCaffeineDropdown() {
    return _buildStyledDropdown(
      selectedDietCaffeine,
      ['High', 'Low'],
          (String? newValue) {
        setState(() {
          selectedDietCaffeine = newValue!;
        });
      },
    );
  }

  Widget _buildStressLevelDropdown() {
    return _buildStyledDropdown(
      selectedStressLevel,
      ['High', 'Low'],
          (String? newValue) {
        setState(() {
          selectedStressLevel = newValue!;
        });
      },
    );
  }

  Widget _buildButton(String label, Function() onPressed) {
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
    home: SleepPatternPredictionPage(),
  ));
}
