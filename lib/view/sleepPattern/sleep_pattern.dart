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

final Map<String, IconData> labelIcons = {
  'Enter Age:': Icons.person,
  'Select Gender:': Icons.person_outline,
  'Select Circadian Rhythm:': Icons.access_alarm,
  'Enter Exercise Hours:': Icons.directions_run,
  'Select Diet Caffeine:': Icons.fastfood,
  'Select Stress Level:': Icons.sentiment_very_satisfied,
  'Enter Sleep Duration:': Icons.access_time,
};

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
    final apiUrl = Uri.parse('http://16.171.0.52:5000/predict');
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep Quality Prediction'),
        backgroundColor: Colors.blue[900],
      ),
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
              image: DecorationImage(
              image: NetworkImage('https://i.pinimg.com/474x/eb/78/ea/eb78ea508a985f4187efa77b5feebee3.jpg'),
              fit: BoxFit.cover,
           ),
         ),
        ),

      SingleChildScrollView(
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
                          Navigator.push(context, _customPageRouteBuilder(ChronicDiseasePage()));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),],
      ),
    );
  }

  Widget _buildLabel(String text) {
    final icon = labelIcons[text]; // Get the corresponding icon
    return AnimatedDefaultTextStyle(
      duration: Duration(milliseconds: 500),
      style: TextStyle(
        fontSize: 18,
        color: Colors.blue[900],
      ),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center the Row horizontally
          children: [
            if (icon != null) // If there's a corresponding icon, display it
              Icon(
                icon,
                size: 18,
                color: Colors.blue[900],
              ),
            SizedBox(width: 8), // Add some spacing between the icon and text
            Text(text),
          ],
        ),
      ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Adjust the radius as needed
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

    if (predictionResult.contains('Excellent')) {
      textColor = Colors.green.shade900;
    } else if (predictionResult.contains('Good')) {
      textColor = Colors.blue.shade900;
    } else if (predictionResult.contains('Poor')) {
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
    home: SleepPatternPredictionPage(),
  ));
}
