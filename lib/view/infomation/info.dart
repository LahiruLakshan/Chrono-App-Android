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
        backgroundColor: Colors.blue[900], // Set the app bar color to blue 900
      ),
      body: SingleChildScrollView( // Make the page scrollable
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('https://i.pinimg.com/originals/06/38/c0/0638c03a05c4c636193a2eeb40f916c7.jpg'), // Replace with your image URL
              fit: BoxFit.cover, // You can adjust the fit as needed
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Image and text for "Chronic Diseases"
                _buildImageTextSection(
                  "Chronic Diseases:",
                  "assets/images/chronic.png", // Replace with your image asset path
                  "Chronic diseases, also known as non-communicable diseases (NCDs), are long-term health conditions that persist over an extended period of time, typically lasting for at least one year or more. These diseases often progress slowly and may not have immediate symptoms, but they can have a significant impact on an individual's quality of life and can lead to serious health complications if left unmanaged.",
                ),
                SizedBox(height: 16),

                // Image and text for "Heart Rate"
                _buildImageTextSection(
                  "Heart Rate:",
                  "assets/images/heart.png", // Replace with your image asset path
                  "Heart rate, often expressed in beats per minute (BPM), is a vital physiological parameter that measures the number of times the heart contracts or beats in a minute. It serves as a crucial indicator of overall cardiovascular health and can vary significantly between individuals based on factors such as age, fitness level, and emotional state. A resting heart rate, typically measured when a person is at rest and calm, tends to be lower and can range from 60 to 100 BPM in adults, with well-conditioned athletes often having lower resting heart rates due to their efficient cardiovascular systems. Physical activity, emotional stress, illness, and even medications can influence heart rate, causing it to increase temporarily.",
                ),
                SizedBox(height: 16),

                // Image and text for "Importance of Sleep"
                _buildImageTextSection(
                  "Importance of Sleep:",
                  "assets/images/sleep.png", // Replace with your image asset path
                  "Sleep is essential for physical and mental well-being. It plays a crucial role in healing and repairing the body, consolidating memories, and regulating mood. Quality sleep is necessary for overall health and productivity.",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageTextSection(String heading, String imagePath, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Image
        Image.asset(
          imagePath,
          width: 450, // Adjust the image width as needed
          height: 300, // Adjust the image height as needed
          fit: BoxFit.cover,
        ),
        SizedBox(height: 8),

        // Heading
        Text(
          heading,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),

        // Description
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}


void main() {
  runApp(MaterialApp(
    home: InformationPage(),
  ));
}
