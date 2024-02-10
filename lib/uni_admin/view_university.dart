import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ups/Global/Global.dart';

class ShowUniversity extends StatefulWidget {
  final String uid;

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
        Uri.parse('$ip/UniversityPortalSystem/api/Admin/showuniversity?uid=${widget.uid}'),
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
      body: Container(
        margin: EdgeInsets.all(20.0),
        child: university.isEmpty
            ? Center(
          child: Text(
            'No university data available',
            style: TextStyle(fontSize: 24.0),
          ),
        )
            : ListView.builder(
          itemCount: university.length,
          itemBuilder: (BuildContext context, int index) {
            final item = university[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['dname'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                    width: 4.0,
                  ),
                  Text(
                    item['pname'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                    width: 4.0,
                  ),
                  Text(
                    item['sdate'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                    width: 4.0,
                  ),
                  Text(
                    item['Semester'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                  VerticalDivider(
                    color: Colors.grey,
                    width: 4.0,
                  ),
                  Text(
                    item['amount'],
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}