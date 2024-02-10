import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ups/uni_admin/dashboard.dart';
import '../Global/Global.dart';
import '../login_signup/Model/login_model.dart';
import 'package:http/http.dart' as http;

class ScholarshipScreen extends StatefulWidget {
  final LoginUser loginuserid;
  final int uid;

  ScholarshipScreen({Key? key, required this.loginuserid, required this.uid})
      : super(key: key);

  @override
  _ScholarshipScreenState createState() => _ScholarshipScreenState();
}

class _ScholarshipScreenState extends State<ScholarshipScreen> {
  String type = '';
  TextEditingController descriptionController = TextEditingController();
  List<Map<String, dynamic>> scholarships = [];

  @override
  void initState() {
    super.initState();
    // Fetch scholarships when the widget is initialized
    fetchScholarships();
  }

  Future<void> fetchScholarships() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$ip/Admin/showuniversityScholarship?uid=${widget.loginuserid.uid}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          scholarships = List<Map<String, dynamic>>.from(data);
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void handleScholarship() async {
    try {
      if (type.isEmpty || descriptionController.text.isEmpty) {
        // Show error dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Failed"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      } else {
        var formData = {
          'Title': type,
          'Description': descriptionController.text,
        };

        final response = await http.post(
          Uri.parse(
              '${ip}/University/Addorupdatescholarship?uid=${widget.loginuserid.uid}'),
          body: formData,
          headers: {
            'Accept': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          print('Scholarship Added');

          // Fetch scholarships after adding a new one
          await fetchScholarships();

          // Show success dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Scholarship Added."),
                content: Text("Do you want to add another scholarship?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        type = '';
                        descriptionController.text = '';
                      });
                    },
                    child: Text("Yes"),
                  ),
                  TextButton(
                    child: const Text('No'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Dashboard(
                            uid: widget.loginuserid.uid,
                            loginuserid: loggedInUni!,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        } else {
          print('Error: ${response.statusCode}');
        }
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scholarship'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type:',
              style: TextStyle(fontSize: 18.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Radio(
                  value: 'Sport',
                  groupValue: type,
                  onChanged: (value) {
                    setState(() {
                      type = value.toString();
                    });
                  },
                ),
                Text('Sport'),
                Radio(
                  value: 'Need',
                  groupValue: type,
                  onChanged: (value) {
                    setState(() {
                      type = value.toString();
                    });
                  },
                ),
                Text('Need'),
                Radio(
                  value: 'Other',
                  groupValue: type,
                  onChanged: (value) {
                    setState(() {
                      type = value.toString();
                    });
                  },
                ),
                Text('Other'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      hintText: 'Enter description',
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: handleScholarship,
              child: Center(
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            // Display scholarships in a list
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: scholarships.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Title: ${scholarships[index]['title']}'),
                    subtitle: Text(
                        'Description: ${scholarships[index]['description']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
