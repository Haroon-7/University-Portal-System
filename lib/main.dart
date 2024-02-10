import 'package:flutter/material.dart';
import 'package:ups/hec_admin/Dashboard.dart';
import 'package:ups/login_signup/login.dart';
import 'package:ups/navpages/Search.dart';
import 'package:ups/uni_admin/add_university.dart';
import 'package:ups/uni_admin/faculties.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: const LoginPage(),
    );
  }
}
