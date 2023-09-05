import 'package:flutter/material.dart';

class InformationPage extends StatelessWidget {

  static const String routeName = '/info';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => InformationPage(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Information Page"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Title:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Your information goes here.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Subtitle:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "More details about the information.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Additional Information:",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Any extra information can be added here.",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InformationPage(),
  ));
}
