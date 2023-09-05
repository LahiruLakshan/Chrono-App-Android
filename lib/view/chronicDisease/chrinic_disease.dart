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
    final apiUrl = Uri.parse('http://10.0.2.2:5000/predict_chronic_risk'); // Update the API URL
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
      ) {
    return Container(
      width: 300, // Adjust the width as needed
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center-align the labels
        children: [
          Text(
            labelText,
            style: textStyle.copyWith(color: Colors.blue[900]), // Apply the provided textStyle with blue[900] color
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
      ),
    );
  }

  Widget _buildStyledDropdown(
      String selectedValue,
      List<String> items,
      void Function(String?) onChanged,
      ) {
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStyledTextField(feature1Controller, 'Age', labelTextStyle),
                Text('Select Gender:', style: labelTextStyle.copyWith(color: Colors.blue[900])), // Apply the label text style
                _buildStyledDropdown(
                  selectedGender,
                  ['Male', 'Female'],
                      (String? newValue) {
                    setState(() {
                      selectedGender = newValue!;
                    });
                  },
                ),
                _buildStyledTextField(feature3Controller, 'BMI', labelTextStyle),
                _buildStyledTextField(feature4Controller, 'Blood Pressure (BP)', labelTextStyle),
                _buildStyledTextField(feature5Controller, 'High-Density Lipoprotein (HDL)', labelTextStyle),
                _buildStyledTextField(feature6Controller, 'Low-Density Lipoprotein (LDL)', labelTextStyle),
                Text('Do any family members have/had chronic disease:', style: labelTextStyle.copyWith(color: Colors.blue[900])), // Apply the label text style
                _buildStyledDropdown(
                  selectedFamilyHistory,
                  ['Yes', 'No'],
                      (String? newValue) {
                    setState(() {
                      selectedFamilyHistory = newValue!;
                    });
                  },
                ),
                Text(
                  'Are you a Smoker:',
                  style: labelTextStyle.copyWith(color: Colors.blue[900]),
                ),
                _buildStyledDropdown(
                  selectedSmoker,
                  ['Yes', 'No'],
                      (String? newValue) {
                    setState(() {
                      selectedSmoker = newValue!;
                    });
                  },
                ),
                _buildStyledTextField(feature9Controller, 'How long do you spend on physical activity in a day (minutes):', labelTextStyle), // Adjusted label text
                ElevatedButton(
                  onPressed: makeChronicRiskPrediction,
                  child: Text('Predict Chronic Risk', style: TextStyle(fontSize: 18)), // Apply the button text style
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue[900], // Set button background color to blue[900]
                    elevation: 4,
                  ),
                ),
                SizedBox(height: 20),
                Text(predictionResult),
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
