import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ups/Global/Global.dart';

class AdmissionNotification {
  final String universityName;
  final String degreeName;
  final String programName;

  AdmissionNotification({
    required this.universityName,
    required this.degreeName,
    required this.programName,
  });
}

class UserNotifications extends StatefulWidget {
  const UserNotifications({Key? key}) : super(key: key);

  @override
  State<UserNotifications> createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  Future<List<AdmissionNotification>> getAdmissionNotifications(
      DateTime date) async {
    try {
      final response = await http.get(
        Uri.parse('$ip/User/AdmissionNotification?date=$date'),
      );

      if (response.statusCode == 200) {
        final List<Map<String, dynamic>> notifications =
            List<Map<String, dynamic>>.from(json.decode(response.body));

        print('Fetched Notifications: $notifications');

        List<AdmissionNotification> admissionNotifications = notifications
            .map((notification) => AdmissionNotification(
                  universityName: notification['u_name'],
                  degreeName: notification['dname'],
                  programName: notification['pname'],
                ))
            .toList();
        return admissionNotifications;
      } else {
        print(
            'Failed to fetch admission notifications: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error Occurred: $error');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admission Notifications'),
      ),
      body: FutureBuilder<List<AdmissionNotification>>(
        future: getAdmissionNotifications(DateTime.now()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No Admission Notifications available.'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                AdmissionNotification notification = snapshot.data![index];
                return ListTile(
                  title: Text('University: ${notification.universityName}'),
                  subtitle: Text(
                      'Degree: ${notification.degreeName}\nProgram: ${notification.programName}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
