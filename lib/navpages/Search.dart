import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ups/hec_admin/enrolled_uni.dart';
import 'package:ups/login_signup/Model/user_login_model.dart';
import 'package:ups/navpages/user_notifications.dart';
import 'package:ups/widgets/multi_select.dart';
import 'package:ups/User%20Side/universities_list.dart';
import '../Global/Global.dart';
import 'package:http/http.dart' as http;
import '../login_signup/login.dart';
import '../widgets/responsive_button.dart';

import 'package:flutter_custom_selector/flutter_custom_selector.dart' as sector;

class SearchPage extends StatefulWidget {
  final int _selectedIndex = 0;

  const SearchPage({
    Key? key,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String selectedDegree = '';
  List<String> selectedPrograms = [];
  bool isProgramDdModelVisible = false;
  List<String> selectedProgram = [];
  List<dynamic> program = [];
  List<dynamic> searchProgram = [];
  List<String>? programList;

  bool selectAssociativeDegree = false;
  List<String> degrees = [];
  List<String> scholarships = [];
  String Scholarship = 'Select Scholarship';
  String selectedItem = 'Select City';
  TextEditingController amountController = TextEditingController();

  List<String>? officers;
  Map<String, int>? officerIds;
  int? selectedprogramId;

  Future<void> _showProgramDialog(String? Degree) async {
    // return showDialog<void>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Select Programs'),
    //       content: Container(
    //         width: double.maxFinite,
    //         child: StatefulBuilder(builder: (context, setState) {
    //           return ListView.builder(
    //             itemCount: programList.length,
    //             itemBuilder: (context, index) {
    //               final program = programList[index]["program"];
    //               return ListTile(
    //                 title: Text(program),
    //                 leading: Checkbox(
    //                   value: selectedPrograms.contains("id"),
    //                   onChanged: (value) {
    //                     setState(() {
    //                       if (value!) {
    //                         selectedPrograms.add("id");
    //                       } else {
    //                         selectedPrograms.remove("id");
    //                       }
    //                       print("SElected$selectedPrograms");
    //                     });
    //                   },
    //                 ),
    //               );
    //             },
    //           );
    //         }),
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Text('Cancel'),
    //         ),
    //         TextButton(
    //           onPressed: () {
    //             setState(() {
    //               isProgramDdModelVisible = false;
    //             });
    //             Navigator.of(context).pop();
    //           },
    //           child: Text('Done'),
    //         ),
    //       ],
    //     );
    //   },
    // );
  }

  Future<List<Map<String, dynamic>>> searchUniversities(
      String city, int programId, String scholarship, int amount) async {
    try {
      final Uri apiUrl = Uri.parse('${ip}/Login/SearchUni');
      final Map<String, dynamic> queryParams = {
        'city': city,
        'programid': programId.toString(),
        'scholarship': scholarship,
        'amount': amount.toString(),
      };

      final response =
          await http.get(apiUrl.replace(queryParameters: queryParams));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data);

        // Assuming your data is a list, convert each item to Map<String, dynamic>
        List<Map<String, dynamic>> searchData =
            List<Map<String, dynamic>>.from(data);

        return searchData;
      } else {
        print('Request failed with status: ${response.statusCode}');
        return []; // Return an empty list in case of failure
      }
    } catch (error) {
      print('Error during API request: $error');
      return []; // Return an empty list in case of an error
    }
  }

  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    if (_currentIndex == 0) {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => SearchPage(
      //               Usid: Usid,
      //               userid: loggedInUser!,
      //             )));
    } else if (_currentIndex == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const UserNotifications()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
          actions: [
            TextButton(
              onPressed: () {
                // Navigate to the login page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 22.0, left: 12.0),
                  child: Image.asset(
                    'assets/UPS.png',
                    width: 80,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButton<String>(
                      value: selectedItem,
                      onChanged: (String? currentCity) {
                        setState(() {
                          selectedItem = currentCity!;
                        });
                      },
                      items: <String>[
                        'Select City',
                        'Faisalabad',
                        'Islamabad',
                        'Abbottabad',
                        'Lahore',
                        'Multan',
                        'Peshawar',
                        'Rawalpindi',
                        'Bhakkar',
                        'Bahawalpur'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(' Select degree ', style: TextStyle(fontSize: 15)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Radio(
                      value: 'BS',
                      groupValue: selectedDegree,
                      onChanged: (value) =>
                          handleRadioButtonPress(value as String),
                    ),
                    const Text('BS'),
                    Radio(
                      value: 'MS/Mphil',
                      groupValue: selectedDegree,
                      onChanged: (value) =>
                          handleRadioButtonPress(value as String),
                    ),
                    const Text('MS/Mphil'),
                    Radio(
                      value: 'PHD',
                      groupValue: selectedDegree,
                      onChanged: (value) =>
                          handleRadioButtonPress(value as String),
                    ),
                    const Text('PHD'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Radio(
                      value: 'Associate',
                      groupValue: selectedDegree,
                      onChanged: (value) =>
                          handleRadioButtonPress(value as String),
                    ),
                    const Text('Associate'),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                selectedDegree == ""
                    ? const SizedBox.shrink()
                    : FutureBuilder<Map<String, int>>(
                        future: fetchOfficersWithIds(selectedDegree),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            officerIds = snapshot.data;
                            officers = officerIds!.keys.toList();
                            return sector.CustomSingleSelectField<String>(
                              title: 'Officers',
                              items: officers!,
                              onSelectionDone: (value) {
                                final selectedOfficerId =
                                    officerIds![value as String];
                                setState(() {
                                  selectedprogramId = selectedOfficerId;
                                  print(selectedOfficerId);
                                });
                              },
                              itemAsString: (item) => item.toString(),
                            );
                          } else if (snapshot.hasError) {
                            return const Text('Error fetching officers data');
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),

                // ElevatedButton(
                //   onPressed: () async {
                //     await handleRadioButtonPress(selectedDegree);
                //     setState(() {
                //       isProgramDdModelVisible = true;
                //     });
                //     _showProgramDialog(selectedDegree);
                //   },
                //   child: Text(selectedPrograms.isEmpty
                //       ? 'Select Program'
                //       : selectedPrograms.join(', ')),
                // ),
                if (selectedPrograms.isNotEmpty)
                  Text('Selected Programs: ${selectedPrograms.join(', ')}',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Scholarship',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 60), // Adjust the spacing as needed
                    DropdownButton<String>(
                      value: Scholarship,
                      onChanged: (String? currentScholarship) {
                        setState(() {
                          Scholarship = currentScholarship!;
                        });
                      },
                      items: <String>[
                        'Select Scholarship',
                        'Merit',
                        'Need',
                        'Sport',
                        'Other'
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}$'),
                          ),
                        ],
                        decoration: const InputDecoration(
                          hintText: 'Enter Fee Structure',
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () async {
                    if (selectedItem.isNotEmpty) {
                      List<Map<String, dynamic>> searchData =
                          await searchUniversities(
                              selectedItem,
                              selectedprogramId!,
                              Scholarship,
                              int.parse(amountController.text));
                      print(searchData);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => User(
                              searchData: searchData,
                              progid: selectedprogramId),
                        ),
                      );
                    } else {
                      // Handle the case where cities or programList is empty
                    }
                  },
                  child: const ResponsiveButton(
                    requiredText: 'Search',
                    isResponsive: false,
                    width: 100,
                    height: 50,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          selectedItemColor: const Color(0xFF5d69b3),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notification_add),
              label: 'Notifications',
            ),
          ],
        ),
      ),
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
    setState(() {
      // program = data;
      // searchProgram = List.from(program);
      selectedDegree = value;
    });
  }

  Future<Map<String, int>> fetchOfficersWithIds(String value) async {
    final response = await http
        .get(Uri.parse('${ip}/University/getDegreePrograms?degree=$value'));

    if (response.statusCode == 200) {
      final officersJson = jsonDecode(response.body) as List<dynamic>;
      final officers = officersJson.fold<Map<String, int>>({}, (map, officer) {
        final name = officer['program'];
        final userId = officer['id'];
        if (name != null && userId != null) {
          return map..[name] = userId;
        } else {
          return map;
        }
      });

      return officers;
    } else {
      throw Exception('Failed to fetch officers');
    }
  }
//  Future<Map<String, int>> handleRadioButtonPress2(String value) async {
//   try {
//     String url = '${ip}University/getDegreePrograms?degree=$value';
//     var response = await http.get(
//       Uri.parse(url),
//       headers: {
//         'Accept': 'application/json',
//         'Content-Type': 'application/json',
//       },
//     );

//     if (response.statusCode == 200) {
//       // var data = json.decode(response.body) as List<dynamic>;

//       // final List<Map<String, dynamic>> programList = data
//       //     .map((e) => {
//       //           'id': e['id'] != null ? e['id'] : 0,
//       //           'program': e['program'] != null ? e['program'].toString() : '',
//       //         })
//       //     .toList();
//       final officersJson = jsonDecode(response.body) as List<dynamic>;
//       final officers = officersJson.fold<Map<String, int>>({}, (map, officer) {
//         final name = officer['name'];
//         final userId = officer['id'];
//         if (name != null && userId != null) {
//           return map..[name] = userId;
//         } else {
//           return map;
//         }
//       });

//       return programList;
//     } else {
//       print('Fetch failed');
//     }
//   } catch (error) {
//     print('Fetch error: $error');
//   }

//   // Return an empty list if there's an error
//   return [];
// }
}
