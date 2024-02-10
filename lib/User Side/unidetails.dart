import 'package:flutter/material.dart';
import 'package:ups/User%20Side/university.dart';
import 'package:ups/widgets/responsive_button.dart';
import 'package:ups/widgets/responsive_button.dart'; // Import your ResponsiveButton class

class UniversityDetailPage extends StatelessWidget {
  final University university;

  const UniversityDetailPage({Key? key, required this.university, required universityName, required int uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(
              university.imagePath, // Display the university's image
              width: 100,
              height: 100,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              university.name, // Display the university's name
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Location: ${university.city}', // Display the university's location
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
           ResponsiveButton(
            requiredText: 'DEGREES', height: 0,
           ),
           ResponsiveButton(
            requiredText: 'ADMISSION', height: 0,
          ),
           ResponsiveButton(
            requiredText: 'FACULTY', height: 0,
          ),
           ResponsiveButton(
            requiredText: 'SCHOLARSHIPS', height: 0,
          ),
        ],
      ),
    );
  }
}
