import 'package:flutter/material.dart';
import 'package:ups/uni_admin/departments.dart';
import '../Global/Global.dart';
import '../login_signup/login.dart';
import 'enrolled_uni.dart';
import 'notifications.dart';

class HECHome extends StatefulWidget {
  @override
  _HECHomeState createState() => _HECHomeState();
}

class _HECHomeState extends State<HECHome> {
  // Updated user details
  Map<String, dynamic> userDetails = {
    "Hid": 1,
    "name": "Haroon",
    "email": "mharoon0510@gmail.com",
    "contact": "03180056656",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HEC'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(
                        'assets/HEC.gif'), // Replace with your image asset
                  ),

                  SizedBox(height: 10),
                  // Display updated user details
                  Text(
                    'Name: ${userDetails["name"]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Email: ${userDetails["email"]}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Contact: ${userDetails["contact"]}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HECHome(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.school),
              title: Text('Enrolled University'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Enrolled(uid: uid),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Registration Request'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(type: 'Register'),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.star),
              title: Text('Sponsor Request'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationScreen(type: 'Sponsor'),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.dashboard),
            //   title: Text('Departments'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => Departments(),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Enrolled(uid: uid),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // Set the desired width and height
              ),
              child: Text('Enrolled University'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(type: 'Register'),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // Set the desired width and height
              ),
              child: Text('Registration Request'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(type: 'Sponsor'),
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 50), // Set the desired width and height
              ),
              child: Text('Sponsor Request'),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
