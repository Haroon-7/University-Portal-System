import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ups/login_signup/login.dart';
import 'package:ups/uni_admin/add_admission.dart';
import 'package:ups/uni_admin/add_testimonial.dart';
import 'package:ups/uni_admin/departments.dart';
import '../Global/Global.dart';
import '../hec_admin/notifications.dart';
import '../hec_admin/show_uni.dart';
import '../login_signup/Model/login_model.dart';
import '../widgets/build_tile.dart';
import '../widgets/responsive_button.dart';
import 'add_degree.dart';
import 'add_university.dart';
import 'faculties.dart';
import 'scholarship.dart';
import 'view_university.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required LoginUser loginuserid, int? uid})
      : loginuserid = loginuserid,
        uid = uid,
        super(key: key);

  final LoginUser loginuserid;
  final int? uid;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  bool isRegistered = false;
  bool issponsor = false;

  @override
  void initState() {
    super.initState();
    getUniversityStatus();
  }

  Future<void> getUniversityStatus() async {
    try {
      final response = await http.get(
        Uri.parse('$ip/Admin/Universitystatus?uid=${widget.uid}'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isRegistered = data['is_registered']?.toLowerCase() == 'true';
          issponsor = data['IS_Sponser'] != null &&
              data['IS_Sponser'].toString().toLowerCase() == 'true';
        });
      } else {
        print('Not added');
      }
    } catch (error) {
      print('Error Occurred: $error');
    }
  }

  Future<void> RegisterUniversity() async {
    try {
      // Check if all required items are filled
      if (isRegistered) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("University Already Added"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        bool confirmRegistration = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmation'),
              content: const Text(
                  'Are you sure you want to register the university?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        if (confirmRegistration == true) {
          // If user confirms, send the registration request
          final response = await http.post(
            Uri.parse(
              '$ip/University/AddNotification?IsRead=false&Type=Register&uid=${widget.uid}',
            ),
            body: {
              'uid': widget.uid.toString(),
              'Notifications': 'I want to Register my University',
            },
          );

          if (response.statusCode == 200) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Request Sent Successfully'),
                  content: const Text(
                    'Your registration request has been sent successfully.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Already Registered'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        }
      }
    } catch (error) {
      print('Error Occurred: $error');
    }
  }

  addOrUpdateSponsorDate(
      int uid, String sdate, String edate, String days) async {
    try {
      var response = await http.post(
        Uri.parse("$ip/Possibletask/AddorupdateSponsordate?uid=${widget.uid}"),
        body: {
          //'uid': uid.toString(),
          'sdate': sdate,
          'edate': edate,
          'days': days,
        },
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Applied Successfully"),
          ),
        );
        var request = await http.post(
          Uri.parse('$ip/University/AddNotification?uid=${widget.uid}'),
          body: {
            'IsRead': "false",
            'Type': 'Sponsor',
            'Notifications': 'I want to Sponsor my University',
          },
        );
        if (request.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Notification Sent Successfully"),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Notification Sent UnSuccessfully"),
            ),
          );
        }
        // Successfully added or updated sponsor date
      } else {
        // Handle error scenarios here
        throw Exception('Failed to add or update sponsor date');
      }
    } catch (error) {
      // Handle exceptions here
      throw Exception('Error: $error');
    }
  }

  sendnotificaton() async {
    try {} catch (E) {
      //
    }
  }

  Future<int?> showDurationDialog(BuildContext context) async {
    int? selectedDuration;

    return showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Sponsorship Duration'),
          content: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  selectedDuration = 7; // 7 days
                  await addOrUpdateSponsorDate(
                    uid!,
                    DateTime.now().toString(),
                    DateTime.now()
                        .add(Duration(days: selectedDuration!))
                        .toString(),
                    selectedDuration.toString(),
                  );
                  Navigator.pop(context, selectedDuration);
                },
                child: const Text('7 days'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  selectedDuration = 30; // 30 days
                  addOrUpdateSponsorDate(
                    uid!,
                    DateTime.now().toString(),
                    DateTime.now()
                        .add(Duration(days: selectedDuration!))
                        .toString(),
                    selectedDuration.toString(),
                  );
                },
                child: const Text('30 days'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  selectedDuration = 180; // 6 months
                  addOrUpdateSponsorDate(
                    uid!,
                    DateTime.now().toString(),
                    DateTime.now()
                        .add(Duration(days: selectedDuration!))
                        .toString(),
                    selectedDuration.toString(),
                  );
                },
                child: const Text('6 months'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Welcome ${loggedInUni?.name ?? ""}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                // Add your navigation logic here
              },
            ),
            ListTile(
              title: const Text('Testimonials'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Testimonial(
                        loginuserid: loggedInUni!, uid: widget.loginuserid.uid),
                  ),
                );
                // Add your navigation logic here
              },
            ),
            // ListTile(
            //   title: const Text('Department'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (_) => Departments(),
            //       ),
            //     );
            //     // Add your navigation logic here
            //   },
            // ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                _showLogoutConfirmationDialog();
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildTile(
                  'assets/Logo2.png',
                  'Add University',
                  () {
                    void nextScreen() {
                      if (isRegistered) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("University Already Added"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                UniversityPage(loginuserid: loggedInUni!),
                          ),
                        );
                      }
                    }

                    nextScreen();
                  },
                ),
                const SizedBox(width: 20),
                buildTile(
                  'assets/Logo.png',
                  'Add Degrees',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddDegree(loginuserid: loggedInUni!),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildTile(
                  'assets/Logo3.png',
                  'Add Faculty',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddFaculties(
                          loginuserid: loggedInUni!,
                          uid: widget.loginuserid.uid,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(
                  width: 20,
                ),
                buildTile(
                  'assets/Logo2.png',
                  'Show University',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => /*ShowUniversity(uid: loggedInUni!.uid,)*/
                                Universitydata(
                          uid: loggedInUni!.uid,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildTile(
                  'assets/Logo4.png',
                  'Scholarships',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScholarshipScreen(
                            loginuserid: loggedInUni!,
                            uid: widget.loginuserid.uid),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
                buildTile(
                  'assets/Logo8.png',
                  'Sponsor University',
                  () async {
                    try {
                      await getUniversityStatus(); // Wait for the status check
                      if (isRegistered) {
                        if (issponsor) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                    'University is Already Sponsored'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Message'),
                                content: const Text(
                                    'Do you really want to sponsor university?'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      int? sponsorshipDuration =
                                          await showDurationDialog(context);
                                    },
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('No'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title:
                                  const Text('First Register the University'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } catch (error) {
                      print('Error Occurred: $error');
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildTile(
                  'assets/Logo7.png',
                  'Reg Request',
                  () {
                    RegisterUniversity();
                  },
                ),
                const SizedBox(width: 40),
                buildTile(
                  'assets/Admission_logo.png',
                  'Admission',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AddAdmission(
                          uid: widget.loginuserid.uid,
                          lognuserid: widget.loginuserid,
                          u_name: '',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF5d69b3),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          /*BottomNavigationBarItem(
            icon: Icon(Icons.notification_add),
            label: 'Notifications',
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'My',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(loginuserid: loggedInUni!),
            ),
          );
          break;
        /*case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NotificationScreen(type: ''),
            ),
          );
          break;*/
        case 1:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(loginuserid: loggedInUni!),
            ),
          );
          break;
      }
    });
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
