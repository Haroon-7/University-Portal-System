import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Global/Global.dart';

class ShowScholarship extends StatefulWidget {
  final int uid;

  const ShowScholarship({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<ShowScholarship> createState() => _ShowScholarshipState();
}

class _ShowScholarshipState extends State<ShowScholarship> {
  List<Map<String, dynamic>> scholarships = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('$ip/Admin/showuniversityScholarship?uid=${widget.uid}'),
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
            (json.decode(response.body) as List).cast<Map<String, dynamic>>();
        setState(() {
          scholarships = data;
        });
      } else {
        print('Request failed');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scholarship Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: scholarships.isEmpty
            ? const Center(
                child: Text(
                  'Scholarship details not available',
                  style: TextStyle(fontSize: 24),
                ),
              )
            : ListView.builder(
                itemCount: scholarships.length,
                itemBuilder: (context, index) {
                  final scholarship = scholarships[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 15),
                    child: ListTile(
                      title: Text('Title: ${scholarship['title']},'),

                      subtitle:
                          Text('Description: ${scholarship['description']}'),
                      // Add more details as needed
                    ),
                  );
                },
              ),
      ),
    );
  }
}
