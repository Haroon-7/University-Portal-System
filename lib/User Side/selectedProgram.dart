import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProgramDetailsPage extends StatefulWidget {
  const ProgramDetailsPage(
      {Key? key, required this.programDetails, required this.programCourses})
      : super(key: key);

  final Map<String, dynamic> programDetails;
  final List<dynamic> programCourses;

  @override
  State<ProgramDetailsPage> createState() => _ProgramDetailsPageState();
}

class _ProgramDetailsPageState extends State<ProgramDetailsPage> {
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
        title: const Text('Program Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Program'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      ' ${widget.programDetails['dname']} ${widget.programDetails['pname']}'),

                  // Add more details as needed
                ],
              ),
              // Add more details as needed
              onTap: () {
                // Handle tap event for the second ListTile
              },
            ),
            ListTile(
              title: const Text('Semester'),
              subtitle: Text(widget.programDetails['Semester'].toString()),
            ),
            ListTile(
              title: const Text('Admission'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      'Start Date: ${formatDate(widget.programDetails['sdate'])}'),
                  Text(
                      'End Date: ${formatDate(widget.programDetails['edate'])}'),

                  // Add more details as needed
                ],
              ),
              // Add more details as needed
              onTap: () {
                // Handle tap event for the second ListTile
              },
            ),
            ListTile(
              title: const Text('NTS'),
              subtitle: Text(widget.programDetails['NTS'].toString()),
            ),
            ListTile(
              title: const Text('Description'),
              subtitle: Text(widget.programDetails['description'].toString()),
            ),
            ListTile(
              title: const Text('GAT'),
              subtitle: Text(widget.programDetails['GAT'].toString()),
            ),
            ListTile(
              title: const Text('Other'),
              subtitle: Text(widget.programDetails['Other'].toString()),
            ),
            ListTile(
              title: const Text('Type'),
              subtitle: Text(widget.programDetails['Type'].toString()),
            ),
            ListTile(
              title: const Text('Fee'),
              subtitle: Text(widget.programDetails['amount'].toString()),
            ),
            const SizedBox(height: 20),
            const Text(
              'Program Courses:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                const TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Title'),
                      ),
                    ),
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Credit Hours'),
                      ),
                    ),
                  ],
                ),
                for (var course in widget.programCourses)
                  TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(course['title'].toString()),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(course['crhour'].toString()),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
