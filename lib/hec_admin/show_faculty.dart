import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

import '../Global/Global.dart';

class ShowFacultyHEC extends StatefulWidget {
  final int uid;

  ShowFacultyHEC({required this.uid});

  @override
  _ShowFacultyHECState createState() => _ShowFacultyHECState();
}

class _ShowFacultyHECState extends State<ShowFacultyHEC> {
  List<Map<String, dynamic>> faculty = [];
  String link = '';

  @override
  void initState() {
    super.initState();
    handleUniversity();
  }

  Future<void> handleUniversity() async {
    try {
      final response =
      await http.get(Uri.parse('$ip/Admin/showuniversityFaculty?uid=${widget.uid}'));

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> data =
        (json.decode(response.body) as List).cast<Map<String, dynamic>>();
        print(data);
        setState(() {
          faculty = data;
          link = data.isNotEmpty ? data[0]['Flink'] ?? '' : '';
        });
      } else {
        print('Request failed');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> openLinkInBrowser() async {
    if (await canLaunch(link)) {
      await launch(link);
    } else {
      print('Could not launch $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faculty Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: faculty.isEmpty
            ? const Center(
          child: Text(
            'No Faculty data available',
            style: TextStyle(fontSize: 24),
          ),
        )
            : Column(
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rank',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Total',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: faculty.length,
              itemBuilder: (context, index) {
                final item = faculty[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['Rank'] != null
                        ? item['Rank'].toString()
                        : 'N/A'),
                    const VerticalDivider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Text(item['total'] != null
                        ? item['total'].toString()
                        : 'N/A'),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            const Text(
              'Faculty Link:',
              style: TextStyle(fontSize: 24),
            ),
            Linkify(
              onOpen: (link) => openLinkInBrowser(),
              text: link,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
