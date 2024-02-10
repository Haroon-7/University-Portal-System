import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ups/User%20Side/admission.dart';

import '../Global/Global.dart';
import '../login_signup/Model/login_model.dart';
import '../widgets/cust_dropdown.dart';

class AddAdmission extends StatefulWidget {
  final int uid;

  const AddAdmission(
      {Key? key,
      required this.uid,
      required LoginUser lognuserid,
      required String u_name})
      : super(key: key);

  @override
  _AddDegreeState createState() => _AddDegreeState();
}

class _AddDegreeState extends State<AddAdmission> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController AdmissionlinkController = TextEditingController();
  String role = 'Fall';

  late List<Map<String, dynamic>> program;
  late List<Map<String, dynamic>> searchProgram;
  late List<Map<String, dynamic>> selectedProgram;
  late String startDate;
  late String endDate;
  late bool startDatePickerOpen;
  late bool endDatePickerOpen;
  late List<Map<String, dynamic>> semesters;
  late String selectedSemester;

  @override
  void initState() {
    super.initState();
    program = [];
    searchProgram = [];
    selectedProgram = [];
    startDate = '';
    endDate = '';
    startDatePickerOpen = false;
    endDatePickerOpen = false;
    semesters = [
      {'name': 'Fall'},
      {'name': 'Spring'},
    ];
    selectedSemester = '';

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
            '$ip/User/ViewUniprogram?uid=${widget.uid}'), // Replace with your API URL
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        // Parse data accordingly
        // Modify data and update state
        setState(() {
          program = responseData
              .map<Map<String, dynamic>>((item) => {
                    ...item,
                    'combinedName': '${item['dname']} ${item['pname']}',
                  })
              .toList();
        });
      } else {
        print('Fetch failed');
      }
    } catch (error) {
      print('Fetch error: $error');
    }
  }

  void onSearch(String txt) {
    if (txt.isNotEmpty) {
      setState(() {
        searchProgram = program
            .where((item) =>
                item['program'].toLowerCase().contains(txt.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        searchProgram = program;
      });
    }
  }

  void handleProgramSelection(Map<String, dynamic> item) {
    setState(() {
      if (selectedProgram.contains(item)) {
        selectedProgram.remove(item);
      } else {
        selectedProgram.add(item);
      }
    });
  }

  Future<void> saveData() async {
    print(program);
    updateUniversityUrl(widget.uid);
    handleAdmission(int.parse(selectedValue!));
  }

  /*Future<void> handleFee(List<Map<String, dynamic>> selectedProgram) async {
    try {
      for (final offerId in selectedProgram) {
        final formData = {'Fee': 'amount'}; // Replace 'amount' with your amount variable
        final response = await http.post(
          Uri.parse('your_api_url_here'), // Replace with your API URL
          body: formData,
          headers: {'Accept': 'application/json'},
        );

        if (response.statusCode == 200) {
          final data = response.body;
          print('Fee Structure inserted successfully: $data');
        } else {
          print('Fee insertion failed for offer ID: $offerId');
        }
      }
    } catch (error) {
      print('An error occurred while inserting degree: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while inserting degree.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }*/

  String formatDate(String date) {
    final formattedDate = DateTime.parse(date);
    final year = formattedDate.year;
    final month = formattedDate.month;
    final day = formattedDate.day;
    return '$year,$month,$day';
  }

  Future<void> updateUniversityUrl(int uid) async {
    try {
      print('Updating University URL...');

      if (AdmissionlinkController.text.isNotEmpty) {
        // Create a FormData object
        var formData = http.MultipartRequest('POST',
            Uri.parse('$ip/University/addUniversity?uid=${widget.uid}'));
        // Add your fields to FormData
        formData.fields.addAll({'EURL': AdmissionlinkController.text});
        // Send the request
        var response = await formData.send();
        // Check the response
        if (response.statusCode == 200) {
          // Parse the response
          var responseData = await response.stream.bytesToString();
          var data = json.decode(responseData);
          print('URL updated successfully: $data');
        } else {
          print('Failed to update URL: ${response.statusCode}');
        }
      } else {
        print('Admission link is empty');
      }
    } catch (error) {
      print('Error updating University URL: $error');
    }
  }

  Future<void> handleAdmission(int? selectedProgram) async {
    try {
      print('Handling Admission...');
      final formData = {
        'sdate': startDateController.text,
        'edate': endDateController.text,
        'semester': role,
      };

      final response = await http.post(
        Uri.parse(
            '$ip/University/AddorupdateAdmission?oid=$selectedProgram'), // Updated this line
        body: formData,
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = response.body;
        print('Admission Date inserted successfully: $data');
      } else {
        print('Admission Date insertion failed for offer ID: $selectedProgram');
        print('Response status: ${response.statusCode}');
        final errorResponse = response.body;
        print('Error response: $errorResponse');
      }
    } catch (error) {
      print('Error handling Admission: $error');
    }
  }

  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admisssion"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Program',
                style: TextStyle(fontSize: 20),
              ),
              DropdownButtonFormField<String>(
                value: selectedValue,
                items: program.map<DropdownMenuItem<String>>((item) {
                  return DropdownMenuItem<String>(
                    value: item['oid'].toString(),
                    child: Text(item['combinedName'].toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Program',
                  /* border: OutlineInputBorder(),*/
                ),
              ),

              // CustomDropdown(  // Add your CustomDropdown widget here
              //   options: program,
              //   // ... (customize according to your CustomDropdown implementation)
              // ),

              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text(
                    "Semester:",
                    style: TextStyle(),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  DropdownButton<String>(
                    value: role,
                    onChanged: (String? currentRole) {
                      setState(() {
                        role = currentRole!;
                      });
                    },
                    items: <String>['Fall', 'Spring'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              TextField(
                controller: startDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Start Date',
                  /* border: OutlineInputBorder(),*/
                ),
                onTap: () async {
                  final DateTime? pickedStartDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedStartDate != null &&
                      pickedStartDate != DateTime.now()) {
                    setState(() {
                      startDateController.text =
                          pickedStartDate.toLocal().toString().split(' ')[0];
                    });
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: endDateController,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'End Date',
                  /*border: OutlineInputBorder(),*/
                ),
                onTap: () async {
                  final DateTime? pickedEndDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedEndDate != null &&
                      pickedEndDate != DateTime.now()) {
                    setState(() {
                      endDateController.text =
                          pickedEndDate.toLocal().toString().split(' ')[0];
                    });
                  }
                },
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: AdmissionlinkController,
                      decoration: const InputDecoration(
                        hintText: 'Admission Link',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),

              ElevatedButton(
                onPressed: saveData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
