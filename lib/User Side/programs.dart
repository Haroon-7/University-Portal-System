import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Global/Global.dart';
import 'package:flutter_custom_selector/flutter_custom_selector.dart' as sector;

class Programs extends StatefulWidget {
  final String universityName;
  final int uid;
  final int proid;
  final int? progid;

  const Programs(
      {Key? key,
      required this.universityName,
      required this.uid,
      required this.proid,
      this.progid})
      : super(key: key);

  @override
  State<Programs> createState() => _ProgramsState();
}

class _ProgramsState extends State<Programs> {
  String selectedDegree = '';
  List<String> selectedPrograms = [];
  bool isProgramDdModelVisible = false;
  List<String> selectedProgram = [];
  List<dynamic> program = [];
  List<dynamic> searchProgram = [];
  List<dynamic> programList = [];

  List<String>? officers;
  Map<String, int>? officerIds;
  int? selectedprogramId;

  Future<void> handleRadioButtonPress(String value) async {
    setState(() {
      // program = data;
      // searchProgram = List.from(program);
      selectedDegree = value;
    });
  }

  Future<Map<String, int>> fetchOfficersWithIds(String value) async {
    try {
      final response = await http.get(
        Uri.parse('${ip}/University/getDegreePrograms?degree=$value'),
      );

      if (response.statusCode == 200) {
        final officersJson = jsonDecode(response.body) as List<dynamic>;
        final officers =
            officersJson.fold<Map<String, int>>({}, (map, officer) {
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
    } catch (error) {
      print('Error fetching officers: $error');
      rethrow;
    }
  }

  Future<String?> fetchUniversityDetails() async {
    try {
      final response = await http.get(Uri.parse(
          '$ip/User/viewuserprogram?uid=${widget.uid}&proid=${widget.progid}'));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        if (data.isNotEmpty) {
          return data[0]['dname'];
        } else {
          print('API response is empty');
          return null;
        }
      } else {
        print('Error response status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }

  List<dynamic> programCourses = [];

  String formatDate(String dateString) {
    if (dateString.isEmpty) {
      return ''; // Return an empty string for null or empty date strings
    }

    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('yy-MM-dd').format(dateTime);

    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.universityName),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Select degree', style: TextStyle(fontSize: 15)),
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),
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
              const SizedBox(height: 10),

              selectedDegree == ""
                  ? const SizedBox.shrink()
                  : FutureBuilder<Map<String, int>>(
                      future: fetchOfficersWithIds(selectedDegree),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          officerIds = snapshot.data;
                          officers = officerIds!.keys.toList();
                          return sector.CustomSingleSelectField<String>(
                            title: 'Programs',
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
                    style: const TextStyle(fontSize: 16, color: Colors.black)),

              // DropdownButtonFormField<String>(
              //   value: selectedProgram.isNotEmpty ? selectedProgram[0] : null,
              //   onChanged: (String? newValue) {
              //     setState(() {
              //       selectedProgram = [newValue!];
              //     });
              //   },
              //   items: programList
              //       .map<DropdownMenuItem<String>>(
              //         (dynamic item) => DropdownMenuItem<String>(
              //           value: item['program'].toString(),
              //           child: Text(item['program'].toString()),
              //         ),
              //       )
              //       .toList(),
              //   decoration: const InputDecoration(
              //     labelText: 'Select Program',
              //     border: OutlineInputBorder(),
              //   ),
              // ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (selectedprogramId != null) {
                          try {
                            // First API call to fetch programs
                            var programsRequest = http.Request(
                              'GET',
                              Uri.parse(
                                '${ip}/User/viewuserprogram?uid=${widget.uid}&proid=$selectedprogramId',
                              ),
                            );

                            http.StreamedResponse programsResponse =
                                await programsRequest.send();

                            if (programsResponse.statusCode == 200) {
                              String programsResponseBody =
                                  await programsResponse.stream.bytesToString();
                              // Process the response body as needed
                              print(programsResponseBody);

                              // If your response body is JSON, you can parse it
                              // Example assuming the response body is a List
                              List<dynamic> programs =
                                  json.decode(programsResponseBody);
                              setState(() {
                                programList = programs;
                              });
                            } else {
                              print(
                                'Failed to fetch programs. Reason: ${programsResponse.reasonPhrase}',
                              );
                            }

                            // Second API call to fetch program courses

                            var coursesRequest = http.Request(
                              'GET',
                              Uri.parse(
                                '${ip}/User/ProgramCourses?proid=$selectedprogramId',
                              ),
                            );

                            http.StreamedResponse coursesResponse =
                                await coursesRequest.send();

                            if (coursesResponse.statusCode == 200) {
                              String coursesResponseBody =
                                  await coursesResponse.stream.bytesToString();
                              // Process the response body as needed
                              print(coursesResponseBody);

                              // If your response body is JSON, you can parse it
                              // Example assuming the response body is a List
                              List<dynamic> courses =
                                  json.decode(coursesResponseBody);
                              setState(() {
                                programCourses = courses;
                              });
                            } else {
                              print(
                                'Failed to fetch program courses. Reason: ${coursesResponse.reasonPhrase}',
                              );
                            }
                          } catch (error) {
                            print('Error Occurred: $error');
                          }
                        }
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24.0),
                        ),
                      ),
                      child: const Text('Show Programs and Courses'),
                    ),
                    const SizedBox(height: 20),
                    if (programList.isEmpty && programCourses.isEmpty)
                      const Text('No data available'),
                    if (programList.isNotEmpty)
                      Column(
                        children: programList
                            .expand(
                              (program) => [
                                ListTile(
                                  title: Text(
                                      '${program['dname']} ${program['pname']}'),
                                  subtitle:
                                      Text('Semester: ${program['Semester']}'),
                                  // Add more details as needed
                                  onTap: () {
                                    // Handle tap event for the first ListTile
                                  },
                                ),
                                ListTile(
                                  title: const Text('Eligibility Criteria'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(' ${program['description']}'),

                                      // Add more details as needed
                                    ],
                                  ),
                                  // Add more details as needed
                                  onTap: () {
                                    // Handle tap event for the second ListTile
                                  },
                                ),
                                ListTile(
                                  title: const Text('Test'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (program['NTS'] != null &&
                                          program['NTS'] != "false")
                                        Text(
                                          'NTS: ${program['NTS']}',
                                        ),
                                      if (program['GAT'] != null &&
                                          program['GAT'] != "false")
                                        Text(
                                          'GAT: ${program['GAT']}',
                                        ),
                                      if (program['Other'] != null &&
                                          program['Other'] != "false")
                                        Text(
                                          'Other: ${program['Other']}',
                                        ),
                                      // Add more details as needed
                                    ],
                                  ),
                                  onTap: () {
                                    // Handle tap event for the ListTile
                                  },
                                ),
                                ListTile(
                                  title: const Text('Fee Structure'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Type: ${program['Type']}'),
                                      Text('Amount: ${program['amount']}'),

                                      // Add more details as needed
                                    ],
                                  ),
                                  // Add more details as needed
                                  onTap: () {
                                    // Handle tap event for the second ListTile
                                  },
                                ),
                                ListTile(
                                  title: const Text('Admission'),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Start Date: ${formatDate(program['sdate'])}'),
                                      Text(
                                          'End Date: ${formatDate(program['edate'])}'),
                                      // Add more details as needed
                                    ],
                                  ),
                                  onTap: () {
                                    // Handle tap event for the ListTile
                                  },
                                ),
                              ],
                            )
                            .toList(),
                      ),
                    if (programCourses.isNotEmpty)
                      DataTable(
                        columns: const [
                          DataColumn(label: Text('Title')),
                          DataColumn(label: Text('Credit Hours')),
                        ],
                        rows: programCourses
                            .map<DataRow>(
                              (course) => DataRow(
                                cells: [
                                  DataCell(Text(course['title'])),
                                  DataCell(Text(course['crhour'].toString())),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
