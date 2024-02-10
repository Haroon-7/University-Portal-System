import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ups/login_signup/Model/degree_model.dart';
import 'package:ups/uni_admin/dashboard.dart';
import 'dart:convert';
import '../Global/Global.dart';
import '../login_signup/Model/login_model.dart';

class AddDegree extends StatefulWidget {
  final LoginUser loginuserid;

  AddDegree({
    Key? key,
    required this.loginuserid,
    int? uid,
  }) : super(key: key);

  @override
  _AddDegreeState createState() => _AddDegreeState();
}

class _AddDegreeState extends State<AddDegree> {
  String selectedDegree = '';
  List<String> selectedPrograms = [];
  bool isProgramDdModelVisible = false;

  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool nts = false;
  bool gat = false;
  bool other = false;
  List<String> selectedProgram = [];
  List<dynamic> program = [];
  List<dynamic> searchProgram = [];

  List<dynamic> programList = [
    // Add more programs as needed
  ];

  String Type = 'Annual';

  Future<void> getUniversityName(int uid) async {
    final url = Uri.parse('${ip}/Login/uniname?uid=$uid');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final universityName = data['u_name'];
        // Use universityName as needed
        print('University Name: $universityName');
      } else {
        print(
            'Failed to get university name. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during HTTP request: $error');
    }
  }

  Future<void> _showProgramDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Programs'),
          content: Container(
              width: double.maxFinite,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return ListView.builder(
                    itemCount: programList.length,
                    itemBuilder: (context, index) {
                      final program = programList[index]["program"];
                      return ListTile(
                        title: Text(program),
                        leading: Checkbox(
                          value: selectedPrograms.contains(program),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                selectedPrograms.add(program);
                              } else {
                                selectedPrograms.remove(program);
                              }
                              print(selectedPrograms);
                            });
                          },
                        ),
                      );
                    },
                  );
                },
              )),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  isProgramDdModelVisible = false;
                });
                Navigator.of(context).pop();
              },
              child: Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void handleProgramSelection(String program) {
    setState(() {
      if (selectedPrograms.contains(program)) {
        selectedPrograms.remove(program);
      } else {
        selectedPrograms.add(program);
      }
    });
  }

  void onSearch(String txt) {
    if (txt.isNotEmpty) {
      List<dynamic> tempData = program.where((item) {
        return item['program'].toLowerCase().contains(txt.toLowerCase());
      }).toList();
      setState(() {
        searchProgram = tempData;
      });
    } else {
      setState(() {
        searchProgram = List.from(program);
      });
    }
  }

  Future<void> handleRadioButtonPress(String value) async {
    try {
      String url = '${ip}/University/getDegreePrograms?degree=$value';
      print(url);
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        programList = data;
        print(programList);
        print('Fetched items: $data');
        setState(() {
          program = data;
          searchProgram = List.from(program);
          selectedDegree = value;
        });
      } else {
        print('Fetch failed');
      }
      setState(() {
        selectedProgram = [];
      });
    } catch (error) {
      print('Fetch error: $error');
    }
  }

  Future<void> saveData() async {
    List<int> selectedProgramsIds = [];
    selectedPrograms.forEach((prog) {
      var foundObject = program.firstWhere((item) => item['program'] == prog,
          orElse: () => null);
      int programId;
      if (foundObject != null) {
        programId = foundObject['id'];
        selectedProgramsIds.add(programId);
        print("Program ids are $selectedProgramsIds");
      }
    });

    List<int> selectedOfferIds = [];

    try {
      for (var programId in selectedProgramsIds) {
        print('Universty id $uid');
        var status = "true";
        var response = await http.post(
          Uri.parse(
              '${ip}/University/AddoruodateUniprogram?uid=$uid&proid=${programId}'),
          body: {'Status': status},
        );
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print('Program insertion success: $data');
          selectedOfferIds.add(data);
          print(selectedOfferIds);
        } else {
          print('Program insertion failed for program ID: $programId');
        }
      }
      print('All programs inserted successfully: $selectedOfferIds');
      setState(() {
        selectedProgram = [];
      });
    } catch (error) {
      print('An error occurred while inserting degree: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An error occurred while inserting degree.'),
          );
        },
      );
    }

    handleFee(selectedOfferIds);
    handleEligibility(selectedOfferIds);

    if (selectedDegree.isEmpty ||
        selectedPrograms.isEmpty ||
        amountController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        (!nts && !gat && !other)) {
      // Show a dialog indicating that all fields are required
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Incomplete Data'),
            content: Text('Please fill in all required fields.'),
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
      return; // Exit the function without proceeding
    }

    bool addAnother = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Degree Added Successfully'),
          content: Text('Do you want to add another degree?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User wants to add another
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // User doesn't want to add another
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );

    // Check the user's choice
    if (addAnother == true) {
      // Clear the fields and remain on the same page
      setState(() {
        selectedDegree = '';
        selectedPrograms = [];
        nts = false;
        gat = false;
        other = false;
        amountController.clear();
        descriptionController.clear();
      });
    } else {
      // Navigate to the dashboard or any other page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Dashboard(loginuserid: loggedInUni!),
        ),
      ); // Replace with your actual route
    }
  }

  // void saveData() async {
  //   try {
  //
  //     Map<String, dynamic> postData = {
  //       'Program': selectedDegree,
  //       'PList': selectedPrograms,
  //       'Test': [
  //         if (nts) 'NTS',
  //         if (gat) 'GAT',
  //         if (other) 'Other',
  //       ],
  //       'SDate': startDateController.text,
  //       'EDate': endDateController.text,
  //       'Description': descriptionController.text,
  //       'Fee': int.tryParse(amountController.text),
  //     };
  //
  //     final response = await http.post(
  //       Uri.parse('${ip}/University/AddoruodateUniprogram?uid=${uid}&proid=${program}'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode(postData),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       // Data saved successfully
  //       print('Data saved successfully');
  //       // Handle any additional actions after successful data save
  //     } else {
  //       // Handle errors
  //       print('Failed to save data. Status code: ${response.statusCode}');
  //       // Handle any error scenarios
  //     }
  //   } catch (e) {
  //     // Handle exceptions
  //     print('Exception during data save: $e');
  //   }
  // }

  Future<void> handleFee(List<int> selectedOfferIds) async {
    try {
      for (var offerIds in selectedOfferIds) {
        var response = await http.post(
          Uri.parse('${ip}/University/AddoruodateUniprogram?oid=$offerIds'),
          body: {'Fee': amountController.text, 'Type': Type},
          headers: {'Accept': 'application/json'},
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print('Fee Structure inserted successfully: $data');
        } else {
          print('Fee insertion failed for offer ID: $offerIds');
        }

        setState(() {
          selectedProgram = [];
        });
      }
    } catch (error) {
      print('An error occurred while inserting degree: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An error occurred while inserting degree.'),
          );
        },
      );
    }
  }

  Future<void> handleEligibility(List<int> selectedOfferIds) async {
    try {
      for (var offerIds in selectedOfferIds) {
        var response = await http.post(
          Uri.parse('${ip}/University/AddorupdateElligiblty?oid='
              '${offerIds}'),
          body: {
            'NTS': nts.toString(),
            'GAT': gat.toString(),
            'Other': other.toString(),
            'Description': descriptionController.text,
          },
          headers: {'Accept': 'application/json'},
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          print('Eligibility Criteria inserted successfully: $data');
        } else {
          print(
              'Eligibility Criteria insertion failed for offer ID: $offerIds');
        }

        setState(() {
          selectedProgram = [];
        });
      }
    } catch (error) {
      print('An error occurred while inserting Eligibility Criteria: $error');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:
                Text('An error occurred while inserting Eligibility Criteria.'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Degree'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Text('Degree', style: TextStyle(fontSize: 20)),
            Row(
              children: [
                Radio(
                  value: 'BS',
                  groupValue: selectedDegree,
                  onChanged: (value) => handleRadioButtonPress(value as String),
                ),
                Text('BS'),
                Radio(
                  value: 'MS/Mphil',
                  groupValue: selectedDegree,
                  onChanged: (value) => handleRadioButtonPress(value as String),
                ),
                Text('MS/Mphil'),
                Radio(
                  value: 'PHD',
                  groupValue: selectedDegree,
                  onChanged: (value) => handleRadioButtonPress(value as String),
                ),
                Text('PHD'),
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 'Associate',
                  groupValue: selectedDegree,
                  onChanged: (value) => handleRadioButtonPress(value as String),
                ),
                Text('Associate'),
              ],
            ),
            ElevatedButton(
              onPressed: () async {
                await handleRadioButtonPress(selectedDegree);
                setState(() {
                  isProgramDdModelVisible = true;
                });
                _showProgramDialog();
              },
              child: Text(selectedPrograms.isEmpty
                  ? 'Select Program'
                  : selectedPrograms.join(', ')),
            ),
            if (selectedPrograms.isNotEmpty)
              Text('Selected Programs: ${selectedPrograms.join(', ')}',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
            SizedBox(
              height: 20,
            ),
            Text('Fees', style: TextStyle(fontSize: 20)),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Fee Type', style: TextStyle(fontSize: 15)),
            DropdownButton<String>(
              value: Type,
              onChanged: (String? currentRole) {
                setState(() {
                  Type = currentRole!;
                });
              },
              items: <String>['Annual', 'Semester'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(
              height: 20,
            ),
            Text('Test type', style: TextStyle(fontSize: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    Text('NTS'),
                    Checkbox(
                      value: nts,
                      onChanged: (value) {
                        setState(() {
                          nts = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('GAT'),
                    Checkbox(
                      value: gat,
                      onChanged: (value) {
                        setState(() {
                          gat = value!;
                        });
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('Other'),
                    Checkbox(
                      value: other,
                      onChanged: (value) {
                        setState(() {
                          other = value!;
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            Text('Test Description:', style: TextStyle(fontSize: 20)),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: saveData,
              /*onPressed:() async {
                Degree deg=Degree();
                deg.Program=selectedDegree;
                deg.plist=selectedPrograms;
                deg.description=descriptionController.text;
                deg.fee = int.tryParse(amountController.text);
                deg.sdate=startDateController.text;
                deg.edate=endDateController.text;
                deg.Test=[if(nts)'nts',if(gat)'gat',if(other)'other'];
                String json=jsonEncode(deg.toMap());
                print(json);*/
              // Send the JSON data to the backend

              child: Text('Add Degree'),
            )
          ],
        ),
      ),
    );
  }
}
