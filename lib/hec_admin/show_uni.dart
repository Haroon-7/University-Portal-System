// Import necessary packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ups/login_signup/Model/login_model.dart';
import 'show_faculty.dart';
import 'show_programs.dart';
import 'show_scholarship.dart';
import '../Global/Global.dart';

class Universitydata extends StatefulWidget {
  final int uid;

  const Universitydata({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<Universitydata> createState() => _UniversitydataState();
}

class _UniversitydataState extends State<Universitydata> {
  String uName = '';

  @override
  void initState() {
    super.initState();
    getUniName();
  }

  Future<void> getUniName() async {
    try {
      print('Request URL: $ip/Login/uniname?uid=${widget.uid}');

      final response = await http.get(
        Uri.parse('$ip/Login/uniname?uid=${widget.uid}'),
        headers: {
          'Accept': 'application/json',
        },
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print('Data received: $data');
        setState(() {
          uName = data['u_name'];
        });
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Data'),
        // Display the university name in the AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              uName,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowUniversity(uid: widget.uid),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(150, 50), // Set the desired width and height
              ),
              child: const Text('Programs'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowFacultyHEC(uid: widget.uid),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(150, 50), // Set the desired width and height
              ),
              child: const Text('Faculty'),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowScholarship(uid: widget.uid),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(150, 50), // Set the desired width and height
              ),
              child: const Text('Scholarship'),
            ),
          ],
        ),
      ),
    );
  }
}
