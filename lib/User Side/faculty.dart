import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Global/Global.dart';

class Faculty extends StatefulWidget {
  late String universityName;
  final int uid;

  Faculty({Key? key, required this.universityName, required this.uid})
      : super(key: key);

  @override
  State<Faculty> createState() => _FacultyState();
}

class _FacultyState extends State<Faculty> {
  List<dynamic> facultyData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final encodedUid = Uri.encodeComponent(widget.uid.toString());
      final response =
          await http.get(Uri.parse('$ip/Admin/showFaculty?uid=$encodedUid'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          facultyData = data;
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.universityName),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading showing the total faculty members count
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Faculty Ranks: ${facultyData.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          // ListView.builder for faculty data
          Expanded(
            child: ListView.builder(
              itemCount: facultyData.length,
              itemBuilder: (context, index) {
                final faculty = facultyData[index];
                return ListTile(
                  title: Text('Rank: ${faculty['Rank']}'),
                  subtitle: Text('Total: ${faculty['total']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
