import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Global/Global.dart';
import '../User Side/programs.dart';

class ShowUniversity extends StatefulWidget {
  final int uid;

  ShowUniversity({required this.uid});

  @override
  _ShowUniversityState createState() => _ShowUniversityState();
}

class _ShowUniversityState extends State<ShowUniversity> {
  List<Map<String, dynamic>> university = [];

  @override
  void initState() {
    super.initState();
    handleUniversity();
  }

  Future<void> handleUniversity() async {
    try {
      print(widget.uid);

      final response = await http.get(
        Uri.parse('$ip/Admin/showuniversity?uid=${widget.uid}'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        setState(() {
          university = List<Map<String, dynamic>>.from(data);
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
        title: Text('University Data'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: university.isEmpty
              ? const Center(
            child: Text(
              'No university data available',
              style: TextStyle(fontSize: 24.0),
            ),
          )
              : Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: university.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = university[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Programs screen with university name

                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              (item['dname'] ?? 'Unknown').toString(),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            width: 4.0,
                          ),
                          Expanded(
                            child: Text(
                              (item['pname'] ?? 'Unknown').toString(),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            width: 4.0,
                          ),
                          Expanded(
                            child: Text(
                              (item['sdate'] ?? 'Unknown').toString(),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            width: 4.0,
                          ),

                          Expanded(
                            child: Text(
                              (item['edate'] ?? 'Unknown').toString(),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            width: 4.0,
                          ),
                          Expanded(
                            child: Text(
                              (item['Semester'] ?? 'Unknown').toString(),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                          const VerticalDivider(
                            color: Colors.grey,
                            width: 4.0,
                          ),
                          Expanded(
                            child: Text(
                              (item['amount'] ?? 'Unknown').toString(),
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

