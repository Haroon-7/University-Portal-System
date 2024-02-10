import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ups/hec_admin/show_uni.dart';
import '../Global/Global.dart';
import 'Model/get_enrolled_model.dart';

class Enrolled extends StatefulWidget {
  const Enrolled({Key? key, int? uid}) : super(key: key);

  @override
  State<Enrolled> createState() => _EnrolledState();
}

class _EnrolledState extends State<Enrolled> {
  List<ShowEnrolledUniversity> universities = [];

  @override
  void initState() {
    super.initState();
    handleUniversity();
  }

  Future<void> handleUniversity() async {
    print('$ip/Admin/showEnrolldUniversties');
    try {
      final response = await http.get(
        Uri.parse('$ip/Admin/showEnrolldUniversties'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final List<ShowEnrolledUniversity> enrolledUniversities =
        data.map((e) => ShowEnrolledUniversity.fromJson(e)).toList();

        print('Data received: $enrolledUniversities');
        setState(() {
          universities = enrolledUniversities;
        });
      } else {
        print('Request failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Display a user-friendly error message on the UI or handle accordingly
      }
    } catch (error) {
      print('Error: $error');
      // Display a user-friendly error message on the UI or handle accordingly
    }
  }

  void selectUniversity(int? uid) {
    print(uid ?? 'UID is null');
    if (uid != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Universitydata(uid: uid,),
        ),
      );
    } else {
      // Handle the case where uid is null
      print('UID is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universities'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Universities',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: universities.length,
              itemBuilder: (context, index) {
                final university = universities[index];
                return GestureDetector(
                  onTap: () {
                    selectUniversity(university.uid);
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                    child: ListTile(
                      title: Text(university.uName),
                      subtitle: Text(university.city),
                      trailing: Container(
                        width: 50,
                        height: 50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            imageURL + university.image,
                            // Replace with actual image URL
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}