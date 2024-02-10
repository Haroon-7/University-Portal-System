import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../Global/Global.dart';
import '../widgets/responsive_button.dart';
import 'package:ups/login_signup/Model/login_model.dart';

class AddFaculties extends StatefulWidget {
  final LoginUser loginuserid;
  final int uid;

  const AddFaculties({Key? key, required this.loginuserid, required this.uid}) : super(key: key);

  @override
  _AddFacultiesState createState() => _AddFacultiesState();

}

class _AddFacultiesState extends State<AddFaculties> {
  final List<String> facultyRankOrder = ['Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer'];

  String type = '';
  TextEditingController facultyMemberController = TextEditingController();
  TextEditingController facultyLinkController = TextEditingController();

  Future<List<Map<String, dynamic>>> fetchFacultyDetails() async {
    try {
      final response = await http.get(Uri.parse('$ip/Admin/showFaculty?uid=${widget.loginuserid.uid}'));

      if (response.statusCode == 200) {
        return (json.decode(response.body) as List).cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to load faculty details. Status Code: ${response.statusCode}, Response Body: ${response.body}');
      }
    } catch (error) {
      throw Exception('Error during API call: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Clear text controllers when the page is re-entered
    facultyMemberController.clear();
    facultyLinkController.clear();
  }

  @override
  void dispose() {
    facultyMemberController.dispose();
    facultyLinkController.dispose();
    super.dispose();
  }

  void _addAnother() async {
    try {
      String facultyMember = facultyMemberController.text;

      if (facultyMember.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Empty'),
              content: Text('Please Enter faculty Member'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      Map<String, dynamic> requestData = {
        'uid': widget.loginuserid.uid.toString(),
        'Rank': type,
        'total': facultyMember,
      };

      final response = await http.post(
        Uri.parse('$ip/University/AddOrUpdateFaculty?uid=${widget.loginuserid.uid}'),
        body: requestData,
      );

      if (response.statusCode == 200) {
        facultyMemberController.clear();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add Successfully'),
              content: Text('Faculty Member added successfully.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Add Failed'),
              content: Text('Add Failed. Please provide valid Credentials.'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _savefacultylink() async {
    try {
      String facultylink = facultyLinkController.text;

      if (facultylink.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Empty'),
              content: Text('Please enter a faculty link'),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
        return;
      }

      Map<String, dynamic> requestData = {
        'uid': widget.loginuserid.uid.toString(),
        'Flink': facultyLinkController.text,
      };

      final response = await http.post(
        Uri.parse('$ip/University/addUniversity?uid=${widget.loginuserid.uid}'),
        body: requestData,
      );
      print('Server Response: ${response.body}');
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculties'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Faculties:'),
              Row(
                children: [
                  Radio(
                    value: 'Professor',
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value.toString();
                      });
                    },
                  ),
                  Text('Professor'),
                  Radio(
                    value: 'Associate Professor',
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value.toString();
                      });
                    },
                  ),
                  Text('Associate Professor'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 'Assistant Professor',
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value.toString();
                      });
                    },
                  ),
                  Text('Assistant Professor'),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: 'Lecturer',
                    groupValue: type,
                    onChanged: (value) {
                      setState(() {
                        type = value.toString();
                      });
                    },
                  ),
                  Text('Lecturer'),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: facultyMemberController,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}$'),
                        ),
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Enter Faculty Member',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  SizedBox(width: 120),
                  ResponsiveButton(
                    onPressed: _addAnother,
                    requiredText: 'Add Another',
                    height: 40,
                    width: 100,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Display faculty details using FutureBuilder
              FutureBuilder(
                future: fetchFacultyDetails(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final List<Map<String, dynamic>>? dataList = snapshot.data as List<Map<String, dynamic>>?;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display "Rank" and "Total" only once
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Rank',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Total',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          ],
                        ),
                        // Display faculty details in the order of the facultyRankOrder list
                        for (String rank in facultyRankOrder)
                          if (dataList?.any((item) => item['Rank'] == rank) ?? false)
                            ...dataList!
                                .where((item) => item['Rank'] == rank)
                                .map(
                                  (item) => ListTile(
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item['Rank']}',
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${item['total']}',
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                ),
                                // Add other details you want to display
                              ),
                            )
                                .toList(),
                      ],
                    );
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: facultyLinkController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Faculty Link',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ResponsiveButton(
                  onPressed: _savefacultylink,
                  requiredText: 'Save',
                  height: 40,
                  width: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
