import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Global/Global.dart';

class Scholarship extends StatefulWidget {
  final String universityName;
  final int uid;

   Scholarship({Key? key, required this.universityName, required this.uid}) : super(key: key);

  @override
  State<Scholarship> createState() => _ScholarshipState();
}

class _ScholarshipState extends State<Scholarship> {
  List<Map<String, dynamic>> scholarships = [];

  @override
  void initState() {
    super.initState();
    fetchScholarships();
  }

  Future<void> fetchScholarships() async {
    final String apiUrl = '$ip/Admin/showuniversityScholarship';

    try {
      final response = await http.get(Uri.parse('$apiUrl?uid=${widget.uid}'));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          scholarships = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.universityName),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: scholarships.length,
        itemBuilder: (context, index) {
          final scholarship = scholarships[index];
          return ListTile(
            title: Text(scholarship['title']),
            subtitle: Text(scholarship['description']),
          );
        },
      ),
    );
  }
}
