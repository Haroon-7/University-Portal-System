import 'package:flutter/material.dart';
import 'package:ups/login_signup/API/api.dart';
import 'package:ups/login_signup/Model/signup_model.dart';
import 'package:ups/login_signup/Model/user_signup.dart';
import 'package:ups/login_signup/login.dart';
import 'package:ups/widgets/responsive_button.dart';

import '../uni_admin/dashboard.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to the login page
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Create an Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ResponsiveButton(
                onPressed: () async {
                  String username = _usernameController.text.toString();
                  String password = _passwordController.text.toString();

                  if (username.isEmpty || password.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sign Up Error'),
                          content: const Text(
                              'Please enter both username and password.'),
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
                  } else {
                    UserSignUp u = UserSignUp();
                    u.name = username;
                    u.password = password;

                    int code = await APIHandler().SignUpAccount(u);

                    if (code == 200) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Account Created Successfully'),
                            content:
                                const Text('Account Created Successfully.'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  ); // Close the dialog box
                                },
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
                            title: const Text('Sign Up Failed'),
                            content: const Text(
                                'Sign Up Failed. Please provide valid credentials.'),
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
                },
                requiredText: 'Sign Up as University Admin',
                height: 30, // You can adjust the height here
              ),
              const SizedBox(
                height: 20,
              ),
              ResponsiveButton(
                onPressed: () async {
                  String username = _usernameController.text.toString();
                  String password = _passwordController.text.toString();

                  if (username.isEmpty || password.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Sign Up Error'),
                          content: const Text(
                              'Please enter both username and password.'),
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
                  } else {
                    SignUpUser a = SignUpUser();
                    a.name = username;
                    a.password = password;

                    int code = await APIHandler().UserSignUpAccount(a);

                    if (code == 200) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Account Created Successfully'),
                            content:
                                const Text('Account Created Successfully.'),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginPage()),
                                  ); // Close the dialog box
                                },
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
                            title: const Text('Sign Up Failed'),
                            content: const Text(
                                'Sign Up Failed. Please provide valid credentials.'),
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
                },
                requiredText: 'Sign Up as User',
                height: 30, // You can adjust the height here
              )
            ],
          ),
        ),
      ),
    );
  }
}
