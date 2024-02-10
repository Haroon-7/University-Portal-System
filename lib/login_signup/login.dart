import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:ups/hec_admin/Dashboard.dart';
import 'package:ups/login_signup/API/api.dart';
import 'package:ups/login_signup/Model/login_model.dart';
import 'package:ups/login_signup/Model/user_login_model.dart';
import 'package:ups/navpages/Search.dart';

import 'package:ups/login_signup/signup.dart';
import 'package:ups/uni_admin/dashboard.dart';

import '../Global/Global.dart';

class LoginPage extends StatefulWidget {
  final universityName;
  const LoginPage({Key? key, this.universityName}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String role = 'University';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/UPS.png', // Replace with your image path
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 10),
              const Text(
                'UNIVERSITY PORTAL SYSTEM',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButton<String>(
                value: role,
                onChanged: (String? newValue) {
                  setState(() {
                    role = newValue!;
                  });
                },
                items: <String>['University', 'HEC', 'User']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  obscureText: !_passwordVisible,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    if (_usernameController.text.isEmpty ||
                        _passwordController.text.isEmpty) {
                      // Show an alert for empty credentials
                      AlertDialog(
                        title: const Text('Login Failed'),
                        content: const Text(
                            'Login Failed. Please provide valid credentials.'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog box
                            },
                          ),
                        ],
                      );
                    } else {
                      String name = _usernameController.text;
                      String password = _passwordController.text;

                      if (role == 'HEC') {
                        // HEC login logic
                        var response =
                            await APIHandler().adminlogin(name, password);

                        if (response.statusCode == 200) {
                          // Login successful
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Login Success'),
                                content: const Text('Login Successful.'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog box
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          // Navigate to the HEC dashboard
                          // ignore: use_build_context_synchronously
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HECHome(), // Adjust the HEC dashboard page
                            ),
                          );
                        } else {
                          // Handle login failure, e.g., show an error message
                          print('Login failed');
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Login Failed'),
                                content: const Text(
                                    'Login Failed. Please provide valid credentials.'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog box
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else if (role == 'User') {
                        // User login logic
                        var response =
                            await APIHandler().Userlogin(name, password);

                        if (response.statusCode == 200) {
                          var json = jsonDecode(response.body);
                          loggedInUser = UserLogin.fromMap(json);
                          Usid = json['Usid'];
                          // Login successful
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Login Success'),
                                content: const Text('Login Successful.'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog box
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                if (loggedInUser != null) {
                                  return SearchPage();
                                } else {
                                  // Handle the case where loggedInUni is null
                                  // You might want to provide a default value or show an error message.
                                  return const LoginPage(); // Replace PlaceholderWidget with your logic
                                }
                              },
                            ),
                          );
                        } else {
                          // Handle login failure, e.g., show an error message
                          print('Login failed');
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Login Failed'),
                                content: const Text(
                                    'Login Failed. Please provide valid credentials.'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog box
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      } else if (role == 'University') {
                        // User login logic
                        var response = await APIHandler().login(name, password);

                        if (response.statusCode == 200) {
                          var json = jsonDecode(response.body);
                          loggedInUni = LoginUser.fromMap(json);
                          uid = json['uid'];
                          // Login successful
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Login Success'),
                                content: const Text('Login Successful.'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog box
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                          // ignore: use_build_context_synchronously
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                if (loggedInUni != null) {
                                  return Dashboard(
                                    loginuserid: loggedInUni!,
                                    uid: uid,
                                  );
                                } else {
                                  // Handle the case where loggedInUni is null
                                  // You might want to provide a default value or show an error message.
                                  return const LoginPage(); // Replace PlaceholderWidget with your logic
                                }
                              },
                            ),
                          );
                        } else {
                          // Handle login failure, e.g., show an error message
                          print('Login failed');
                          // ignore: use_build_context_synchronously
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Login Failed'),
                                content: const Text(
                                    'Login Failed. Please provide valid credentials.'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.pop(
                                          context); // Close the dialog box
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    }
                  } catch (error) {
                    print('Login error: $error');
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error Occurred'),
                          content: const Text('An error occurred.'),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog box
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignupPage()),
                      );
                    },
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                child: const Text('Enter without login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
