import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ups/Global/Global.dart';
import 'package:ups/User%20Side/Rating.dart';
import 'package:ups/User%20Side/admission.dart';
import 'package:ups/User%20Side/faculty.dart';
import 'package:ups/User%20Side/programs.dart';
import 'package:ups/User%20Side/scholarship.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:ups/User%20Side/show_testimonial.dart';
import 'package:ups/uni_admin/add_testimonial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ups/User%20Side/selectedProgram.dart';
import 'package:ups/hec_admin/show_faculty.dart';
import 'package:ups/hec_admin/show_scholarship.dart';

class UniversityDetailPage extends StatefulWidget {
  late final String universityName;
  final int uid;

  final int? progid;
  bool? isSponsor;
  String? url;

  UniversityDetailPage({
    Key? key,
    required this.universityName,
    required this.uid,
    this.progid,
    required this.url,
    required this.isSponsor,
  }) : super(key: key);

  @override
  State<UniversityDetailPage> createState() => _UniversityDetailsPageState();
}

class _UniversityDetailsPageState extends State<UniversityDetailPage> {
  String? degreeName;
  String? programName;

  Future<void> viewUserProgram() async {
    try {
      var request = http.Request(
        'GET',
        Uri.parse(
          '${ip}/User/viewuserprogram?uid=${widget.uid}&proid=${widget.progid}',
        ),
      );

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        List<dynamic> result =
            json.decode(await response.stream.bytesToString());
        if (result.isNotEmpty) {
          setState(() {
            degreeName = result[0]['dname'];
            programName = result[0]['pname'];
          });
        } else {
          print('User program not found');
        }
      } else {
        print(
            'Failed to load user program. Status code: ${response.statusCode}');
        print('Reason phrase: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Error loading user program: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the user program data on initialization
    viewUserProgram();
  }

  // Function to launch the URL
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<dynamic> programCourses = [];
  List<dynamic> programList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('University Details'),
        centerTitle: true,
        actions: const [
          // Add a Text widget displaying the university name
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.isSponsor == true
                ? const SizedBox.shrink()
                : ElevatedButton(
                    onPressed: widget.isSponsor == true
                        ? null
                        : () async {
                            try {
                              // First API call to fetch user program details
                              var programRequest = http.Request(
                                'GET',
                                Uri.parse(
                                  '${ip}/User/viewuserprogram?uid=${widget.uid}&proid=${widget.progid}',
                                ),
                              );

                              http.StreamedResponse programResponse =
                                  await programRequest.send();

                              if (programResponse.statusCode == 200) {
                                String programResponseBody =
                                    await programResponse.stream
                                        .bytesToString();
                                // Process the response body as needed
                                print(programResponseBody);

                                // If your response body is JSON, you can parse it
                                // Example assuming the response body is a List
                                List<dynamic> programs =
                                    json.decode(programResponseBody);
                                setState(() {
                                  programList = programs;
                                });

                                // Second API call to fetch program courses
                                var coursesRequest = http.Request(
                                  'GET',
                                  Uri.parse(
                                    '${ip}/User/ProgramCourses?proid=${widget.progid}',
                                  ),
                                );

                                http.StreamedResponse coursesResponse =
                                    await coursesRequest.send();

                                if (coursesResponse.statusCode == 200) {
                                  String coursesResponseBody =
                                      await coursesResponse.stream
                                          .bytesToString();
                                  // Process the response body as needed
                                  print(coursesResponseBody);

                                  // If your response body is JSON, you can parse it
                                  // Example assuming the response body is a List
                                  List<dynamic> courses =
                                      json.decode(coursesResponseBody);
                                  setState(() {
                                    programCourses = courses;
                                  });

                                  // Navigate to ProgramDetailsPage
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ProgramDetailsPage(
                                        programDetails: {
                                          'dname': programList[0]['dname'],
                                          'pname': programList[0]['pname'],
                                          'sdate': programList[0]['sdate'],
                                          'edate': programList[0]['edate'],
                                          'Semester': programList[0]
                                              ['Semester'],
                                          'NTS': programList[0]['NTS'],
                                          'description': programList[0]
                                              ['description'],
                                          'GAT': programList[0]['GAT'],
                                          'Other': programList[0]['Other'],
                                          'Type': programList[0]['Type'],
                                          'amount': programList[0]['amount']

                                          // Add more fields as needed
                                        },
                                        programCourses: programCourses,
                                      ),
                                    ),
                                  );
                                } else {
                                  print(
                                    'Failed to fetch program courses. Reason: ${coursesResponse.reasonPhrase}',
                                  );
                                }
                              } else {
                                print(
                                  'Failed to fetch user program. Reason: ${programResponse.reasonPhrase}',
                                );
                              }
                            } catch (error) {
                              print('Error Occurred: $error');
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(200, 50),
                      padding: const EdgeInsets.all(16),
                    ),
                    child: Center(
                      child: Text(
                        '${degreeName ?? ''}  ${programName ?? ''}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Programs(
                      universityName: widget.universityName,
                      uid: widget.uid,
                      proid: widget.progid!,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Programs',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShowScholarship(uid: widget.uid),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Scholarships',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ShowFacultyHEC(uid: widget.uid),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Faculty',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => ShowTestimonial(
                            uid: widget.uid,
                            // name: null,
                            // Currentlydoing: null,
                            // Testinmial: null,
                          )),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Testimonial',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Replace the URL with the one you want to open

                launchURL(widget.url!);
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Admission',
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Rating(
                      //universityName: widget.universityName,
                      uid: widget.uid,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 50),
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Rating',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
