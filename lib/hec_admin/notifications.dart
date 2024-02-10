import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ups/hec_admin/show_uni.dart';
import '../Global/Global.dart';
import 'Model/getRegister_model.dart';

class NotificationScreen extends StatefulWidget {
  final String type;
  const NotificationScreen({Key? key, required this.type}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<GetRegister> notifications = [];

  @override
  void initState() {
    super.initState();
    handleNotification();
  }

  Future<void> handleNotification() async {
    try {
      final response = await http.get(
        Uri.parse('$ip/Admin/Seenotification?Type=${widget.type}'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<GetRegister> data =
            getRegisterFromJson(utf8.decode(response.bodyBytes));
        print(data);
        setState(() {
          notifications = data;
        });
      } else {
        print('Request failed');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> handleAccept(int uid) async {
    try {
      print('Selected University Id: $uid');
      if (widget.type == 'Sponsor') {
        print('University Id: $uid');
        var formData = {'Sponsor': 'true'};
        var response = await http.post(
          Uri.parse('$ip/University/addUniversity?uid=$uid'),
          body: formData,
        );

        if (response.statusCode == 200) {
          var data = response.body;
          print(data);
          print('University Sponsor successfully');
          handleStatus(uid);
          showSnackBarMessage('University Sponsor successfully');
        } else {
          print('Not added');
          showSnackBarMessage('Failed to accept university');
        }
      } else {
        print('University Id: $uid');
        var formData = {'status': true.toString()};

        var response = await http.post(
          Uri.parse('$ip/University/addUniversity?uid=$uid'),
          body: formData,
        );

        if (response.statusCode == 200) {
          var data = response.body;
          print(data);
          handleStatus(uid);
          print('University Register successfully');
          showSnackBarMessage('University Register successfully');
        } else {
          print('Not added');
          showSnackBarMessage('Failed to accept university');
        }
      }
    } catch (error) {
      print('Error: $error');
      showSnackBarMessage('Error: $error');
    }
  }

  Future<void> handleStatus(int uid) async {
    try {
      print('Selected University Id: $uid');
      print(widget.type);
      var status = true;
      var formData = {'Status': status.toString()};

      var response = await http.post(
        Uri.parse('$ip/Admin/AcceptReject?uid=$uid&type=$Type'),
        body: formData,
      );

      print(widget.type);

      if (response.statusCode == 200) {
        var data = response.body;
        print(data);
        handleNotification();
        showSnackBarMessage('Action successful');
      } else {
        throw Exception('Request failed');
      }
    } catch (error) {
      print('Error: $error');
      showSnackBarMessage('Error: $error');
    }
  }

  void handleUniversity(int uid) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => Universitydata(
                uid: uid,
              )),
    );
  }

  // Function to show a SnackBar with a given message
  void showSnackBarMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Universities'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Universities',
            style: TextStyle(fontSize: 24),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(notification.uName),
                        Text(
                          notification.city,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () => handleAccept(notification.uid),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            elevation: 3,
                          ),
                          child: const Text('Accept'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => handleStatus(notification.uid),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            elevation: 3,
                          ),
                          child: const Text('Reject'),
                        ),
                      ],
                    ),
                    trailing: SizedBox(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          imageURL + (notification.image ?? ''),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    onTap: () {
                      handleUniversity(notification.uid);
                    },
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
